# AI Workflow Portfolio

AIエージェント（Claude Code）を活用して構築した業務システム・ツール集。

## Projects

### 1. [Life OS — AI駆動の業務管理システム](./life-os-workflow.md)

タスク管理・情報共有・自動化を統合した業務管理システム。

- **情報フロー**: メモ入力 → AI自動分類 → アイデア蓄積 / タスク管理
- **ツール連携**: Linear, Slack, Notion, Google Calendar, GitHub（MCP経由）
- **自動化**: ファイル変更検知による自動分類、git commit時の自動バックアップ

### 2. [Investment Intelligence — 投資情報ダッシュボード](./investment-intelligence/)

Cloudflare Pages上に構築した投資情報ダッシュボード。

- 複数ソースからRSSフィード自動取得 → Claude APIでAIスコアリング（1-10）
- トリアージ・検索・フィルタ・CSV出力・詳細AI分析
- Cloudflare Workers + Pagesによるサーバーレス構成
- [デモ（ダミーデータ）](./investment-intelligence/index.html)

### 3. [Kindle to PDF — 自動PDF化スクリプト](./kindle-to-pdf/)

Kindle Web Readerの画面を自動キャプチャしPDFに変換するmacOSスクリプト。

- AppleScript + sips によるスクリーンショット自動取得
- ページ送り・キャプチャ・PDF結合を自動化
