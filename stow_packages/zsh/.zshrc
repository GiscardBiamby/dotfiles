export PATH="/usr/local/bin:/usr/local/sbin:~/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# yubikey
# To use this SSH agent, set this variable in your ~/.zshrc and/or ~/.bashrc:
#   export SSH_AUTH_SOCK="/opt/homebrew/var/run/yubikey-agent.sock"

# To restart yubikey-agent after an upgrade:
#   brew services restart yubikey-agent
# Or, if you don't want/need a background service you can just run:
#   /opt/homebrew/opt/yubikey-agent/bin/yubikey-agent -l /opt/homebrew/var/run/yubikey-agent.sock


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/gbiamby/mambaforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
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

