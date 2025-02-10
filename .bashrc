# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# vim mode
set -o vi

#aliases
alias ls='ls --color=auto'
alias la='ls -lah --color=auto'
alias ..='cd ..'
alias rmd='rm -rfv'
alias vim='nvim'
alias gitkey='pass show git/key | xclip -sel clip'
alias shutnow='shutdown -h now'
alias wgconnect='wg-quick up $(ls /etc/wireguard/ | cut -d'.' -f1 | dmenu)'
alias wgdisconnect='wg-quick down $(wg | grep "interface" | cut -d" " -f2 | dmenu)'

#PATH export
PATH=~/.local/share/gem/ruby/3.0.0/bin:$PATH

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend

. "$HOME/.cargo/env"

# cpr and mvr
cpr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 "$@"
} 
mvr() {
  rsync --archive -hh --partial --info=stats1,progress2 --modify-window=1 --remove-source-files "$@"
}

# Created by `pipx` on 2024-06-16 19:31:10
export PATH="$PATH:/home/zea/.local/bin"

# Android
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools


# label studio 
export LABEL_STUDIO_DISABLE_SIGNUP_WITHOUT_LINK=true

