# サービスを追加する手順

新しいサービスを追加する際に必要な作業をまとめたドキュメントです。

## 1. サービスコードと設定を追加する

`lib/constants/services.ts` を編集します。

### 1-1. `SERVICE_CODES` にサービスコードを追加

```ts
export const SERVICE_CODES = {
  MEDICAL: 'medical',
  HOUSE_BUILDER: 'house-builder',
  VACATION_STAY: 'vacation-stay',
  KUCHIKOMI: 'kuchikomiru',
  NEW_SERVICE: 'new-service', // 追加
} as const
```

### 1-2. `REVIEW_RANKING_CONFIG` にサービスの設定を追加

```ts
[SERVICE_CODES.NEW_SERVICE]: {
  buttonText: '施設の掲載リクエストはこちら',  // 掲載リクエストボタンのテキスト
  copyRightText: 'New Service Review Ranking.', // フッターのコピーライト
  lineColor: 'rgb(165, 153, 126)',              // テーマカラー（線）
  color: 'rgb(165, 153, 126)',                  // テーマカラー（ボタンなど）
  genres: {},                                    // ジャンル別のカラー設定（不要なら空）
},
```

ジャンル別にカラーを変えたい場合は `genres` に以下のように設定します。

```ts
genres: {
  'genre-code': {
    lineColor: 'rgb(238, 154, 162)',
    color: 'rgb(238, 154, 162)',
  },
},
```

## 2. 画像ファイルを配置する

`public/<サービスコード>/` ディレクトリを作成し、以下の画像ファイルを配置します。

```
public/<サービスコード>/
├── icon.png                    # サービスアイコン
└── default/
    ├── logo_header.png         # ヘッダーロゴ
    ├── logo_footer.png         # フッターロゴ
    ├── info-incentive.png      # インセンティブ案内画像
    ├── noimage.jpg             # 画像未設定時のフォールバック画像
    └── pin.png                 # Google Maps のマーカー画像
```

ジャンルごとに画像を分ける場合は、ジャンルコード名のディレクトリを作成して同様のファイルを配置します。

```
public/<サービスコード>/
├── icon.png
├── default/
│   └── (上記と同じ)
└── <ジャンルコード>/
    ├── logo_header.png
    └── ...
```

## 3. 管理画面からサービスを登録する

管理画面からサービスのレコードを追加します。

1. 管理画面（`/admin-management`）にアクセスする
2. 「マスタ管理」>「サービス」（`/admin-management/masters/services`）を開く
3. サービスを新規追加する
   - **code**: `lib/constants/services.ts` の `SERVICE_CODES` に追加したサービスコードと同じ値を設定する
   - **name**: サービスの表示名を設定する

## まとめ

| # | 作業内容 | 対象ファイル / 場所 |
|---|---------|-------------------|
| 1 | サービスコード追加 | `lib/constants/services.ts` (`SERVICE_CODES`) |
| 2 | ランキング設定追加 | `lib/constants/services.ts` (`REVIEW_RANKING_CONFIG`) |
| 3 | 画像ファイル配置 | `public/<サービスコード>/` |
| 4 | サービス登録 | 管理画面 `/admin-management/masters/services` |

## 参考

- [kuchikomiruサービス追加 PR](https://github.com/TakahiroIzuka/R4/pull/1)
