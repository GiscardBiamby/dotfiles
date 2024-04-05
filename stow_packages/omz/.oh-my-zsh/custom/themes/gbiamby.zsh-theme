PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) ${SHORT_HOST}:%{$fg[cyan]%}%~%{$reset_color%}"
# PROMPT+=' $(git_prompt_info)> '
# PROMPT+=' $(~/local/bin/git-branch-name)> '
ref=$(~/local/bin/git-branch-name -q -h 6 -b 20) || return
PROMPT+='<$(~/local/bin/git-branch-name)>'
# Controls the git prompt (not the git stuff that appears floating on the right):
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
