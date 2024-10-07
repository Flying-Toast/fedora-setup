[[ $- != *i* ]] && return

export PATH="$HOME/.local/bin:$PATH:$HOME/.cargo/bin"

source /usr/share/bash-completion/bash_completion
[[ -f $HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/etc/bash_completion.d/cargo ]] && source $HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/etc/bash_completion.d/cargo

export LS_COLORS='di=0;34:ex=0;32:so=0;35:do=0;35:ln=0;36:cd=0;33:bd=0;33:or=0;31:'
unset DEBUGINFOD_URLS

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias gitconfig="git config user.name Flying-Toast && git config user.email 38232168+Flying-Toast@users.noreply.github.com"
alias re="nvim +'Ft rust'"
alias o="xdg-open"

export PS1="\[$(tput setaf 0)\]\w\[$(tput setaf 3)\]$\[$(tput sgr0)\] "
export github="git@github.com:Flying-Toast"
export EDITOR="vi"
export MANPAGER="nvim +Man!"
export LESSHISTFILE="-"

shopt -s histappend

bind "\C-k":history-search-backward
bind "\C-j":history-search-forward
