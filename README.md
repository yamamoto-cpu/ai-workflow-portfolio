# AI Workflow Portfolio

非エンジニアがAIエージェント（Claude Code）を活用して構築した業務システム・ツールの実例集。

## About

24歳・セールスエンジニア（製造業）。コーディング経験なしの状態から、AIエージェントとの対話だけで以下のシステム・ツールを構築しました。

## Projects

### 1. Life OS — AI駆動の業務管理システム

AIエージェントと対話しながら、タスク管理・情報共有・自動化を統合した業務管理システムをゼロから構築。

**構成:**
```
NOTES.md（メモ入力）
    ↓ AIが自動分類
IDEAS.md（アイデア蓄積 / Impact×Ease評価）
    ↓ 優先度をつけてタスク化
Linear（タスク実行管理）
```

**ツール連携（MCP経由でAIが直接操作）:**
- Linear — タスク管理（Issue作成・更新・ステータス変更）
- Slack — チーム通知（自動投稿）
- Notion — ドキュメント共有（確認状況管理）
- Google Calendar — スケジュール管理
- GitHub — 自動バックアップ

**自動化（hooks）:**
- ファイル変更検知 → AIが内容を自動分類・振り分け
- git commit → 自動でGitHubにpush（バックアップ）

**詳細:** [life-os-workflow.md](./life-os-workflow.md)

---

### 2. Investment Intelligence — 投資情報ダッシュボード

Cloudflare Pages上に構築した投資情報ダッシュボード。

- HTML/CSS/JavaScriptをAIと対話しながら生成
- Cloudflare Workers + Pagesによるサーバーレスデプロイ
- 市場分析・テーゼ管理・バリュエーション追跡を一元化

**技術スタック:** Cloudflare Pages, Workers, HTML/CSS/JavaScript

---

### 3. Kindle to PDF — 自動PDF化スクリプト

Kindle Web Readerの画面をスクリーンショットで自動キャプチャし、PDFに変換するmacOSスクリプト。

- AppleScript + sips によるスクリーンショット自動取得
- ページ送り・キャプチャ・PDF結合を自動化
- Automatorとの連携

**詳細:** [kindle-to-pdf/](./kindle-to-pdf/)

---

## Skills & Tools

| カテゴリ | 内容 |
|---|---|
| AIエージェント | Claude Code（メイン）、ChatGPT |
| クラウド | Cloudflare Pages/Workers、GitHub |
| SaaS連携 | Linear、Slack、Notion、Google Calendar |
| 自動化 | Claude Code hooks、MCP、AppleScript |
| 言語 | 日本語（ネイティブ）、英語（ビジネス） |

## Philosophy

> 「AIは一部の詳しい人だけが使えても意味がない。組織全体で活用してこそ価値がある」

非エンジニアでもAIを使いこなせることを、自ら実践して証明しています。
