# 開発環境起動・停止手順書

## 1. Supabase ローカル環境の起動

```bash
npx supabase start
```

## 2. Edge Functions のローカル起動

別のターミナルで以下を実行します。

```bash
npx supabase functions serve
```

## 3. Next.js 開発サーバーの起動

別のターミナルで以下を実行します。

```bash
npm run dev
```

`http://localhost:3000` でアクセスできます。

## 4. 開発環境の停止

Next.js開発サーバー、Edge Functions の各ターミナルで `Ctrl+C` を押してターミナルをkillした後、以下を実行します。

```bash
npx supabase stop
```
