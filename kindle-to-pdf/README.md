# Kindle → PDF 変換マニュアル

Kindle Web Readerで開いた本を自動スクショしてPDFにするスクリプト。
PDFはGoogle Driveの `kindle-pdf` フォルダに保存される。

## 初回セットアップ（1回だけ）

### 1. PyObjCのインストール

ターミナルで以下を実行:

```
pip3 install pyobjc-framework-Quartz
```

### 2. ChromeでJavaScript実行を許可

1. Google Chromeを開く
2. 画面上部メニューバー → **表示** → **デベロッパー**
3. **「Apple Events からの JavaScript を許可」** をクリック（チェックが入ればOK）

## 使い方

### Step 1: Kindleで本を開く

1. Chromeで https://read.amazon.co.jp/ にアクセス
2. 読みたい本をクリックして開く
3. 最初のページ（表紙など、撮影を始めたいページ）を表示する

### Step 2: ターミナルでスクリプトを実行

1. **Spotlight**（`Cmd + Space`）→ 「ターミナル」と入力 → Enter
2. 以下をコピペしてEnter:

```
cd ~/life-os && ./3_daily/kindle-to-pdf.sh ファイル名
```

**例**:
```
cd ~/life-os && ./3_daily/kindle-to-pdf.sh kikuchi-yusei
```

3. 自動で撮影開始 → 最終ページで自動停止 → PDF作成

### Step 3: PDFを確認

Google Drive → `kindle-pdf` フォルダにPDFが保存される。

## 途中で止めたい場合

ターミナルをクリック → `Ctrl + C`

途中で止めても**そこまでのページでPDFが作成される**。

## ページ数を指定したい場合

```
cd ~/life-os && ./3_daily/kindle-to-pdf.sh ファイル名 100
```

100ページだけ撮影する。

## 共有方法

Google Driveの `kindle-pdf` フォルダを開き、PDFファイルを右クリック → 共有。

## よくあるトラブル

| 症状 | 原因と対処 |
|---|---|
| 「ChromeでKindleの本が開かれていません」 | Chromeで本を開いてから再実行。ライブラリページではなく本自体を開く |
| 全ページ同じ画面 | 本が正しく開かれていない。Chromeで本をクリックして開き直す |
| `ModuleNotFoundError: Quartz` | `pip3 install pyobjc-framework-Quartz` を実行 |
| `AppleScript からの JavaScript の実行がオフ` | Chrome → 表示 → デベロッパー → 「Apple EventsからのJavaScriptを許可」をON |

## 注意事項

- 撮影中にKindleのタブを切り替えないこと
- PCをスリープにしないこと
- 撮影中は他のアプリで作業可能だが、キーボード入力が若干途切れることがある
