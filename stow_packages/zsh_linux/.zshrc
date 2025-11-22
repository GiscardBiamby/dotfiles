# zmodload zsh/zprof # top of your .zshrc file

# For Tilix:
# https://github.com/gnunn1/tilix/wiki/VTE-Configuration-Issue
# On Ubuntu you probably need a symlink for vte.sh in order for the below line to work:
# ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
if [[ ($TILIX_ID || $VTE_VERSION) && -f /etc/profile.d/vte.sh   ]]; then
    source /etc/profile.d/vte.sh
fi

# .zshrc is for interactive shells. You set options for the interactive shell there with the setopt
# and unsetopt commands. You can also load shell modules, set your history options, change your
# prompt, set up zle and completion, et cetera. You also set any variables that are only used in the
# interactive shell (e.g. $LS_COLORS).

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="random"
# ZSH_THEME="apple"
ZSH_THEME="gbiamby"

# Disable SSH hosts completion to speed up shell startup time.
# From: https://destinmoulton.com/notes/howto/how-to-disable-zsh-ssh-hosts-completion/
zstyle ':completion:*:ssh:*' hosts off

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# * Shell Options (load before loading omz)
if [ -f ~/.zsh_options ]; then
    . ~/.zsh_options
fi

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
zstyle ':omz:plugins:nvm' lazy yes
typeset -U plugins
plugins=(
    colorize
    copybuffer
    direnv
    docker
    docker-compose
    extract
    # eza # a modern replacement for ls with git integration, icons and better colors
    fzf
    # fzf-tab # Should load this after compinit, so it's loaded at the end of this file.
    # gcloud
    git
    git-prompt
    gitignore
    git-extras
    git-lfs
    history
    nvm
    npm
    pip
    python
    rsync
    sudo # allows you to easily prepend sudo to your current or previous commands by pressing Esc twice.
    tmux
    zoxide
    zsh-bat # a cat(1) clone with syntax highlighting and Git integration
)
# Load custom pugsin (these are installed in `scripts/programs/oh-my-zsh.sh`):
if [[ -d ~/.oh-my-zsh/custom/plugins/conda-zsh-completion ]]; then
    echo "Loading zsh plugin: conda-zsh-completion"
    plugins+=(conda-zsh-completion)
fi
if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    echo "Loading zsh plugin: zsh-autosuggestions"
    plugins+=(zsh-autosuggestions)
fi
# Moved to bottom for proper loading order. Keep here temporarily:
# if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
#     echo "Loading zsh plugin: zsh-syntax-highlighting"
#     plugins+=(zsh-syntax-highlighting)
# fi

# * Keychain: will start, start ssh-agent for you if it has not yet been started, use ssh-add to add
# * your id_rsa private key file to ssh-agent, and set up your shell environment so that ssh will be
# * able to find ssh-agent. If ssh-agent is already running, keychain will ensure that your id_rsa
# * private key has been added to ssh-agent and then set up your environment so that ssh can find the
# * already-running ssh-agent.
# * NOTE: don't use on a remote where you want to use agent forwarding:
if [[ -z "$SSH_CONNECTION" ]]; then
    plugins+=(keychain)
    zstyle :omz:plugins:keychain agents gpg,ssh
    zstyle :omz:plugins:keychain identities id_ed25519 id_rsa-bairdev id_ed25519sk-brb-sk01 id_ed25519sk-brb-sk02
fi

# * Tell OMZ not to run compinit (we'll do it ourselves)
zstyle ':omz:completion' skip yes

# * Use the same dump file OMZ would use
export ZSH_COMPDUMP="${ZDOTDIR}/.zcompdump-${HOST}-${ZSH_VERSION}"

source $ZSH/oh-my-zsh.sh

# *  Show conda/mamba env in the prompt
# Only prepend if not already there to avoid duplication on reload
setopt PROMPT_SUBST
if [[ "$PROMPT" != *'${CONDA_DEFAULT_ENV'* ]]; then
    PROMPT='${CONDA_PROMPT_MODIFIER:-${CONDA_DEFAULT_ENV:+($CONDA_DEFAULT_ENV) }}'"$PROMPT"
fi

# * Load machine-specific .zshrc_local if one exists (it's not managed by stow):
if [[ -f "$HOME/.zshrc_local" ]]; then
    . "$HOME/.zshrc_local"
fi

# * Functions
if [ -f ~/.zsh_functions ]; then
    . ~/.zsh_functions
fi

# * Alias definitions.
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

# * Generate auto-complete cache once every 24hr. The original code slows down zsh startup time by a
# *  lot (use zstat to avoid glob issues):
zmodload zsh/stat
autoload -Uz compinit
if [[ -e "$ZSH_COMPDUMP" ]]; then
    typeset -A st
    zstat -H st -- "$ZSH_COMPDUMP"
    if ((EPOCHSECONDS - st[mtime] < 86400)); then
        compinit -C -d "$ZSH_COMPDUMP" # fresh: fast path
    else
        compinit -d "$ZSH_COMPDUMP"  # old: regenerate
    fi
else
    compinit -d "$ZSH_COMPDUMP"      # missing: create
fi

# * Load fzf-tab (Must be loaded AFTER compinit)
# if [[ -f "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab/fzf-tab.plugin.zsh" ]]; then
#     source "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab/fzf-tab.plugin.zsh"
# fi

# * Syntax Highlighting (Best loaded at the very end)
if [[ -f "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    echo "Loading zsh plugin: zsh-syntax-highlighting"
    source "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# * Display if login/interactive shell
# This is a debugging print statement. Comment this out to keep terminal clean and avoid SCP noise
# [[ $- == *i* ]] && echo 'Interactive shell' || echo 'Not interactive shell'

# * To profile the zsh load speed uncomment the top line and this bottom line:
# zprof # bottom of .zshrc
