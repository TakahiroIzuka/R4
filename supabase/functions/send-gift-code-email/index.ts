import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

// メール送信（Resend API使用、ローカルはSMTPにフォールバック）
async function sendEmail(
  to: string,
  subject: string,
  body: string
): Promise<boolean> {
  const resendApiKey = Deno.env.get('RESEND_API_KEY')
  const fromEmail = Deno.env.get('EMAIL_FROM') || 'noreply@example.com'

  // Resend APIキーがある場合はResendを使用
  if (resendApiKey) {
    try {
      const response = await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${resendApiKey}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          from: fromEmail,
          to: [to],
          subject: subject,
          text: body,
        }),
      })

      if (response.ok) {
        console.log(`Email sent via Resend to: ${to}`)
        return true
      } else {
        const errorData = await response.text()
        console.error(`Resend API error: ${errorData}`)
        return false
      }
    } catch (error) {
      console.error('Resend error:', error)
      return false
    }
  }

  // ローカル開発用: SMTP
  const smtpHost = Deno.env.get('SMTP_HOST') || 'supabase_inbucket_R4'
  const smtpPort = parseInt(Deno.env.get('SMTP_PORT') || '1025')

  const encoder = new TextEncoder()
  const decoder = new TextDecoder()

  try {
    const conn = await Deno.connect({ hostname: smtpHost, port: smtpPort })

    const read = async (): Promise<string> => {
      const buf = new Uint8Array(1024)
      const n = await conn.read(buf)
      return decoder.decode(buf.subarray(0, n || 0))
    }

    const write = async (data: string): Promise<void> => {
      await conn.write(encoder.encode(data + '\r\n'))
    }

    await read()
    await write(`EHLO localhost`)
    await read()
    await write(`MAIL FROM:<${fromEmail}>`)
    await read()
    await write(`RCPT TO:<${to}>`)
    await read()
    await write('DATA')
    await read()

    const emailContent = [
      `From: ${fromEmail}`,
      `To: ${to}`,
      `Subject: =?UTF-8?B?${btoa(unescape(encodeURIComponent(subject)))}?=`,
      'MIME-Version: 1.0',
      'Content-Type: text/plain; charset=UTF-8',
      '',
      body,
      '.',
    ].join('\r\n')

    await write(emailContent)
    await read()
    await write('QUIT')

    conn.close()
    console.log(`Email sent via SMTP to: ${to}`)
    return true
  } catch (error) {
    console.error('SMTP error:', error)
    return false
  }
}

serve(async (req) => {
  // CORSプリフライト
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const {
      email,
      reviewerName,
      facilityName,
      serviceName,
      giftCode,
      giftAmount,
      expiresAt,
      language
    } = await req.json()

    if (!email || !giftCode || !giftAmount) {
      return new Response(
        JSON.stringify({ error: 'Missing required parameters' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const isEn = language === 'en'

    // 有効期限をフォーマット
    const formattedExpiresAt = expiresAt
      ? new Date(expiresAt).toLocaleDateString(isEn ? 'en-US' : 'ja-JP', { year: 'numeric', month: 'long', day: 'numeric' })
      : null

    const footer = isEn
      ? `Kuchikomiru (${serviceName} Review Ranking) Secretariat
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Company: Rainmans LLC
Head Office: 2-3-8 Minatojimanakacho, Chuo-ku, Kobe, Hyogo
Tokyo Branch: 3-33-10 Koeji Kita, Suginami-ku, Tokyo
Email: info@mister-review-ranking.com
Phone: 050-8893-2668
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`
      : `クチコミル（${serviceName}クチコミランキング）事務局
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
運営会社 : 合同会社Rainmans
本社 : 兵庫県神戸市中央区港島中町2-3-8
東京支店 : 東京都杉並区高円寺北3-33-10
メールアドレス : info@mister-review-ranking.com
電話番号 : 050-8893-2668
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━`

    const body = isEn
      ? `Dear ${reviewerName},

Thank you very much for your cooperation with the 5-star rating survey and Google review post for ${facilityName}.
As a token of our gratitude, the Kuchikomiru (${serviceName} Review Ranking) Secretariat has prepared an exclusive benefit for those who participated. Please accept it with our sincere thanks.

▼ Amazon Gift Code (worth ${giftAmount} yen) ▼
Gift Code: ${giftCode}
${formattedExpiresAt ? `
※ Expiry Date: ${formattedExpiresAt}
` : ''}
${footer}
`
      : `${reviewerName} 様

この度は、${facilityName}への5段階評価アンケートとクチコミ投稿にご協力していただき、誠にありがとうございます。
クチコミル（${serviceName}クチコミランキング）事務局より感謝の気持ちを込めて、ご協力していただいた方限定特典を用意しましたので、是非お受け取りください。

▼ Amazonギフトコード（${giftAmount}円分） ▼
ギフトコード: ${giftCode}
${formattedExpiresAt ? `
※有効期限 : ${formattedExpiresAt}
` : ''}
${footer}
`

    const success = await sendEmail(
      email,
      isEn
        ? `Notice of Exclusive Benefit from ${serviceName} Review Ranking Secretariat`
        : `${serviceName}クチコミランキング事務局からの限定特典のお知らせ`,
      body
    )

    return new Response(
      JSON.stringify({ success }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    console.error('Error in send-gift-code-email function:', error)
    return new Response(
      JSON.stringify({ error: 'Internal server error' }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
