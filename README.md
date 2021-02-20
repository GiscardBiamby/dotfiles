# dotfiles

Based on: <https://github.com/victoriadrake/dotfiles>

My preferred starting configuration for Ubuntu Desktop. Current version 20.04 Focal Fossa.

The [installation script included](./scripts/install.sh) will install a suggested serving of programs and applications, found within the `scripts/` directory. Please verify that you want these before running the script.

Add or delete files in `scripts/install.sh` and `scripts/programs/` to modify your installation.

## Usage

After installing your fresh OS, do:

```sh
sudo apt install git -y
```

Use nano to create any SSH keys you need to access GitHub, and remember to run `eval "$(ssh-agent)"` and then `ssh-add`, as well as `chmod 600 <key_name>`. Then clone this repository:

```sh
git clone git@github.com:GiscardBiamby/dotfiles.git
# OR use HTTPS
git clone https://github.com/GiscardBiamby/dotfiles.git
```

Close Firefox if it's open, then run the installation script.

For server only:

```sh
cd dotfiles/scripts/
./install.sh
```

For workstation only (installs GUI apps like chrome, firefox, GIMP, etc):

```sh
cd dotfiles/scripts/
./install.sh "workstation"
```

Uncomment the relevant lines in `.bashrc`, then restart your terminal to see changes, or run:

```sh
cd ~
source .bashrc
```

## On Systems with AMD CPU

[Install blas to improve math library performance (numpy, scikit, etc)](https://www.pugetsystems.com/labs/hpc/AMD-Ryzen-3900X-vs-Intel-Xeon-2175W-Python-numpy---MKL-vs-OpenBLAS-1560/)

Do this for any conda env's:

```
conda activate <ENV_NAME>
conda install -y blas=*=openblas
```

## Fix screen tearing (e.g., choppy animation when dragging windows around, for workstation only)

Also note, different web results use different file names, so I did this but with multiple file names, i’m not sure which one is the one that makes it work:
Nvidia-nomodeset.conf and nvidia-drm-nomodeset.conf

```bash
sudo echo "options nvidia-drm modeset=1" >> /etc/modprobe.d/nvidia-drm-nomodeset.conf
sudo update-initramfs -u
sudo reboot
```

Go to the Nvidia X Server Settings -> X server Display Configuration -> Advanced, the "ForceFullCompositionPipeline" option (check both if possible).
You have to do this once for each display.
Save the changes to Xorg.conf and restart the system.

## Random Helpful Stuff (TM)

### Clone all your remote repositories

Given a list of repository URLs, `gh-repos.txt`, run:

```sh
xargs -n1 git clone < gh-repos.txt
```

Use the [`firewood` Bash alias](https://github.com/victoriadrake/dotfiles/blob/ubuntu-20.04/.bashrc#L27) to collect remote branches.

See [How to write Bash one-liners for cloning and managing GitHub and GitLab repositories](https://victoria.dev/blog/how-to-write-bash-one-liners-for-cloning-and-managing-github-and-gitlab-repositories/) for more.

### Terminal theme

There are plenty of themes for Gnome terminal at [Mayccoll/Gogh](https://github.com/Mayccoll/Gogh).

Print a 256-color test pattern in your terminal:

```sh
for i in {0..255} ; do
    printf "\x1b[48;5;%sm%3d\e[0m " "$i" "$i"
    if (( i == 15 )) || (( i > 15 )) && (( (i-15) % 6 == 0 )); then
        printf "\n";
    fi
done
```

### Saving and loading configuration settings

Optionally, load `settings.dconf` with:

```sh
dconf load /org/gnome/ < .config/dconf/settings.dconf
```

Back up new settings with:

```sh
dconf dump /org/gnome/ > .config/dconf/settings.dconf
```

Run `man dconf` on your machine for more.

## Your personal CLI tool Makefile

See the Makefile in this repository for some helpful command aliases. Read about [self-documenting Makefiles on my blog](https://victoria.dev/blog/how-to-create-a-self-documenting-makefile/).

## Recommended additions

* GNOME Tweaks
* [Emoji Selector](https://extensions.gnome.org/extension/1162/emoji-selector/) ❤️✨🦄
* [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)
