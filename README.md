# homebrew-auto-update

### インストール手順

リポジトリの登録

    brew tap le0x/auto-update

フォーミュラのインストール

    brew install le0x/auto-update/homebrew-auto-update --HEAD

LaunchAgentsにシンボリックリンクの作成

    ln -sfv /usr/local/opt/homebrew-auto-update/*.plist ~/Library/LaunchAgents

プロパティリストのロード

    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.homebrew-auto-update.plist

### 使い方
インストールが完了したら、下記のコマンドで有効にしたい項目をターミナルで入力してください。
無効に変更したい場合は、「ture」の項目を「false」に変更し入力します。

自動チェックの有効

    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -boolean true

自動ダウンロードの有効

    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -boolean true

自動アップデートの有効

    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutoUpdate -boolean true

状態を確認したい場合

    launchctl list | grep auto-update

一時的に停止させたい場合

    launchctl stop homebrew.mxcl.homebrew-auto-update

再開させたい場合

    launchctl start homebrew.mxcl.homebrew-auto-update

### 仕様
実行間隔（StartInterval）は、3600秒（60分）に設定されています。

### アンインストール手順
作成したファイルの削除。brew uninstall で削除されるものもあるかもしれないけど、念の為に記述しておく。

プロパティリストのアンロード

    launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.homebrew-auto-update.plist

シンボリックリンクの削除

    unlink  ~/Library/LaunchAgents/homebrew.mxcl.homebrew-auto-update.plist

フォーミュラのアンインストール

    brew uninstall le0x/auto-update/homebrew-auto-update --HEAD

リポジトリの削除

    brew untap le0x/auto-update

追加したプロパティの削除

    sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled
    sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload
    sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate AutoUpdate
