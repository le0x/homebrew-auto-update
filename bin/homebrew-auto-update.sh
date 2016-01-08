#!/bin/bash

# 参考’シャルスクリプトを書くときはset -euしておく
# http://qiita.com/youcune/items/fcfb4ad3d7c1edf9dc96
set -eu          # エラーまたは未定義の変数があった場合、止める
set -o pipefail  # 各コマンドで最後にゼロ以外だった終了コードが返る

PATH=/usr/local/bin:$PATH

# AutomaticCheckEnabled , AutomaticDownload , AutoUpdate 設定の追加
# Homebrew: update -> fetch -> upgrade
# OS X: check -> download -> update
auto_update=$(defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled)
auto_fetch=$(defaults read /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload)
auto_upgrade=$(defaults read /Library/Preferences/com.apple.commerce AutoUpdate)

# auto_update を読み込めなかった場合
if [ "$auto_update" != 1 ]; then
  exit
fi

# github.com にアクセスできない場合
if [ "$(scutil -r github.com)" != 'Reachable' ]; then
  exit
fi

# iTerm または Terminal を使用する（default が Terminal なので）
for termapp in iTerm Terminal; do
  # アプリの識別子の取得 && アプリの識別子が取得できた
  if termapp_id=$(osascript -e "id of app \"$termapp\"" 2>/dev/null) && [ -n "$termapp_id" ]; then
    break
  fi
done

# brew update を実行
if ! out=$(brew update 2>&1); then
  terminal-notifier \
    -group 'org.eisentraut.BrewAutoUpdate' \
    -sound 'Glass' \
    -title 'Homebrew' \
    -subtitle 'It failed to update.' \
    -message "$out" \
    -activate "$termapp_id" \
    >/dev/null
  exit 1  # 正常終了
fi

# アップデートに失敗したか成功したか
if printf "%s" "$out" | grep 'Already up-to-date.'; then
  updated=false
else
  updated=true
fi

# 更新のあるformulaを確認
outdated=$(brew outdated | tr '\n' ' ' | sed 's/ $//')

# upgrade
if [ "$auto_upgrade" == 1 ]; then
  if ! out=$(brew upgrade 2>&1); then
    terminal-notifier \
      -group 'org.eisentraut.BrewAutoUpdate' \
      -sound 'Glass' \
      -title 'Homebrew' \
      -subtitle 'It failed to upgrade.' \
      -message "$out" \
      -activate "$termapp_id" \
      >/dev/null
    exit 1  # 正常終了
  fi
fi

# brew update 成功 かつ 更新するformulaが存在する場合
if $updated && [ -n "$outdated" ]; then
  if [ "$auto_fetch" = 1 ]; then
    # 更新するformulaのチェック
    brew fetch $outdated || :
  fi

  # アップデート完了を通知する
  terminal-notifier \
    -group 'org.eisentraut.BrewAutoUpdate' \
    -sound 'Bottle' \
    -title 'Homebrew' \
    -subtitle 'Ran the brew update.' \
    -message "$outdated" \
    -activate "$termapp_id" \
    >/dev/null

# 更新するformulaがなかった場合
elif [ -z "$outdated" ]; then
  # 通知の削除
  terminal-notifier \
    -group 'org.eisentraut.BrewAutoUpdate' \
    -sound 'Bottle' \
    -title 'Homebrew' \
    -subtitle 'There was no update.' \
    -message "$outdated" \
    -activate "$termapp_id" \
    >/dev/null
fi
