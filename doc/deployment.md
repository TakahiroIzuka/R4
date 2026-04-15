# デプロイ手順書（本番環境）

## 前提条件

- [Supabase CLI](https://supabase.com/docs/guides/cli) がインストールされていること
- [Vercel CLI](https://vercel.com/docs/cli) がインストールされていること（手動デプロイ時）
- Supabase プロジェクトが作成済みであること
- ローカル開発環境が構築済みであること（[ローカル開発環境構築手順書](./local-setup.md) を参照）

---

## 本番環境（Vercel + Supabase）
### ■フロントエンドを修正した場合

Vercel は GitHub リポジトリと連携しており、`main` ブランチへの push で自動デプロイされます。

### ■バックエンドの処理を修正した場合

```bash
# 全ての Edge Functions をデプロイ
npx supabase functions deploy

# 個別にデプロイする場合
npx supabase functions deploy <function-name>
```

現在の Edge Functions:

| 関数名 | 用途 |
|--------|------|
| `check-review` | レビューチェック |
| `process-review-tasks` | レビュータスク処理 |
| `fetch-review-details` | レビュー詳細取得 |
| `resize-image` | 画像リサイズ |
| `send-gift-code-email` | ギフトコードメール送信 |
| `send-admin-approval-email` | 管理者承認メール送信 |
| `send-gift-code-shortage-email` | ギフトコード不足通知メール送信 |

### ■環境変数を変更したい場合

Vercel ダッシュボード（Settings > Environment Variables）で以下を設定します。

| 変数名 | 説明 |
|--------|------|
| `NEXT_PUBLIC_SUPABASE_URL` | Supabase プロジェクトの URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase の anon key |
| `SUPABASE_SERVICE_ROLE_KEY` | Supabase の service_role key |
| `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY` | Google Maps API キー |
| `NEXT_PUBLIC_GOOGLE_MAP_ID` | Google Maps の Map ID |
| `NEXT_PUBLIC_BASE_URL` | アプリケーションの公開 URL |
| `APIFY_TOKEN` | Apify API トークン |
| `ADMIN_EMAIL` | 管理者メールアドレス |
| `SMTP_HOST` | SMTP サーバーホスト |
| `SMTP_PORT` | SMTP サーバーポート |
| `SMTP_FROM` | メール送信元アドレス |
| `GOOGLE_PLACES_API_KEY` | Google Places API キー |

### ■DB構造を修正した場合

Supabase CLI でリモートプロジェクトにリンクし、マイグレーションを適用します。

```bash
# リモートプロジェクトにリンク（初回のみ）
npx supabase link --project-ref <project-ref>

# マイグレーションを適用
npx supabase db push
```

---

## デプロイ時の注意事項

- **リージョン**: Vercel のデプロイリージョンは `hnd1`（東京）に固定されています（`vercel.json`）
- **マイグレーション順序**: 本番デプロイ前に必ず `npx supabase db push` でマイグレーションを先に適用してください
- **シークレット管理**: `.env.local` は `.gitignore` に含まれており、リポジトリにコミットしないでください
- **Edge Functions の JWT 検証**: `check-review`、`process-review-tasks`、`send-admin-approval-email` は内部呼び出し用のため JWT 検証が無効化されています
