# dotfiles

## Usage

```sh
# Change default shell to zsh:
sudo chsh -s /bin/zsh $USER
```

```sh
git clone git@github.com:GiscardBiamby/dotfiles.git --recurse-submodules
cd dotfiles
git checkout hpc

# Install omz:
~/dotfiles/scripts/oh-my-zsh.sh

# Install zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/esc/conda-zsh-completion.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/conda-zsh-completion
git clone https://github.com/clavelm/yt-dlp-omz-plugin.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/yt-dlp

rsync -auh --ignore-existing ~/dotfiles/stow_packages/stow/local/ ~/local/
exec zsh
~/dotfiles/scripts/dotfiles.sh
```

__install fast version of git-branch-name, and use this instead of the git-prompt zsh plugin__
(don't need it's part of dotfiles)
```bash
git clone https://github.com/notfed/git-branch-name
cd git-branch-name
make
install git-branch-name "${HOME}/local/bin/"
```

Restart your terminal (or `exec zsh`) to see changes.

There are some weird things happening with nvm that I haven't looked into yet. But it can block diff-so-fancy from installing correctly, forcing you to install in manually.

## Manual Steps

### Fix error in bash-git-prompt

TODO: Automate this (with sed?)

## On Systems with AMD CPU

__UPDATE__: This step is no longer necessary? The `.bashsrc` entries

[Install blas to improve math library performance (numpy, scikit, etc)](https://www.pugetsystems.com/labs/hpc/AMD-Ryzen-3900X-vs-Intel-Xeon-2175W-Python-numpy---MKL-vs-OpenBLAS-1560/)

Do this for any conda env's:

```bash
conda activate <ENV_NAME>
conda install -y blas=*=openblas
```

## Random Helpful Stuff

### Clone all your remote repositories

Given a list of repository URLs, `gh-repos.txt` , run:

```sh
xargs -n1 git clone < gh-repos.txt
```

Use the [ `firewood` Bash alias](https://github.com/victoriadrake/dotfiles/blob/ubuntu-20.04/.bashrc#L27) to collect remote branches.

See [How to write Bash one-liners for cloning and managing GitHub and GitLab repositories](https://victoria.dev/blog/how-to-write-bash-one-liners-for-cloning-and-managing-github-and-gitlab-repositories/) for more.



## Your personal CLI tool Makefile

See the Makefile in this repository for some helpful command aliases. Read about [self-documenting Makefiles on my blog](https://victoria.dev/blog/how-to-create-a-self-documenting-makefile/).
