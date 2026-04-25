'use client'

import { useState } from 'react'

interface FacilityEmailPreviewProps {
  facilityId: number
  facilityName: string
  serviceName: string
  serviceCode: string
  googleMapUrl: string | null
  giftCodeAmount: number | null
  facilityUuid: string | null
  baseUrl: string
  currentUserType?: 'admin' | 'user'
  emailLanguage?: string
}

const PJa = {
  reviewerName: '{お名前}',
  email: '{メールアドレス}',
  googleAccountName: '{Googleアカウント名}',
  starRating: '{評価}',
  feedback: '{ご意見・ご感想}',
  reviewUrl: '{GoogleクチコミURL}',
  giftCode: '{ギフトコード}',
  expiresAt: '{有効期限}',
  approvalLink: '{承認リンク}',
  adminDashboardLink: '{管理画面リンク}',
}

const PEn = {
  reviewerName: '{Name}',
  email: '{Email Address}',
  googleAccountName: '{Google Account Name}',
  starRating: '{Rating}',
  feedback: '{Comments / Feedback}',
  reviewUrl: '{Google Review URL}',
  giftCode: '{Gift Code}',
  expiresAt: '{Expiry Date}',
  approvalLink: '{Approval Link}',
  adminDashboardLink: '{Admin Panel Link}',
}

export default function FacilityEmailPreview({
  facilityId: _facilityId,
  facilityName,
  serviceName,
  serviceCode,
  googleMapUrl,
  giftCodeAmount,
  facilityUuid,
  baseUrl,
  currentUserType = 'user',
  emailLanguage = 'ja',
}: FacilityEmailPreviewProps) {
  const [activeTab, setActiveTab] = useState(0)

  const isEn = emailLanguage === 'en'
  const P = isEn ? PEn : PJa

  const jaFooter = `クチコミル（${serviceName}クチコミランキング）事務局
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
運営会社 : 合同会社Rainmans
本社 : 兵庫県神戸市中央区港島中町2-3-8
東京支店 : 東京都杉並区高円寺北3-33-10
メールアドレス : info@mister-review-ranking.com
電話番号 : 050-8893-2668
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`

  const enFooter = `Kuchikomiru (${serviceName} Review Ranking) Secretariat
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Company: Rainmans LLC
Head Office: 2-3-8 Minatojimanakacho, Chuo-ku, Kobe, Hyogo
Tokyo Branch: 3-33-10 Koeji Kita, Suginami-ku, Tokyo
Email: info@mister-review-ranking.com
Phone: 050-8893-2668
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`

  const footer = isEn ? enFooter : jaFooter

  const mapUrl = googleMapUrl || (isEn ? '{Google Maps URL}' : '{GoogleマップURL}')
  const questionnaireUrl = facilityUuid
    ? `${baseUrl}/${serviceCode}/questionnaire/${facilityUuid}`
    : `${baseUrl}/${serviceCode}/questionnaire/${isEn ? '{facility UUID}' : '{施設UUID}'}`
  const amountText = giftCodeAmount !== null ? `${giftCodeAmount}` : '●●●'

  const jaEmails = [
    {
      label: '#1 回答者サンクス',
      trigger: 'アンケート送信直後（全評価共通）',
      to: 'アンケート回答者',
      subject: `5段階評価アンケートのご協力ありがとうございます。 | ${serviceName}クチコミランキング`,
      body: `この度は、${facilityName}への5段階評価アンケートのご協力、誠にありがとうございます。

お預かりしたアンケート内容は、${facilityName}と共有し、今後の顧客満足度改善に向けて使用させていただきます。

お客様の本人確認とクチコミ内容の確認が出来次第、クチコミル事務局より特典をプレゼントいたしますので、今しばらくお待ちくださいませ。

※こちらのメールは自動返信です。

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
【お客様の送信内容】
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■5段階評価アンケート : ${P.starRating}

■ご意見・ご感想 : ${P.feedback}

▼▼━━━━━━━お客様の基本情報━━━━━━━▼▼

■お名前 : ${P.reviewerName}

■メールアドレス : ${P.email}

■Googleアカウント名 : ${P.googleAccountName}

■個人情報のお取り扱いについて : 承認済み

${footer}`,
    },
    {
      label: '#2 高評価・施設管理者通知',
      trigger: 'アンケート送信直後（高評価 ★3〜5）',
      to: '施設管理者（BCC: サイト管理者）',
      subject: `${facilityName}の5段階評価アンケートにご回答がありました。 | クチコミル（${serviceName}クチコミランキング）`,
      body: `※${facilityName}の5段階評価アンケートにご回答がありました。

【${facilityName}】
${mapUrl}

■ お客様の5段階評価アンケートご回答内容
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- 5段階評価アンケート
${P.starRating}

- ご意見・ご感想
${P.feedback}

- お名前
${P.reviewerName}

- メールアドレス
${P.email}

- Googleアカウント名
${P.googleAccountName}

- 個人情報のお取り扱いについて
承認済み

■ 次のステップ
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
弊社システムがこちらの回答に該当するGoogleクチコミ投稿を確認出来次第、
別途メールにてお知らせいたしますので、今しばらくお待ちください。

※このメールは自動送信されています。

${footer}`,
    },
    {
      label: '#3 低評価・施設管理者通知',
      trigger: 'アンケート送信直後（低評価 ★1〜2）',
      to: '施設管理者（BCC: サイト管理者）',
      subject: `【承認のお願い】${facilityName}の5段階評価アンケートにご回答がありました。 | クチコミル（${serviceName}クチコミランキング）`,
      body: `※ ${facilityName}の5段階評価アンケートにご回答がありました。

【${facilityName}】
${mapUrl}

■ お客様の5段階評価アンケートご回答内容
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- 5段階評価アンケート
${P.starRating}

- ご意見・ご感想
${P.feedback}

- お名前
${P.reviewerName}

- メールアドレス
${P.email}

- Googleアカウント名
${P.googleAccountName}

- 個人情報のお取り扱いについて
承認済み
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

▼ こちらのご回答を承認する場合は、以下のリンクをクリックしてください。 ▼
${P.approvalLink}

※このメールは自動送信されています。
※このリンクは${facilityName}のオーナー様専用の承認リンクですので、第三者への共有はお控えください。

${footer}`,
    },
    {
      label: '#4 Googleクチコミ確認後',
      trigger: 'Googleクチコミ投稿確認後（★3〜5 かつ投稿者名一致）',
      to: '施設管理者（BCC: サイト管理者）',
      subject: `【承認のお願い】新しいGoogleクチコミ投稿の確認完了のお知らせ | クチコミル（${serviceName}クチコミランキング）`,
      body: `新しいGoogleクチコミ投稿の確認が完了しました。

■ 新しいGoogleクチコミ投稿の内容
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- 5段階評価アンケート
${P.starRating}

- お名前
${P.reviewerName}

- メールアドレス
${P.email}

- Googleアカウント名
${P.googleAccountName}

- Google Business Profile（Googleマップ）のURL
${mapUrl}

- GoogleクチコミのURL
${P.reviewUrl}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

▼ 承認する場合は、以下のリンクをクリックしてください。 ▼
${P.approvalLink}

※このメールは自動送信されています。
※このリンクは${facilityName}のオーナー様専用の承認リンクですので、第三者への共有はお控えください。

${footer}`,
    },
    {
      label: '#5 クチコミ確認不可',
      trigger: 'Googleクチコミ確認不可（高評価 ★3〜5 かつ投稿見つからず）',
      to: 'アンケート回答者',
      subject: `クチコミル（${serviceName}クチコミランキング）事務局からのお知らせ`,
      body: `${P.reviewerName} 様

この度はお忙しい中、${facilityName}への5段階評価アンケートのご協力、誠にありがとうございます。

クチコミル（${serviceName}クチコミランキング）では、"5段階評価アンケート"と"クチコミ投稿"にご協力していただいた方限定特典として、クチコミル事務局より特典（Amazonギフトコード${amountText}円分）をプレゼントいたしております。

先ほど以下のページで弊社システムが該当するクチコミの照合と本人確認をさせていただいたのですが、${P.reviewerName} 様（Googleアカウントで登録されているお名前 : ${P.googleAccountName}）のクチコミとお見受けできる投稿が確認できませんでした。

以下の理由が考えられます :
- アンケートでご入力されたGoogleアカウント名が一致しない
- クチコミがまだ公開されていない
- クチコミを誤って削除された

大変お手数おかけいたしますが、再度${facilityName}への5段階評価アンケートとクチコミ投稿にご協力していただき、該当するクチコミの照合と本人確認が出来次第、クチコミル事務局より特典（Amazonギフトコード${amountText}円分）をプレゼントいたします。

■ 5段階評価アンケートはこちらから : ${questionnaireUrl}
■ クチコミ投稿はこちらから : ${mapUrl}

※ 5段階評価アンケート送信後から1時間以内に、弊社システムが該当するGoogleクチコミの照合と本人確認を致します。その時点で該当するGoogleクチコミの照合と本人確認が出来なかった場合は、特典は適用されませんので、予めご了承ください。

本メールの行き違いで既にクチコミ投稿済みの場合はご容赦ください。
尚、クチコミへの投稿はお客様の任意となっております。

不明点等あればお気軽にご連絡くださいませ。
それではお忙しいところ大変お手数おかけいたしますが、ご確認のほど、何卒宜しくお願いします。

${footer}`,
    },
    {
      label: '#6 施設管理者承認後',
      trigger: '施設管理者が承認リンクをクリック後',
      to: 'サイト管理者',
      subject: `【管理者承認依頼】${facilityName}の施設オーナーによるクチコミ承認完了のお知らせ | クチコミル（${serviceName}クチコミランキング）`,
      body: `${facilityName}の施設オーナーによるクチコミ承認が完了しました。

■ 新しいGoogleクチコミ投稿の内容
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- 5段階評価アンケート
${P.starRating}

- お名前
${P.reviewerName}

- メールアドレス
${P.email}

- Googleアカウント名
${P.googleAccountName}

- Google Business Profile（Googleマップ）のURL
${mapUrl}

- GoogleクチコミのURL
${P.reviewUrl}

- 施設承認ステータス : 完了
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

▼ 承認する場合は、管理画面にアクセスして最終承認をお願いします。 ▼
${P.adminDashboardLink}

${footer}`,
    },
    {
      label: '#7 ギフトコード送付',
      trigger: 'サイト管理者が管理画面から最終承認後',
      to: 'アンケート回答者',
      subject: `${serviceName}クチコミランキング事務局からの限定特典のお知らせ`,
      body: `${P.reviewerName} 様

この度は、${facilityName}への5段階評価アンケートとクチコミ投稿にご協力していただき、誠にありがとうございます。
クチコミル（${serviceName}クチコミランキング）事務局より感謝の気持ちを込めて、ご協力していただいた方限定特典を用意しましたので、是非お受け取りください。

▼ Amazonギフトコード（${amountText}円分） ▼
ギフトコード: ${P.giftCode}

※有効期限 : ${P.expiresAt}

${footer}`,
    },
  ]

  const enEmails = [
    {
      label: '#1 Thank You',
      trigger: 'Immediately after survey submission (all ratings)',
      to: 'Survey respondent',
      subject: `Thank you for your cooperation with our 5-star rating survey. | ${serviceName} Review Ranking`,
      body: `Thank you very much for taking the time to complete the 5-star rating survey for ${facilityName}.

The survey feedback you provided will be shared with ${facilityName} and used to improve customer satisfaction going forward.

Once we have verified your identity and confirmed the content of your review, the Kuchikomiru Secretariat will send you your exclusive benefit. We appreciate your patience.

※ This email is an automated response.

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
【Your Submitted Information】
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
■ 5-Star Rating Survey: ${P.starRating}

■ Comments / Feedback: ${P.feedback}

▼▼━━━━━━━ Your Basic Information ━━━━━━━▼▼

■ Name: ${P.reviewerName}

■ Email Address: ${P.email}

■ Google Account Name: ${P.googleAccountName}

■ Privacy Policy: Agreed

${footer}`,
    },
    {
      label: '#2 High Rating – Facility Mgr',
      trigger: 'Immediately after survey submission (high rating ★3–5)',
      to: 'Facility Manager (BCC: Site Administrator)',
      subject: `A response has been received for ${facilityName}'s 5-star rating survey. | Kuchikomiru (${serviceName} Review Ranking)`,
      body: `※ A response has been received for ${facilityName}'s 5-star rating survey.

【${facilityName}】
${mapUrl}

■ Customer's Survey Response
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

- 5-Star Rating Survey
${P.starRating}

- Comments / Feedback
${P.feedback}

- Name
${P.reviewerName}

- Email Address
${P.email}

- Google Account Name
${P.googleAccountName}

- Privacy Policy
Agreed

■ Next Steps
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Once our system has located the corresponding Google review for this response, we will notify you separately. Please wait a moment.

※ This email is sent automatically.

${footer}`,
    },
    {
      label: '#3 Low Rating – Facility Mgr',
      trigger: 'Immediately after survey submission (low rating ★1–2)',
      to: 'Facility Manager (BCC: Site Administrator)',
      subject: `[Approval Request] A response has been received for ${facilityName}'s 5-star rating survey. | Kuchikomiru (${serviceName} Review Ranking)`,
      body: `※ A response has been received for ${facilityName}'s 5-star rating survey.

【${facilityName}】
${mapUrl}

■ Customer's Survey Response
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- 5-Star Rating Survey
${P.starRating}

- Comments / Feedback
${P.feedback}

- Name
${P.reviewerName}

- Email Address
${P.email}

- Google Account Name
${P.googleAccountName}

- Privacy Policy
Agreed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

▼ To approve this response, please click the link below. ▼
${P.approvalLink}

※ This email is sent automatically.
※ This link is exclusively for the owner of ${facilityName}. Please do not share it with third parties.

${footer}`,
    },
    {
      label: '#4 After Google Review',
      trigger: 'After Google review verification (★3–5 and name matched)',
      to: 'Facility Manager (BCC: Site Administrator)',
      subject: `[Approval Request] Notification of Completion of New Google Review Verification | Kuchikomiru (${serviceName} Review Ranking)`,
      body: `Verification of the new Google review post has been completed.

■ New Google Review Details
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- 5-Star Rating Survey
${P.starRating}

- Name
${P.reviewerName}

- Email Address
${P.email}

- Google Account Name
${P.googleAccountName}

- Google Business Profile (Google Maps) URL
${mapUrl}

- Google Review URL
${P.reviewUrl}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

▼ To approve, please click the link below. ▼
${P.approvalLink}

※ This email is sent automatically.
※ This link is exclusively for the owner of ${facilityName}. Please do not share it with third parties.

${footer}`,
    },
    {
      label: '#5 Review Not Found',
      trigger: 'Google review not found (high rating ★3–5, post not found)',
      to: 'Survey respondent',
      subject: `Notice from Kuchikomiru (${serviceName} Review Ranking) Secretariat`,
      body: `Dear ${P.reviewerName},

Thank you for taking the time out of your busy schedule to complete the 5-star rating survey for ${facilityName}.

At Kuchikomiru (${serviceName} Review Ranking), we offer an exclusive benefit (Amazon Gift Card worth ${amountText} yen) to customers who have cooperated with both the "5-star rating survey" and a "Google review post."

We have attempted to verify the corresponding review and confirm your identity, but we were unable to find a review post that appears to match ${P.reviewerName} (Google Account Name: ${P.googleAccountName}).

Possible reasons include:
- The Google Account Name entered in the survey does not match
- The review has not yet been published
- The review was accidentally deleted

We apologize for the inconvenience, but we kindly ask that you submit the 5-star rating survey and Google review for ${facilityName} once more. Once we are able to verify the corresponding review and confirm your identity, the Kuchikomiru Secretariat will send you an exclusive benefit (Amazon Gift Card worth ${amountText} yen).

■ Submit the 5-star rating survey here: ${questionnaireUrl}
■ Post a Google review here: ${mapUrl}

※ Our system will attempt to verify the corresponding Google review and confirm your identity within 1 hour of survey submission. If verification cannot be completed at that time, the benefit will not be applied. Please note this in advance.

If you have already posted your review and this email has crossed with your submission, we sincerely apologize.
Please note that posting a review is entirely at your discretion.

If you have any questions, please feel free to contact us.
We apologize for the inconvenience and appreciate your understanding.

${footer}`,
    },
    {
      label: '#6 After Facility Approval',
      trigger: 'After facility manager clicks approval link',
      to: 'Site Administrator',
      subject: `[Admin Approval Request] Notification of Review Approval Completed by Facility Owner of ${facilityName} | Kuchikomiru (${serviceName} Review Ranking)`,
      body: `The review approval by the facility owner of ${facilityName} has been completed.

■ New Google Review Details
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
- 5-Star Rating Survey
${P.starRating}

- Name
${P.reviewerName}

- Email Address
${P.email}

- Google Account Name
${P.googleAccountName}

- Google Business Profile (Google Maps) URL
${mapUrl}

- Google Review URL
${P.reviewUrl}

- Facility Approval Status: Completed
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

▼ To approve, please access the admin panel and complete the final approval. ▼
${P.adminDashboardLink}

${footer}`,
    },
    {
      label: '#7 Gift Code',
      trigger: 'After site administrator final approval',
      to: 'Survey respondent',
      subject: `Notice of Exclusive Benefit from ${serviceName} Review Ranking Secretariat`,
      body: `Dear ${P.reviewerName},

Thank you very much for your cooperation with the 5-star rating survey and Google review post for ${facilityName}.
As a token of our gratitude, the Kuchikomiru (${serviceName} Review Ranking) Secretariat has prepared an exclusive benefit for those who participated. Please accept it with our sincere thanks.

▼ Amazon Gift Code (worth ${amountText} yen) ▼
Gift Code: ${P.giftCode}

※ Expiry Date: ${P.expiresAt}

${footer}`,
    },
  ]

  const emails = isEn ? enEmails : jaEmails
  const visibleEmails = emails.filter((_, i) => {
    const label = isEn ? enEmails[i]?.label : jaEmails[i]?.label
    return label !== '#6 施設管理者承認後' && label !== '#6 After Facility Approval'
      ? true
      : currentUserType === 'admin'
  })

  return (
    <div className="mt-10">
      <h2 className="text-lg font-semibold text-gray-900 mb-1">メール本文</h2>
      <p className="text-sm text-gray-500 mb-4">
        各タイミングで送信されるメールのプレビューです。
        <span className="text-blue-600 font-medium"> {'{プレースホルダー}'} </span>
        はアンケート回答時の実際の値に置き換えられます。
      </p>

      {/* タブ */}
      <div className="flex flex-wrap gap-1.5 mb-4">
        {visibleEmails.map((email, index) => (
          <button
            key={index}
            type="button"
            onClick={() => setActiveTab(index)}
            className={`px-3 py-1.5 text-xs rounded font-medium transition-colors ${
              activeTab === index
                ? 'bg-[#2271b1] text-white'
                : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }`}
          >
            {email.label}
          </button>
        ))}
      </div>

      {/* メール内容 */}
      <div className="border border-gray-200 rounded-lg overflow-hidden">
        {/* メタ情報 */}
        <div className="bg-gray-50 px-4 py-3 border-b border-gray-200">
          <div className="flex gap-2 text-sm">
            <span className="text-gray-500 w-20 shrink-0">{isEn ? 'Subject' : '件名'}</span>
            <span className="text-gray-700 font-medium">{visibleEmails[activeTab]?.subject}</span>
          </div>
        </div>
        {/* 本文 */}
        <div className="p-4 bg-white">
          <pre className="text-sm text-gray-700 whitespace-pre-wrap font-sans leading-relaxed">
            {visibleEmails[activeTab]?.body}
          </pre>
        </div>
      </div>
    </div>
  )
}
