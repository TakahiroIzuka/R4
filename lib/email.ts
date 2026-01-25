/**
 * メール送信ユーティリティ（Next.js API用）
 * Resend APIを使用してメール送信を行う
 */

interface SendEmailParams {
  to: string | string[]
  subject: string
  body: string
}

interface SendEmailResult {
  success: boolean
  error?: string
}

/**
 * メールを送信する
 * RESEND_API_KEYが設定されている場合はResend APIを使用
 * ローカル開発時はSMTPにフォールバック
 */
export async function sendEmail({
  to,
  subject,
  body,
}: SendEmailParams): Promise<SendEmailResult> {
  const resendApiKey = process.env.RESEND_API_KEY
  const fromEmail = process.env.EMAIL_FROM || process.env.SMTP_FROM || 'noreply@example.com'
  const recipients = Array.isArray(to) ? to : [to]

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
          to: recipients,
          subject: subject,
          text: body,
        }),
      })

      if (response.ok) {
        console.log(`Email sent via Resend to: ${recipients.join(', ')}`)
        return { success: true }
      } else {
        const errorData = await response.text()
        console.error(`Resend API error: ${errorData}`)
        return { success: false, error: errorData }
      }
    } catch (error) {
      console.error('Resend error:', error)
      return { success: false, error: String(error) }
    }
  }

  // ローカル開発用: SMTP（Node.js net module使用）
  const smtpHost = process.env.SMTP_HOST || 'localhost'
  const smtpPort = parseInt(process.env.SMTP_PORT || '1025')

  try {
    const net = await import('net')

    return new Promise((resolve) => {
      const client = net.createConnection({ host: smtpHost, port: smtpPort }, () => {
        let step = 0

        const sendCommand = (command: string) => {
          client.write(command + '\r\n')
        }

        client.on('data', (data) => {
          const response = data.toString()

          switch (step) {
            case 0: // Initial greeting
              sendCommand('EHLO localhost')
              step++
              break
            case 1: // After EHLO
              sendCommand(`MAIL FROM:<${fromEmail}>`)
              step++
              break
            case 2: // After MAIL FROM
              // Send RCPT TO for each recipient
              recipients.forEach((recipient) => {
                sendCommand(`RCPT TO:<${recipient}>`)
              })
              step++
              break
            case 3: // After RCPT TO
              sendCommand('DATA')
              step++
              break
            case 4: // After DATA
              // Encode subject in UTF-8 Base64
              const encodedSubject = `=?UTF-8?B?${Buffer.from(subject).toString('base64')}?=`
              const emailContent = [
                `From: ${fromEmail}`,
                `To: ${recipients.join(', ')}`,
                `Subject: ${encodedSubject}`,
                'MIME-Version: 1.0',
                'Content-Type: text/plain; charset=UTF-8',
                '',
                body,
                '.',
              ].join('\r\n')
              sendCommand(emailContent)
              step++
              break
            case 5: // After email content
              sendCommand('QUIT')
              step++
              break
            case 6: // After QUIT
              client.end()
              console.log(`Email sent via SMTP to: ${recipients.join(', ')}`)
              resolve({ success: true })
              break
          }
        })

        client.on('error', (error) => {
          console.error('SMTP error:', error)
          resolve({ success: false, error: String(error) })
        })
      })

      client.on('error', (error) => {
        console.error('SMTP connection error:', error)
        resolve({ success: false, error: String(error) })
      })
    })
  } catch (error) {
    console.error('SMTP error:', error)
    return { success: false, error: String(error) }
  }
}

/**
 * 管理者メールアドレスを取得
 * ADMIN_EMAILS（カンマ区切り）またはADMIN_EMAILから取得
 */
export function getAdminEmails(): string[] {
  const adminEmailsEnv = process.env.ADMIN_EMAILS || process.env.ADMIN_EMAIL || ''
  return adminEmailsEnv
    .split(',')
    .map((email) => email.trim())
    .filter(Boolean)
}

/**
 * 星評価を文字列に変換
 */
export function formatStarRating(rating: number): string {
  const stars = '★'.repeat(rating) + '☆'.repeat(5 - rating)
  return `${stars} (${rating}段階)`
}
