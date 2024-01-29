[[ $- != *i* ]] && return

export PATH="$PATH:$HOME/.cargo/bin:$HOME/.local/bin"

source /usr/share/bash-completion/bash_completion
[[ -f $HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/etc/bash_completion.d/cargo ]] && source $HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/etc/bash_completion.d/cargo

eval $(dircolors)

alias ls="ls --color=auto"
alias grep="grep --color=auto"
alias gitconfig="git config user.name Flying-Toast && git config user.email 38232168+Flying-Toast@users.noreply.github.com"
alias re="vim +'Ft rust'"

export PS1="\[\e]0;\u@\h: \w\a\]\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$ "
export github="git@github.com:Flying-Toast"
export EDITOR="vim"
export MANPAGER="vim +Man!"
export LESSHISTFILE="-"

shopt -s histappend

bind "\C-k":history-search-backward
bind "\C-j":history-search-forward
