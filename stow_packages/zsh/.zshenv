# .zshenv is always sourced. It often contains exported variables that should be available to other
# programs. For example, $PATH, $EDITOR, and $PAGER are often set in .zshenv. Also, you can set
# $ZDOTDIR in .zshenv to specify an alternative location for the rest of your zsh configuration.

# Ensure PATH has no duplicates and preserves first occurrence
typeset -U path

# Prepend PATH. lowercase "path" is bound to uppercase "PATH" (courtesy of https://stackoverflow.com/a/18077919)
# Disable the krb line in order for yubikey ssh auth to work (there must be a better way?):
path=(
    "~/local/bin"
    # "/usr/local/ossh/bin"
    # "/usr/local/krb5/bin"
    "/usr/local/bin"
    "/usr/local/sbin"
    "~/bin"
    $path
)
export PATH

# Manually install noisetorch. Still need to load the app and activate it after each startup.
if [ -d "/opt/noisetorch/bin" ]; then
    path+="/opt/noisetorch/bin"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/gbiamby/mambaforge/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/gbiamby/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/Users/gbiamby/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/Users/gbiamby/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/Users/gbiamby/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "/Users/gbiamby/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# * FZF defaults placed in .zshenv so both interactive shells and scripts inherit them.
# * .zshenv runs before .zshrc/oh-my-zsh, so OMZ keybindings (Ctrl-T/Alt-C) see these values.
# * Semantics: Ctrl-T sources files; Alt-C sources directories. Prefer fd; fall back to rg/find if absent.
# * This block only exports env vars (no heavy work), so it’s safe here and applies to all new zsh sessions.
if command -v fd >/dev/null 2>&1; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git 2>/dev/null'
    export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git 2>/dev/null'
else
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git" 2>/dev/null' # files
    export FZF_ALT_C_COMMAND='find -L . -type d -not -path "*/.git/*" 2>/dev/null'      # dirs
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --inline-info'

# * Ensure all shells see this before /etc/zsh/zshrc
export ZDOTDIR="${ZDOTDIR:-$HOME}"

# * Prevent global compinit so we fully control it
typeset -g skip_global_compinit=1


export PATH
