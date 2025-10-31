# .zshenv is always sourced. It often contains exported variables that should be available to other
# programs. For example, $PATH, $EDITOR, and $PAGER are often set in .zshenv. Also, you can set
# $ZDOTDIR in .zshenv to specify an alternative location for the rest of your zsh configuration.

# Ensure PATH has no duplicates and preserves first occurrence
typeset -U path

# Prepend PATH. lowercase "path" is bound to uppercase "PATH" (courtesy of https://stackoverflow.com/a/18077919)
# Disable the krb line in order for yubikey ssh auth to work (there must be a better way?):
path=(
    "${HOME}/.local/bin"
    "${HOME}/local/bin"
    "/usr/local/bin"
    "/usr/local/krb5/bin" # needed for kerberos (kinit)
    "/usr/local/sbin"
    "${HOME}/bin"
    # "/usr/bin/Postman/app"
    $path
)

# * Manually install noisetorch. Still need to load the app and activate it after each startup.
if [ -d "/opt/noisetorch/bin" ]; then
    path+="/opt/noisetorch/bin"
fi

export PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("${HOME}/miniforge3/bin/conda" 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${HOME}/miniforge3/etc/profile.d/conda.sh" ]; then
        . "${HOME}/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="${HOME}/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba shell init' !!
export MAMBA_EXE="${HOME}/miniforge3/bin/mamba"
export MAMBA_ROOT_PREFIX="${HOME}/miniforge3"
__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__mamba_setup"
else
    alias mamba="$MAMBA_EXE"  # Fallback on help from mamba activate
fi
unset __mamba_setup
# <<< mamba initialize <<<

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

# * Prevents long command outputs (like apt, man, git) from opening a scrollable pager (like less) by
# * forcing output to stream directly to the terminal using /bin/cat.
export PAGER="/bin/cat"

# * Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='code --wait'
else
    export EDITOR='nano'
fi

## * ossh krb config
if [[ -f /usr/local/krb5/etc/krb5.conf ]]; then
    export KRB5_CONFIG=/usr/local/krb5/etc/krb5.conf
# else
#     echo "WARNING: /usr/local/krb5/etc/krb5.conf does not exist"
fi

# * Note: .zshenv is only sourced for shells, not GUI apps. If you want an environment var to take
# * effect even for GUI apps (aka .desktop shortcuts), add the environment vars to
# * ~/.config/environment.d/
#export MOZ_ENABLE_WAYLAND=1

# * Example: set the default libvirt URI for QEMU/KVM virtual machines
export LIBVIRT_DEFAULT_URI="qemu:///system"

if [[ -f "${HOME}/perl5/bin" ]]; then
    path+="${HOME}/perl5/bin"
    PERL5LIB="${HOME}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
    export PERL5LIB
    PERL_LOCAL_LIB_ROOT="${HOME}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
    export PERL_LOCAL_LIB_ROOT
    PERL_MB_OPT="--install_base \"/home/${USER}/perl5\""
    export PERL_MB_OPT
    PERL_MM_OPT="INSTALL_BASE=/home/${USER}/perl5"
    export PERL_MM_OPT
fi

export PATH
