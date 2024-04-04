host_short=$(hostname | cut -d'.' -f1)
PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) ${host_short}:[%{$fg[cyan]%}%~%{$reset_color%}]"
# PROMPT+=' $(git_prompt_info)> '
PROMPT+=' $(~/local/bin/git-branch-name)> '

# Controls the git prompt (not the git stuff that appears floating on the right):
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
