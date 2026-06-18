#!/bin/bash

# 1. パッケージリストを更新し、鍵の追加に必要なツールを入れる
apt-get update
apt-get install -y --no-install-recommends gnupg wget ca-certificates

# 2. TurboWarp公式リポジトリのセキュリティ鍵と、ダウンロード先を登録
wget https://desktop.turbowarp.org/release-signing-key.gpg -qO- | gpg --dearmor > /usr/share/keyrings/turbowarp.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/turbowarp.gpg] https://releases.turbowarp.org/deb stable main" > /etc/apt/sources.list.d/turbowarp.list

# 3. 追加したリポジトリを含めて、もう一度パッケージリストを更新
apt-get update

# 4. デスクトップ環境、VS Code、TurboWarp、日本語フォントを一括インストール！
apt-get install -y --no-install-recommends \
    lxqt-core \
    openbox \
    pcmanfm-qt \
    sddm \
    code \
    epiphany-browser \
    wget \
    git \
    zenity \
    xz-utils \
    turbowarp-desktop \
    fonts-noto-cjk

# 5. ログイン画面(SDDM)を有効化
systemctl enable sddm

# 6. 自動ログインの設定（起動時に自動でデスクトップを開く）
mkdir -p /etc/sddm.conf.d
cat << 'EOF' > /etc/sddm.conf.d/autologin.conf
[Autologin]
User=pi
Session=lxqt
EOF
