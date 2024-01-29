" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number

" Highlight cursor line underneath the cursor horizontally.
set cursorline

" Highlight cursor line underneath the cursor vertically.
set cursorcolumn

" Set shift width to 4 spaces.
set shiftwidth=4

" Set tab width to 4 columns.
set tabstop=4

" Use space characters instead of tabs.
set expandtab

" Do not save backup files.
set nobackup

" Automatically save before :next, :make etc. "
set autowrite

" Set default encoding to UTF-8
set encoding=UTF-8

" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=10

" Make Vim to handle long lines nicely.
set wrap
set textwidth=80
set formatoptions=qrn1


" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set smartcase

" Show partial command you type in the last line of the screen.
set showcmd

" Show the mode you are on the last line.
set showmode

" While searching though a file incrementally highlight matching characters as you type.
set incsearch

" Show matching words during a search.
set showmatch

" Use highlighting when doing a search.
set hlsearch

" Set the commands to save in history default number is 20.
set history=10000

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Allow backspace to work over auto-indents, EOLs, and 'over the start position of where you
" started insert mode'. Without start, you can enter Insert mode, type a bit, and then when
" backspacing, only delete back as far as the start of Insert mode.
set backspace=indent,eol,start  " Makes backspace key more powerful.


" Apply the indentation of the current line to the next line.
set autoindent
set smartindent
set complete-=i
set showmatch
set smarttab


" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

" If Linux then set ttymouse
let s:uname = system("echo -n \"$(uname)\"")
if !v:shell_error && s:uname == "Linux" && !has('nvim')
    set ttymouse=xterm
endif

" Color Scheme
colorscheme gruvbox