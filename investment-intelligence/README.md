# Investment Intelligence

Cloudflare Pages上に構築した投資情報ダッシュボード。

## 機能
- 複数の投資情報ソースからRSSフィードを自動取得
- Claude APIによるAIスコアリング（1-10の重要度評価）
- トリアージ機能（保存/非表示の分類）
- キーワード検索・フィルタリング
- CSV一括エクスポート
- 記事の詳細AI分析（モーダル表示）

## 技術スタック
- **Frontend**: HTML / CSS / JavaScript（バニラ）
- **Backend**: Cloudflare Workers（サーバーレス）
- **Hosting**: Cloudflare Pages
- **AI**: Claude API（記事分析・スコアリング）
- **Data**: RSS/Atomフィード解析

## デモ
`index.html` をブラウザで開くとダミーデータで表示を確認できます。

> Note: このデモはダミーデータを使用しています。実際のシステムではCloudflare Workers経由でリアルタイムにフィードを取得・分析します。
