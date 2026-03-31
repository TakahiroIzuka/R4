# ローカル開発環境構築手順書

## 前提条件

- Node.js v20 以上がインストールされていること
- [Supabase CLI](https://supabase.com/docs/guides/cli) がインストールされていること
- Docker がインストール・起動されていること（Supabase ローカル環境に必要）

## 1. リポジトリのクローンと依存パッケージのインストール

```bash
git clone <リポジトリURL>
cd R4
npm install
```

## 2. Supabase ローカル環境の起動

```bash
npx supabase start
```

初回起動時は Docker イメージのダウンロードに時間がかかります。
起動が完了すると、以下のような情報が表示されます。

```
API URL: http://127.0.0.1:54321
anon key: eyJ...
service_role key: eyJ...
Studio URL: http://127.0.0.1:54323
```

この情報を次の手順で使用します。

## 3. 環境変数の設定

### Next.js 用（`.env.local`）

サンプルファイルをコピーして `.env.local` を作成します。

```bash
cp .env.local.example .env.local
```

コピー後、`.env.local` を開いて `<...>` の部分を実際の値に置き換えてください。
`NEXT_PUBLIC_SUPABASE_ANON_KEY` と `SUPABASE_SERVICE_ROLE_KEY` は手順 2 で表示された値を設定します。

### Edge Functions 用（`supabase/functions/.env`）

サンプルファイルをコピーして `supabase/functions/.env` を作成します。

```bash
cp supabase/functions/.env.example supabase/functions/.env
```

コピー後、`supabase/functions/.env` を開いて `<...>` の部分を実際の値に置き換えてください。

## 4. データベースのマイグレーションとシード

`npx supabase start` 時に `supabase/migrations/` 配下のマイグレーションと `supabase/seed.sql` が自動的に適用されます。

手動でリセットする場合は以下を実行します。

```bash
npx supabase db reset
```

## 5. Edge Functions のローカル起動

別のターミナルで以下を実行します。

```bash
npx supabase functions serve
```

Edge Functions の環境変数は `supabase/functions/.env` から読み込まれます（手順 3 で設定済み）。

## 6. Next.js 開発サーバーの起動

```bash
npm run dev
```

`http://localhost:3000` でアクセスできます。

## 7. 開発に便利なツール

| ツール | URL | 説明 |
|--------|-----|------|
| Next.js アプリ | http://localhost:3000 | フロントエンド |
| Supabase Studio | http://127.0.0.1:54323 | DB 管理画面 |
| Inbucket | http://127.0.0.1:54324 | メールテスト用 Web UI |

## 8. ローカル環境の停止

```bash
npx supabase stop
```

## トラブルシューティング

### `npx supabase start` が失敗する

- Docker が起動しているか確認してください
- ポート（54321〜54327）が他のプロセスで使用されていないか確認してください
- `npx supabase stop` で一度停止してから再度 `npx supabase start` を試してください

### マイグレーションエラーが発生する

```bash
npx supabase db reset
```

でデータベースを初期化してから再度試してください。
