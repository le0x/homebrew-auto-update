# HomeBrew Outo Update
`brew update`を定期的に実行してくれるスクリプトです。

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
自動的に`brew upgrade`をさせたくないという場合は、`sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutoUpdate -boolean false`とコマンドを入力して下さい。

1.自動チェックの有効

    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -boolean true

2.動ダウンロードの有効

    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -boolean true

3.自動アップデートの有効

    sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutoUpdate -boolean true

4.状態を確認する

    launchctl list | grep auto-update

5.正しく動作するかどうかいますぐ実行する

    launchctl start homebrew.mxcl.homebrew-auto-update

### 仕様
実行間隔（StartInterval）は、3600秒（60分）に設定されています。

### 表示される通知のメッセージ

`brew update`に成功し、更新ファイルがあった場合

    Ran the brew update.

｀brew update`に成功し、更新ファイルが何もなかった場合

    There was no update.

`brew update`が失敗した場合

    It failed to update.

`brew upgrade`が失敗した場合

    It failed to upgrade.


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

追加したプロパティの削除（設定した項目のみ）

    sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled
    sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload
    sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate AutoUpdate
