#!/bin/bash

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Functions
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Bash completion.
if [ -f ~/.bash_complete ]; then
    . ~/.bash_complete
fi

# Bash prompt.
if [ -f ~/.bash_prompt ]; then
    . ~/.bash_prompt
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/gbiamby/mambaforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/${USER}/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/home/${USER}/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/home/${USER}/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/${USER}/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "/home/${USER}/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<


# My stuff:
export PATH="/usr/local/ossh/bin:/usr/local/krb5/bin:$PATH"

# # This has to do with TILIX. I don't think it's needed anymore.
# if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
#     source /etc/profile.d/vte.sh
# fi

echo "Init conda for bash"
eval "$(direnv hook bash)"

export EDITOR="code --wait"
export NVM_DIR="$HOME/.nvm"

# Load nvm:
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
