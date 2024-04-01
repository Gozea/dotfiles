# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

#aliases
alias ls='ls --color=auto'
alias la='ls -lah --color=auto'
alias ..='cd ..'
alias rmd='rm -rfv'
alias vim='nvim'
alias shutnow='shutdown -h now'

#PATH export
PATH=~/.local/share/gem/ruby/3.0.0/bin:$PATH

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend

