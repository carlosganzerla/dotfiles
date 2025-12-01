#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.private_bash_aliases ]; then
    . ~/.private_bash_aliases
fi

if [ -f ~/.private_envs ]; then
    . ~/.private_envs
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\H@\u \w]\$ '

eval "$(pyenv init --path)"

export UV_USE_IO_URING=0
export SYSTEMD_EDITOR=nvim
export PAGER='less -X'
export EDITOR=nvim
