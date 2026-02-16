import { NextRequest, NextResponse } from 'next/server'
import { createClient } from '@/lib/supabase/server'
import { sendEmail, getAdminEmails, formatStarRating } from '@/lib/email'

export async function POST(request: NextRequest) {
  try {
    const body = await request.json()

    const { facility_id, reviewer_name, google_account_name, email, review_star, feedback } = body

    // バリデーション
    if (!facility_id || !reviewer_name || !google_account_name || !email || !review_star) {
      return NextResponse.json(
        { error: '必須項目が入力されていません' },
        { status: 400 }
      )
    }

    const supabase = await createClient()

    // 施設情報を取得（メール送信用）
    const { data: facilityData } = await supabase
      .from('facility_details')
      .select('name')
      .eq('id', facility_id)
      .single()

    const facilityName = facilityData?.name || '施設'

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
      return NextResponse.json(
        { error: 'データの保存に失敗しました' },
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
      const emailPromises = []

      // 1. 管理者通知メール
      const adminEmails = getAdminEmails()
      if (adminEmails.length > 0) {
        const adminEmailBody = `${facilityName} に新しいアンケート回答がありました。

■ 回答内容
━━━━━━━━━━━━━━━━━━━━━━━━
評価: ${formatStarRating(review_star)}
お名前: ${reviewer_name}様
メールアドレス: ${email}
Googleアカウント名: ${google_account_name}
${feedback ? `
ご意見・ご感想:
${feedback}` : ''}

■ 次のステップ
この回答に対するクチコミ確認は、自動的に処理されます。
確認結果は別途メールでお知らせします。
`

        emailPromises.push(
          sendEmail({
            to: adminEmails,
            subject: `【新規アンケート回答】${facilityName}`,
            body: adminEmailBody,
          }).catch(error => {
            console.error('Error sending admin notification email:', error)
          })
        )
      }

      // 2. アンケート送信者へのThank youメール
      const thankYouEmailBody = `${reviewer_name}様

この度は${facilityName}のアンケートにご回答いただき、
誠にありがとうございます。

お客様からいただいた貴重なご意見は、
今後のサービス向上に役立たせていただきます。

クチコミの確認が完了しましたら、
改めてご連絡させていただきます。

今後とも${facilityName}をよろしくお願いいたします。
`

      emailPromises.push(
        sendEmail({
          to: email,
          subject: `アンケートへのご回答ありがとうございます - ${facilityName}`,
          body: thankYouEmailBody,
        }).catch(error => {
          console.error('Error sending thank you email:', error)
        })
      )

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
