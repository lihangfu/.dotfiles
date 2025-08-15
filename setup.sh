#!/bin/bash

# 此设置脚本不需要 root 权限
# 但它会在 $HOME/.local/bin 中安装一些程序
# 请确保将此路径添加到您的 PATH 中或根据需要进行更改
INSTALLDIR=$HOME/.local/bin

# 基本要求
if [ ! -x "$(command -v curl)" ]; then
	echo "从 git 发布页面拉取预编译二进制文件需要 curl"
	echo "退出..."
	exit 1
fi

# 创建我的 dotfiles 的符号链接（如果已存在则不会覆盖）
[ -d "$HOME/.config/wezterm" ] && ln -s $HOME/.dotfiles/.config/wezterm $HOME/.config/wezterm
[ -f "$HOME/.bashrc" ] || ln -s $HOME/.dotfiles/.bashrc $HOME/.bashrc
[ -f "$HOME/.bash_profile" ] || ln -s $HOME/dotfiles/.bash_profile $HOME/.bash_profile

source $HOME/.bashrc