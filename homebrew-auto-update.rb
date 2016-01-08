require 'formula'

class HomebrewAutoUpdate < Formula
  homepage 'https://github.com/le0x/homebrew-auto-update/'
  head 'https://github.com/le0x/homebrew-auto-update.git', :branch => 'master'

  # 依存関係の定義
  depends_on 'terminal-notifier'

  def install
    inreplace 'bin/homebrew-auto-update.sh', '/usr/local', HOMEBREW_PREFIX
    prefix.install 'bin'
    (bin/'homebrew-auto-update.sh').chmod 0755
  end

  def plist; <<EOS

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC -//Apple Computer//DTD PLIST 1.0//EN http://www.apple.com/DTDs/PropertyList-1.0.dtd >
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>#{plist_name}</string>

    <key>ProgramArguments</key>
    <array>
      <string>#{opt_bin}/homebrew-auto-update.sh</string>
    </array>

    <key>ProcessType</key>
    <string>Background</string>

    <key>StartInterval</key>
    <integer>1800</integer>

    <key>RunAtLoad</key>
    <true/>

    <key>StandardOutPath</key>
    <string>/tmp/homebrew-auto-update.out</string>

    <key>StandardErrorPath</key>
    <string>/tmp/homebrew-auto-update.err</string>
  </dict>
</plist>
EOS

  end
end
