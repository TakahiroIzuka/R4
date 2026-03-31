# R4（Rainmans Review Ranking Replace）

## 概要

Google Maps を活用した施設情報の掲載・クチコミ管理サービスです。
サービスごとに施設一覧やジャンル・地域別の検索、アンケート機能、ギフトコード管理などを提供します。
企業向けの管理画面とシステム全体の管理者向け画面を備えています。

## 使用技術

| カテゴリ | 技術 |
|----------|------|
| フレームワーク | [Next.js](https://nextjs.org)（App Router） |
| 言語 | TypeScript |
| BaaS | [Supabase](https://supabase.com)（認証・DB・Edge Functions・Storage） |
| 地図 | Google Maps JavaScript API |
| UI | [Tailwind CSS](https://tailwindcss.com) / [shadcn/ui](https://ui.shadcn.com/) |
| ホスティング | [Vercel](https://vercel.com) |

## 手順書

- [ローカル開発環境構築手順書](./doc/local-setup.md)
- [デプロイ手順書（本番環境）](./doc/deployment.md)
- [サービス追加手順書](./doc/add-service.md)
