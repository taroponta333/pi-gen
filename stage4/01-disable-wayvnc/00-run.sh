#!/bin/bash -e

on_chroot <<- EOF
	SUDO_USER="${FIRST_USER_NAME}" raspi-config nonint do_vnc 1
# Fcitx5をデスクトップ起動時に自動実行する設定を追加
mkdir -p "/etc/xdg/autostart"
cat << 'EOF' > "/etc/xdg/autostart/fcitx5.desktop"
[Desktop Entry]
Name=Fcitx 5
GenericName=Input Method
Comment=Start Input Method
Exec=fcitx5 -d
Icon=fcitx
Terminal=false
Type=Application
Categories=System;Utility;
StartupNotify=false
X-GNOME-Autostart-Phase=Applications
X-GNOME-Autostart-Delay=2
X-KDE-autostart-phase=1
EOF
