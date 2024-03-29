# Alias definitions.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias reload_tmux="update_tmux_conf"
alias ls='ls  -aF --color=auto'
alias ll='ls -ahlF --group-directories-first'
alias la='ls -a --group-directories-first'
alias l='ls -CF --group-directories-first'
alias ag='ag --hidden --path-to-ignore ~/.agignore'
alias xclip="xclip -selection c"

# New stuff, haven't tried yet:
alias grep='grep --color=auto'
alias grepw='grep --color=auto -Hrnwi'
alias mkdir='mkdir -pv'
alias mv='mv -v'
# alias wget='wget -c'
alias tree="tree -aI 'test*|.git|node_modules|resources'"
alias branches='git branch -v'
alias firewood='for remote in `git branch -r`; do git branch --track ${remote#origin/} $remote; done'

# # Use programs without a root-equivalent group
# alias docker='sudo docker'
# alias docker-compose='sudo docker-compose'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
