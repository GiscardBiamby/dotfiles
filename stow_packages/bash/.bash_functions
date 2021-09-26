# Show contents of dir after action
function cd() {
    builtin cd "$1"
    ls -ACF
}

# Markdown link check in a folder, recursive
function mlc() {
    find $1 -name \*.md -exec markdown-link-check -p {} \;
}

function gitBranch() {
    # Displays current branch
    git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

function update_tmux_conf() {
    # Reload .tmux.conf
    tmux source-file ~/.tmux.conf
}

function ssh_fix() {
    eval "$(ssh-agent)"
    ssh-add
}

function user_disk_space() {
    df -h --output=target,used /home/* | sed 1d | sort -k2 -h
}

function biggest_folders() {
    local path="${1:-./}"
    local num_results="${2:-20}"
    du -ah "${path}" | sort -h -r | head -n "${num_results}"
}

function dir_size() {
    local path="${1:-./}"
    du -h --max-depth=0 "${path}"
}

function sync_dir() {
    # Sync one dir to another, showing progress, resume if possible, enable compression. This
    # function ensures that the files are synced rather than the folder itself being transfered.
    local src="${1}"
    local target="${2}"
    # Ensure paths have trailing slashes so we sync folder contents rather than folder itself:
    [[ "${src}" != */ ]] && src="${src}/"
    [[ "${target}" != */ ]] && src="${target}/"
    echo "Synching dir FROM: '${src}', TO: '${target}'..."
    dir_size "${src}"
    rsync -xauvzrP "${src}" "${target}"
}

# ex - archive extractor
# usage: ex <file>
function extract() {
    if [ -f $1 ]; then
        case $1 in
        *.tar.bz2) tar xjf $1 ;;
        *.tar.gz) tar xzf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) unrar x $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;;
        *.tbz2) tar xjf $1 ;;
        *.tgz) tar xzf $1 ;;
        *.zip) unzip $1 ;;
        *.Z) uncompress $1 ;;
        *.7z) 7z x $1 ;;
        *) echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
