# dotfiles

A nice dotfiles repo example: <https://github.com/anishathalye/dotfiles/blob/master/bashrc>

Based on: <https://github.com/victoriadrake/dotfiles>

My preferred starting configuration for Ubuntu Desktop. Current version 23.10 Mantic. This includes dotfiles as well as software install scripts for mac and linux.

Add or delete files in `scripts/install.sh` and `scripts/programs/` to modify your installation.

## Usage


```sh
# Change default shell to zsh:
sudo chsh -s /bin/zsh $USER
sudo apt install git -y
```

Setup `~/.ssh/` keys for GitHub, and remember to run `eval "$(ssh-agent)"` and then `ssh-add`, as well as `chmod 600 <private_key_name>` / `chmod 644 <pub_key_name>`. Then clone this repository:

```sh
git clone git@github.com:GiscardBiamby/dotfiles.git --recurse-submodules

# OR use HTTPS
git clone https://github.com/GiscardBiamby/dotfiles.git --recurse-submodules
```

Close Firefox if it's open, then run the installation script.

For server only:

```sh
cd dotfiles/scripts/
./install.sh
```

For workstation only (installs GUI apps like chrome, Firefox, GIMP, etc):

```sh
cd dotfiles/scripts/
./install.sh "workstation"
```

Restart your terminal or `source ~/.zshrc` to see changes.

There are some weird things happening with nvm that I haven't looked into yet. But it can block diff-so-fancy from installing correctly, forcing you to install in manually.

## Manual Steps

### Fix error in bash-git-prompt

TODO: Automate this (with sed?)

There is a bug in newer versions of bash-git-prompt, in their `set_gitprompt_dir()` function. Edit `~/.bash-git-prompt/gitprompt.sh`, replacing the function with this one:

```bash
function git_prompt_dir() {
  # assume the gitstatus.sh is in the same directory as this script
  # code thanks to http://stackoverflow.com/questions/59895
  if [[ -z "${__GIT_PROMPT_DIR:+x}" ]]; then
    local SOURCE="${BASH_SOURCE[0]}"
    while [[ -h "${SOURCE}" ]]; do
      local DIR="$( command cd -P "$( dirname "${SOURCE}" )" && pwd )"
      SOURCE="$(readlink "${SOURCE}")"
      [[ ${SOURCE} != /* ]] && SOURCE="${DIR}/${SOURCE}"
    done
    __GIT_PROMPT_DIR="$( command cd -P "$( dirname "${SOURCE}" )" && pwd )"
  fi
}
```

<!-- ### Make Anki use Wayland

Edit `/usr/local/share/applications/anki.desktop`, add `ANKI_WAYLAND=1` before the exec:

```
Exec=ANKI_WAYLAND=1 anki %f
``` -->

## On Systems with AMD CPU

__UPDATE__: This step is no longer necessary? The `.bashsrc` entries

[Install blas to improve math library performance (numpy, scikit, etc)](https://www.pugetsystems.com/labs/hpc/AMD-Ryzen-3900X-vs-Intel-Xeon-2175W-Python-numpy---MKL-vs-OpenBLAS-1560/)

Do this for any conda env's:

```bash
conda activate <ENV_NAME>
conda install -y blas=*=openblas
```

## Fix screen tearing (e.g., choppy animation when dragging windows around, for workstation only) for systems with NVIDIA GPU

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

## Random Helpful Stuff

## Make vscode run in native Wayland mode

Add these flags to the two `code` commands in `/usr/share/applications/code.desktop`:

```bash
code --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-features=WaylandWindowDecorations
```

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

## Zotero and ZotFile: Use Dropbox for Syncing PDFs

To use Dropbox to manage paper pdf's in Zotero (instead of Zotero's storage, which is limited to 300MB), install the Zotfile plugin. This lets your Zotero library sync across devices. Zotero will still manage the library entries and metadata via it's own storage. With this setup and around 200 papers in my library, my Dropbox has \~400MB of PDF's, and the library only uses up \~11MB of my Zotero free storage.

1. Install the Zotfile extension
2. Choose a folder inside your Dropbox dir that will store your pdf's. Let's call this the `$ZOTERO_ATTACHMENTS_DIR`. For example: `$ZOTERO_ATTACHMENTS_DIR=/home/username/Dropbox/private/Zotero/main/`.
3. Zotero-> Edit -> Preferences -> Advanced -> Files and Folders -> Base Directory: __Set this to your `$ZOTERO_ATTACHMENTS_DIR` folder__
4. Zotero-> Sync -> Settings -> File Syncing -> Sync attachment files in My Library using: Zotero
5. Zotero -> Tools -> Zotfile Preferences -> General Settings -> Location of Files -> Custom Location: __Set this to your `$ZOTERO_ATTACHMENTS_DIR` folder__
6. If you need to convert existing library entries from Zotero storage to this Dropbox synced location, select the entire My Library -> right click -> Manage Attachments -> Rename Attachments. (Note, if you have done Manage Attachments -> Send to Tablet,  you will have to do Manage Attachments -> Get From Tablet before you can perform this step.

### Zotero and ZotFile: Sending to/from Tablet

This section is only relevant if you want to use a workflow where you can manually send papers to your tablet (via a cloud synced folder, e.g., Dropbox), read/annotate on the tablet, and then get back the annotations onto your computer (via Manage Attachments -> Get From Tablet). If you don't have a tablet or don't want to use that workflow you can ignore this section.

1. Zotero -> Tools -> Zotfile Preferences -> Tablet Settings -> Use ZotFile to send and get files from tablet -> __CHECKED__
2. Zotero -> Tools -> Zotfile Preferences -> Tablet Settings -> Location of Files on Tablet-> Base Folder: `$ZOTERO_TABLET_DIR`
3. Zotero -> Tools -> Zotfile Preferences -> Tablet Settings -> Location of Files on Tablet -> Subfolders: Select "Create subfolders from zotero collections" option

Don't use the `$ZOTERO_ATTACHMENTS_DIR` for this. I typically set this to a sibling folder to `ZOTERO_ATTACHMENTS_DIR`. These are not environment variables. I'm just using this notation for the formatting in this markdown. So I then have:

| Folder                    | Path                                            |
| ------------------------- | ----------------------------------------------- |
| `$ZOTERO_ATTACHMENTS_DIR` | `/home/username/Dropbox/private/Zotero/main/`   |
| `$ZOTERO_TABLET_DIR`      | `/home/username/Dropbox/private/Zotero/tablet/` |

## Your personal CLI tool Makefile

See the Makefile in this repository for some helpful command aliases. Read about [self-documenting Makefiles on my blog](https://victoria.dev/blog/how-to-create-a-self-documenting-makefile/).

## Recommended additions

* GNOME Tweaks
* [Emoji Selector](https://extensions.gnome.org/extension/1162/emoji-selector/)
* [Clipboard Indicator](https://extensions.gnome.org/extension/779/clipboard-indicator/)
