# Show contents of dir after action
function cd() {
    builtin cd "$1"
    ll
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

function get_biggest_folders() {
    local path="${1:-./}"
    local num_results="${2:-20}"
    du -ah "${path}" | sort -h -r | head -n "${num_results}"
}

function get_large_files() {
    local path="${1:-./}"
    local size="${2:-500}"
    echo "Finding files in '${path}', larger than: ${size}M..."
    find "${path}" -xdev -type f -size "+${size}M" -exec du -sh {} \;
}

function get_dir_size() {
    local path="${1:-./}"
    du -h --max-depth=0 "${path}"
}

function get_file_count() {
    local path="${1:-./}"
    find "${path}" -type f | wc -l
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
    get_dir_size "${src}"
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

function tar_multicore() {
    # If 2nd arg is not specified, uses the first arg (folder to compress) + ".tar.gz" as the
    # output filename
    local folder_path="${1}"
    local out_name="${2}"
    if [ -z "$2" ]; then
        # echo "No argument supplied"
        out_name="${folder_path}.tar.gz"
    else
        if [[ $out_name != *.tar.gz ]]; then
            echo "Invalid archive name was specified: ${out_name}"
            return
        fi
    fi

    echo "input folder: ${folder_path}"
    echo "output file : ${out_name}"
    tar --use-compress-program="pigz -k " -cf "${out_name}" "${folder_path}"
}

function list_git_repos() {
    find . -maxdepth 10 -type d -exec test -e '{}/.git' ';' -printf "is git repo: %p\n"
}

function clean_notebook() {
    local notebook_path="${1}"
    python -m nbconvert --ClearOutputPreprocessor.enabled=True --inplace "${notebook_path}"
    # python -m nbconvert --ClearOutputPreprocessor.enabled=True --inplace *.ipynb **/*.ipynb
}

function run_notebook() {
    local notebook_path="${1}"
    python3 -m nbconvert --ExecutePreprocessor.timeout=-1 --execute --inplace "${notebook_path}"
}

function clean_git_history_for_notebooks() {
    git filter-branch --tree-filter \
        "python3 -m nbconvert --ClearOutputPreprocessor.enabled=True --inplace *.ipynb **/*.ipynb || true"
}

function map_shared() {
    sshfs -o idmap=user gbiamby@cthu5:/shared bair_shared
}
