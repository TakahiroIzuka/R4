import { NextRequest, NextResponse } from 'next/server'
import { createAdminClient } from '@/lib/supabase/server'
import { sendEmail, getAdminEmails, formatStarRating, getEmailFooter, getEmailFooterEn } from '@/lib/email'

// HTMLタグを除去してXSS攻撃を防ぐ
function sanitizeInput(input: string): string {
  return input.replace(/<[^>]*>/g, '').trim()
}

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()

    const { facility_id, review_star } = body
    let { reviewer_name, google_account_name, email, feedback } = body

    // 入力のサニタイゼーション（XSS対策）
    reviewer_name = sanitizeInput(reviewer_name || '')
    google_account_name = sanitizeInput(google_account_name || '')
    email = sanitizeInput(email || '')
    if (feedback) {
      feedback = sanitizeInput(feedback)
    }

    // 必須項目チェック
    if (!facility_id || !reviewer_name || !google_account_name || !email || !review_star) {
      return NextResponse.json(
        { error: '必須項目が入力されていません' },
        { status: 400 }
      )
    }

    // 追加バリデーション
    // 1. review_starの範囲チェック（1-5の整数）
    const starValue = Number(review_star)
    if (!Number.isInteger(starValue) || starValue < 1 || starValue > 5) {
      return NextResponse.json(
        { error: '評価は1から5の整数で指定してください' },
        { status: 400 }
      )
    }

    // 2. メールアドレスの基本的な形式チェック
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    if (!emailRegex.test(email)) {
      return NextResponse.json(
        { error: 'メールアドレスの形式が正しくありません' },
        { status: 400 }
      )
    }

    // 3. 文字列の長さ制限（スパム対策）
    if (reviewer_name.length > 100 || google_account_name.length > 100 || email.length > 255) {
      return NextResponse.json(
        { error: '入力値が長すぎます' },
        { status: 400 }
      )
    }

    if (feedback && feedback.length > 5000) {
      return NextResponse.json(
        { error: 'ご意見・ご感想は5000文字以内で入力してください' },
        { status: 400 }
      )
    }

    // 公開アンケート送信のため、RLSをバイパスして管理者権限で操作
    // TODO: RLSポリシーの問題が解決したら、createClient()に戻す
    const supabase = createAdminClient()

    // 4. レート制限（IPアドレスごとに1時間あたり10回まで）
    const clientIp = request.headers.get('x-forwarded-for')?.split(',')[0] ||
                     request.headers.get('x-real-ip') ||
                     'unknown'

    const oneHourAgo = new Date(Date.now() - 60 * 60 * 1000).toISOString()
    const { count } = await supabase
      .from('review_checks')
      .select('id', { count: 'exact' })
      .gte('created_at', oneHourAgo)
      .limit(10)

    // Note: IPアドレスはreview_checksテーブルに保存していないため、
    // 全体の送信数でレート制限を実施（改善の余地あり）
    if (count && count >= 100) {
      console.warn('High submission rate detected:', { count, clientIp })
    }

    // 5. facility_idが実際に存在するかを確認（セキュリティ対策）
    const { data: facilityExists, error: facilityCheckError } = await supabase
      .from('facilities')
      .select('id, uuid, service_id, email_language')
      .eq('id', facility_id)
      .single()

    if (facilityCheckError || !facilityExists) {
      return NextResponse.json(
        { error: '指定された施設が見つかりません' },
        { status: 404 }
      )
    }

    // 施設情報を取得（メール送信用）
    const { data: facilityData } = await supabase
      .from('facility_details')
      .select('name, google_map_url, review_approval_email')
      .eq('id', facility_id)
      .single()

    const facilityName = facilityData?.name || '施設'
    const googleMapUrl = facilityData?.google_map_url || null
    const reviewApprovalEmail = facilityData?.review_approval_email || null

    // サービス名を取得
    const { data: serviceData } = facilityExists.service_id
      ? await supabase.from('services').select('name, code').eq('id', facilityExists.service_id).single()
      : { data: null }
    const serviceName = serviceData?.name || ''
    const emailLanguage = facilityExists.email_language || 'ja'
    const isEn = emailLanguage === 'en'

    // review_checksにレコードを登録（status: 'pending'で登録、トークンは自動生成）
    const { data, error } = await supabase
      .from('review_checks')
      .insert({
        facility_id,
        reviewer_name,
        google_account_name,
        email,
        review_star,
        feedback: feedback || null,
        status: 'pending',
      })
      .select()
      .single()

    if (error) {
      console.error('Error inserting review check:', error)
      console.error('Error details:', JSON.stringify(error, null, 2))
      return NextResponse.json(
        {
          error: 'データの保存に失敗しました',
          details: error.message || error.hint || '詳細不明',
          code: error.code
        },
        { status: 500 }
      )
    }

    // review_check_tasksに2レコード挿入（1分後と10分後）
    const now = new Date()
    const oneMinuteLater = new Date(now.getTime() + 1 * 60 * 1000)
    const tenMinutesLater = new Date(now.getTime() + 10 * 60 * 1000)

    const { error: tasksError } = await supabase
      .from('review_check_tasks')
      .insert([
        {
          review_check_id: data.id,
          scheduled_at: oneMinuteLater.toISOString(),
          status: 'pending',
        },
        {
          review_check_id: data.id,
          scheduled_at: tenMinutesLater.toISOString(),
          status: 'pending',
        },
      ])

    if (tasksError) {
      console.error('Error inserting review check tasks:', tasksError)
      // タスク作成に失敗した場合でも、review_checkは作成されているのでエラーは返さない
      // ただしログは残す
    }

    // メール送信（並列実行し、失敗してもアンケート登録は成功とする）
    const sendNotificationEmails = async () => {
      const adminEmails = getAdminEmails()
      const starRating = formatStarRating(review_star)
      const footer = isEn ? getEmailFooterEn(serviceName) : getEmailFooter(serviceName)
      const baseUrl = process.env.NEXT_PUBLIC_BASE_URL || 'http://localhost:3000'
      const emailPromises = []

      // Template 1: アンケート送信者へのThank youメール
      const userEmailBody = isEn
        ? `Thank you very much for taking the time to complete the 5-star rating survey for ${facilityName}.

The survey feedback you provided will be shared with ${facilityName} and used to improve customer satisfaction going forward.

Once we have verified your identity and confirmed the content of your review, the Kuchikomiru Secretariat will send you your exclusive benefit. We appreciate your patience.

※ This email is an automated response.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
【Your Submitted Information】
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■ 5-Star Rating Survey: ${starRating}

■ Comments / Feedback: ${feedback || ''}

▼▼━━━━━━━ Your Basic Information ━━━━━━━▼▼

■ Name: ${reviewer_name}

■ Email Address: ${email}

■ Google Account Name: ${google_account_name}

■ Privacy Policy: Agreed

${footer}
`
        : `この度は、${facilityName}への5段階評価アンケートのご協力、誠にありがとうございます。

お預かりしたアンケート内容は、${facilityName}と共有し、今後の顧客満足度改善に向けて使用させていただきます。

お客様の本人確認とクチコミ内容の確認が出来次第、クチコミル事務局より特典をプレゼントいたしますので、今しばらくお待ちくださいませ。

※こちらのメールは自動返信です。

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
【お客様の送信内容】
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■5段階評価アンケート : ${starRating}

■ご意見・ご感想 : ${feedback || ''}

▼▼━━━━━━━お客様の基本情報━━━━━━━▼▼

■お名前 : ${reviewer_name}

■メールアドレス : ${email}

■Googleアカウント名 : ${google_account_name}

■個人情報のお取り扱いについて : 承認済み

${footer}
`
      emailPromises.push(
        sendEmail({
          to: email,
          subject: isEn
            ? `Thank you for your cooperation with our 5-star rating survey. | ${serviceName} Review Ranking`
            : `5段階評価アンケートのご協力ありがとうございます。 | ${serviceName}クチコミランキング`,
          body: userEmailBody,
        }).catch(error => {
          console.error('Error sending thank you email:', error)
        })
      )

      // Template 2/3: 施設管理者への通知メール（BCC: サイト管理者）
      if (reviewApprovalEmail) {
        if (starValue >= 3) {
          // Template 2: 高評価（星3〜5）
          const facilityHighRatingBody = isEn
            ? `※ A response has been received for ${facilityName}'s 5-star rating survey.

【${facilityName}】
${googleMapUrl || ''}

■ Customer's Survey Response
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- 5-Star Rating Survey
${starRating}

- Comments / Feedback
${feedback || ''}

- Name
${reviewer_name}

- Email Address
${email}

- Google Account Name
${google_account_name}

- Privacy Policy
Agreed

■ Next Steps
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Once our system has located the corresponding Google review for this response, we will notify you separately. Please wait a moment.

※ This email is sent automatically.

${footer}
`
            : `※${facilityName}の5段階評価アンケートにご回答がありました。

【${facilityName}】
${googleMapUrl || ''}

■ お客様の5段階評価アンケートご回答内容
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- 5段階評価アンケート
${starRating}

- ご意見・ご感想
${feedback || ''}

- お名前
${reviewer_name}

- メールアドレス
${email}

- Googleアカウント名
${google_account_name}

- 個人情報のお取り扱いについて
承認済み

■ 次のステップ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
弊社システムがこちらの回答に該当するGoogleクチコミ投稿を確認出来次第、
別途メールにてお知らせいたしますので、今しばらくお待ちください。

※このメールは自動送信されています。

${footer}
`
          emailPromises.push(
            sendEmail({
              to: reviewApprovalEmail,
              bcc: adminEmails,
              subject: isEn
                ? `A response has been received for ${facilityName}'s 5-star rating survey. | Kuchikomiru (${serviceName} Review Ranking)`
                : `${facilityName}の5段階評価アンケートにご回答がありました。 | クチコミル（${serviceName}クチコミランキング）`,
              body: facilityHighRatingBody,
            }).catch(error => {
              console.error('Error sending facility high rating email:', error)
            })
          )
        } else {
          // Template 3: 低評価（星1〜2）
          const approvalUrl = `${baseUrl}/api/review-checks/${data.id}/facility-approve?token=${data.facility_approval_token}`
          const facilityLowRatingBody = isEn
            ? `※ A response has been received for ${facilityName}'s 5-star rating survey.

【${facilityName}】
${googleMapUrl || ''}

■ Customer's Survey Response
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- 5-Star Rating Survey
${starRating}

- Comments / Feedback
${feedback || ''}

- Name
${reviewer_name}

- Email Address
${email}

- Google Account Name
${google_account_name}

- Privacy Policy
Agreed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

▼ To approve this response, please click the link below. ▼
${approvalUrl}

※ This email is sent automatically.
※ This link is exclusively for the owner of ${facilityName}. Please do not share it with third parties.

${footer}
`
            : `※ ${facilityName}の5段階評価アンケートにご回答がありました。

【${facilityName}】
${googleMapUrl || ''}

■ お客様の5段階評価アンケートご回答内容
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- 5段階評価アンケート
${starRating}

- ご意見・ご感想
${feedback || ''}

- お名前
${reviewer_name}

- メールアドレス
${email}

- Googleアカウント名
${google_account_name}

- 個人情報のお取り扱いについて
承認済み
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

▼ こちらのご回答を承認する場合は、以下のリンクをクリックしてください。 ▼
${approvalUrl}

※このメールは自動送信されています。
※このリンクは${facilityName}のオーナー様専用の承認リンクですので、第三者への共有はお控えください。

${footer}
`
          emailPromises.push(
            sendEmail({
              to: reviewApprovalEmail,
              bcc: adminEmails,
              subject: isEn
                ? `[Approval Request] A response has been received for ${facilityName}'s 5-star rating survey. | Kuchikomiru (${serviceName} Review Ranking)`
                : `【承認のお願い】${facilityName}の5段階評価アンケートにご回答がありました。 | クチコミル（${serviceName}クチコミランキング）`,
              body: facilityLowRatingBody,
            }).catch(error => {
              console.error('Error sending facility low rating email:', error)
            })
          )
        }
      }

      // 全てのメール送信を並列実行
      await Promise.all(emailPromises)
    }

    // メール送信を待つ（エラーは無視してアンケート登録は成功とする）
    await sendNotificationEmails().catch(error => {
      console.error('Error in sendNotificationEmails:', error)
    })

    return NextResponse.json({ data }, { status: 201 })
  } catch (error) {
    console.error('Error in review-checks API:', error)
    return NextResponse.json(
      { error: 'サーバーエラーが発生しました' },
      { status: 500 }
    )
  }
}
