#!/bin/bash
# kindle-to-pdf.sh — Kindle Web Readerのスクショを自動で撮ってPDFにする
#
# 使い方:
#   ./kindle-to-pdf.sh                        # 本のタイトルで自動保存
#   ./kindle-to-pdf.sh 50                     # 50ページだけ撮影
#
# 事前準備（初回のみ）:
#   1. pip3 install pyobjc-framework-Quartz
#   2. Chrome → 表示 → デベロッパー → 「Apple EventsからのJavaScriptを許可」をON
#
# 撮影前:
#   1. ChromeでKindle本を開いて撮影開始ページを表示
#   2. このスクリプトを実行

FILENAME=${1:?'ファイル名を指定してください (例: ./kindle-to-pdf.sh コンサル一年目)'}
FILENAME="${FILENAME%.pdf}"
MAX_PAGES=${2:-9999}  # 指定なしなら最終ページまで自動停止
GDRIVE="$HOME/Library/CloudStorage/GoogleDrive-rallys.tabletennis@gmail.com/マイドライブ/kindle-pdf"
DIR=$(mktemp -d /tmp/kindle-screenshots-XXXX)
DELAY=3

echo "=== Kindle → PDF ==="

# KindleタブをChromeの全ウィンドウ・全タブから探す
KINDLE_TAB=$(osascript -e '
tell application "Google Chrome"
    set wCount to count of windows
    repeat with w from 1 to wCount
        set tCount to count of tabs of window w
        repeat with t from 1 to tCount
            if URL of tab t of window w contains "read.amazon" and URL of tab t of window w contains "asin" then
                return (w as text) & "," & (t as text)
            end if
        end repeat
    end repeat
    return ""
end tell
')

if [ -z "$KINDLE_TAB" ]; then
    echo "エラー: ChromeでKindleの本が開かれていません。"
    echo "https://read.amazon.co.jp/ で本を開いてから再実行してください。"
    exit 1
fi

IFS=',' read -r WIN_NUM TAB_NUM <<< "$KINDLE_TAB"

OUTPUT="$GDRIVE/${FILENAME}.pdf"

echo "ファイル名: ${FILENAME}.pdf"
echo "保存先: $GDRIVE/"
echo "最大ページ: $MAX_PAGES"
echo ""
echo "Kindleタブ: ウィンドウ${WIN_NUM} タブ${TAB_NUM}"

# Kindleタブをアクティブにしてウィンドウを特定
osascript -e "tell application \"Google Chrome\" to set active tab index of window $WIN_NUM to $TAB_NUM"
sleep 1

# そのウィンドウのCGWindowIDを取得
WINDOW_ID=$(python3 -c "
import Quartz
windows = Quartz.CGWindowListCopyWindowInfo(Quartz.kCGWindowListOptionAll, Quartz.kCGNullWindowID)
for w in windows:
    owner = w.get('kCGWindowOwnerName', '')
    name = str(w.get('kCGWindowName', ''))
    layer = w.get('kCGWindowLayer', -1)
    if owner == 'Google Chrome' and layer == 0 and name:
        print(w['kCGWindowNumber'])
        break
")

if [ -z "$WINDOW_ID" ]; then
    echo "エラー: ChromeのウィンドウIDを取得できませんでした。"
    exit 1
fi

echo "ウィンドウID: $WINDOW_ID"
echo ""
echo ">>> 3秒後に撮影開始します <<<"
sleep 3

# Ctrl+Cで止めてもPDFを作成する
cleanup_and_build() {
    echo ""
    echo "撮影終了。PDFに変換中..."

    PAGE_COUNT=$(ls "$DIR"/page_*.png 2>/dev/null | wc -l | tr -d ' ')
    if [ "$PAGE_COUNT" -eq 0 ]; then
        echo "スクリーンショットがありません。"
        rm -rf "$DIR"
        exit 1
    fi

    # 各PNGをPDFに変換（sips = macOS標準）
    for f in "$DIR"/page_*.png; do
        sips -s format pdf "$f" --out "${f%.png}.pdf" > /dev/null 2>&1
    done

    # macOS標準のAutomatorアクションでPDF結合
    "/System/Library/Automator/Combine PDF Pages.action/Contents/MacOS/join" -o "$OUTPUT" "$DIR"/page_*.pdf

    echo "PDF作成完了: $OUTPUT (${PAGE_COUNT}ページ)"

    # クリーンアップ
    rm -rf "$DIR"
    echo "一時ファイルを削除しました。"
}

trap cleanup_and_build EXIT

echo "撮影開始...（Ctrl+Cで途中停止 → そこまでのPDFを作成します）"

get_page_num() {
    osascript -e 'tell application "Google Chrome" to tell tab '"$TAB_NUM"' of window '"$WIN_NUM"' to execute javascript "
        var el = document.querySelector(\".text-div, ion-title.footer-label\");
        if(el){var m=el.textContent.match(/(Page|Location) (\\d+) of (\\d+)/); if(m) m[2]+\"/\"+m[3]; else \"\";} else \"\";
    "' 2>/dev/null
}

for i in $(seq -w 1 "$MAX_PAGES"); do
    # Kindleタブをアクティブにする（別タブに切り替えてしまった場合の対策）
    osascript -e "tell application \"Google Chrome\" to set active tab index of window $WIN_NUM to $TAB_NUM" 2>/dev/null
    sleep 0.3

    # 現在のページ番号を取得
    BEFORE=$(get_page_num)
    CUR_PAGE="${BEFORE%/*}"
    MAX_PAGE="${BEFORE#*/}"

    # スクショ
    screencapture -x -l "$WINDOW_ID" "$DIR/page_${i}.png"

    # 進捗表示
    printf "\r  [%s] Page %s of %s" "$i" "$CUR_PAGE" "$MAX_PAGE"

    # 最終ページなら終了
    if [ -n "$CUR_PAGE" ] && [ -n "$MAX_PAGE" ] && [ "$CUR_PAGE" -ge "$MAX_PAGE" ] 2>/dev/null; then
        echo ""
        echo "最終ページに到達しました。（${CUR_PAGE} of ${MAX_PAGE}）"
        break
    fi

    # ページ送り（1ページだけ進むようにJS内でページ番号を監視）
    osascript -e 'tell application "Google Chrome" to tell tab '"$TAB_NUM"' of window '"$WIN_NUM"' to execute javascript "
        var before = \"'"$BEFORE"'\";
        var l = document.querySelector(\".kr-interaction-layer-fullpage\");
        if(l){
            var r = l.getBoundingClientRect();
            l.dispatchEvent(new MouseEvent(\"mousedown\",{bubbles:true,cancelable:true,view:window,clientX:r.left+100,clientY:r.top+r.height/2}));
            l.dispatchEvent(new MouseEvent(\"mouseup\",{bubbles:true,cancelable:true,view:window,clientX:r.left+100,clientY:r.top+r.height/2}));
            l.dispatchEvent(new MouseEvent(\"click\",{bubbles:true,cancelable:true,view:window,clientX:r.left+100,clientY:r.top+r.height/2}));
        }
    "'

    # ページが変わるまでリトライ（最大3回クリック、各回最大10秒待ち）
    CHANGED=0
    for retry in $(seq 1 3); do
        for w in $(seq 1 20); do
            sleep 0.5
            AFTER=$(get_page_num)
            [ -z "$AFTER" ] && continue
            if [ -n "$BEFORE" ] && [ "$AFTER" != "$BEFORE" ]; then
                CHANGED=1
                break 2
            fi
            [ -z "$BEFORE" ] && CHANGED=1 && break 2
        done
        # 変わらなかったらもう一度クリック
        osascript -e 'tell application "Google Chrome" to tell tab '"$TAB_NUM"' of window '"$WIN_NUM"' to execute javascript "var l=document.querySelector(\".kr-interaction-layer-fullpage\");if(l){var r=l.getBoundingClientRect();[\"mousedown\",\"mouseup\",\"click\"].forEach(function(t){l.dispatchEvent(new MouseEvent(t,{bubbles:true,cancelable:true,view:window,clientX:r.left+100,clientY:r.top+r.height/2}));});}"'
    done

    # 3回リトライしても変わらない = 最終ページ
    if [ "$CHANGED" -eq 0 ] && [ -n "$BEFORE" ] && [ -n "$AFTER" ]; then
        echo ""
        echo "最終ページに到達しました。"
        break
    fi
done

# cleanup_and_build は trap EXIT で自動実行される
