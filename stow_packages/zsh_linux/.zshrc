# zmodload zsh/zprof # top of your .zshrc file

# For Tilix:
# https://github.com/gnunn1/tilix/wiki/VTE-Configuration-Issue
# On Ubuntu you probably need a symlink for vte.sh in order for the below line to work:
# ln -s /etc/profile.d/vte-2.91.sh /etc/profile.d/vte.sh
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
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

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    ag
    colorize
    conda-zsh-completion
    copybuffer
    direnv
    docker
    docker-compose
    extract
    fzf
    gcloud
    git
    git-prompt
    gitignore
    git-extras
    git-lfs
    gpg-agent
    history
    keychain
    nvm
    # npm
    pip
    python
    rsync
    # ssh-agent
    tmux
)
# Load custom pugsin (these are installed in `scripts/programs/oh-my-zsh.sh`):
if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ]]; then
    echo "Loading zsh plugin: zsh-autosuggestions"
    plugins+=(zsh-autosuggestions)
fi
if [[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ]]; then
    echo "Loading zsh plugin: zsh-syntax-highlighting"
    plugins+=(zsh-syntax-highlighting)
fi
if [[ -d ~/.oh-my-zsh/custom/plugins/conda-zsh-completion ]]; then
    echo "Loading zsh plugin: conda-zsh-completion"
    plugins+=(conda-zsh-completion)
fi
if [[ -d ~/.oh-my-zsh/custom/plugins/yt-dlp ]]; then
    echo "Loading zsh plugin: yt-dlp"
    plugins+=(yt-dlp)
fi


autoload -Uz compinit
# Do auto complete cache once every 24hr. The original code slows down zsh startup time by a lot:
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done
compinit -C

# Keychain: will start, start ssh-agent for you if it has not yet been started, use ssh-add to add
# your id_rsa private key file to ssh-agent, and set up your shell environment so that ssh will be
# able to find ssh-agent. If ssh-agent is already running, keychain will ensure that your id_rsa
# private key has been added to ssh-agent and then set up your environment so that ssh can find the
# already-running ssh-agent.
zstyle :omz:plugins:keychain agents gpg,ssh
zstyle :omz:plugins:keychain identities id_ed25519 id_rsa-bairdev id_ed25519sk-brb-sk01 id_ed25519sk-brb-sk02

source $ZSH/oh-my-zsh.sh

# ssh
# eval `keychain --eval id_ed25519 id_rsa-bairdev`
# eval $(ssh-agent -s)
# ssh-add ~/.ssh/id_rsa-bairdev


# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='code --wait'
else
    export EDITOR='vim'
fi

## PATH
if [[ -f /usr/local/krb5/etc/krb5.conf ]]; then
    export KRB5_CONFIG=/usr/local/krb5/etc/krb5.conf
else
    echo "WARNING: /usr/local/krb5/etc/krb5.conf does not exist"
fi
# Prepend PATH. lowercase "path" is bound to uppercase "PATH" (courtesy of https://stackoverflow.com/a/18077919)
path=(
    "/usr/local/ossh/bin"
    "/usr/local/krb5/bin"
    "/usr/local/bin"
    "/usr/local/sbin"
    "~/bin"
    "/usr/bin/Postman/app"
    $path
)
# Manually install noisetorch. Still need to load the app and activate it after each startup.
if [ -d "/opt/noisetorch/bin" ] ; then
    path+="/opt/noisetorch/bin"
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('${HOME}/mambaforge/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${HOME}/mambaforge/etc/profile.d/conda.sh" ]; then
        . "${HOME}/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="${HOME}/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "${HOME}/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "${HOME}/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
export PATH


eval "$(direnv hook zsh)"

# Load machine-specific .zshrc_local if one exists (it's not managed by stow):
if [[ -f "$HOME/.zshrc_local" ]]; then
    . "$HOME/.zshrc_local"
fi
if [[ -f "$HOME/.zshrc_${HOSTNAME}" ]]; then
    . "$HOME/.zshrc_${HOSTNAME}"
fi

# Shell Options
if [ -f ~/.zsh_options ]; then
    . ~/.zsh_options
fi

# Functions
if [ -f ~/.zsh_functions ]; then
    . ~/.zsh_functions
fi

# Alias definitions.
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

# Customize the prompt to show directory:
# PROMPT="%(?:%{%}%1{➜%} :%{%}%1{➜%} ) %{%}%c%{%} $(git_prompt_info)"
# export PROMPT="%(?:%{%}%1{➜%} :%{%}%1{➜%} ) %F{blue}%~%f $(git_prompt_info)"

# Display if login/interactive shell
# [[ $- == *i* ]] && echo 'Interactive shell' || echo 'Not interactive shell'

# To profile the zsh load speed uncomment the top line and this bottom line:
# zprof # bottom of .zshrc
