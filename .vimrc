set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Markdown
Plugin 'plasticboy/vim-markdown'

" Go development plugin for Vim
Plugin 'fatih/vim-go'

Plugin 'elzr/vim-json'

Bundle 'chase/vim-ansible-yaml'

Bundle 'scrooloose/nerdtree'

Bundle 'nanotech/jellybeans.vim'

Bundle 'kien/ctrlp.vim'

let s:python_ver = 0
silent! python import sys, vim;
\ vim.command("let s:python_ver="+"".join(map(str,sys.version_info[0:3])))

" Python plugin bundles
if (has('python') || has('python3')) && s:python_ver >= 260
  Bundle 'SirVer/ultisnips'
else
  Bundle 'garbas/vim-snipmate'
endif

Bundle 'klen/python-mode'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
"Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

Plugin 'tpope/vim-cucumber'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" from http://c7.se/switching-to-vundle/
let mapleader=","

"color jellybeans

" Highlight current line
set cursorline

" Make tabs as wide as two spaces
set tabstop=2

" Use UTF-8 without BOM
set encoding=utf-8 nobomb

" Allow backspace in insert mode
set backspace=indent,eol,start

" Optimize for fast terminal connections
set ttyfast

" Automatic formatting
autocmd BufWritePre *.rb :%s/\s\+$//e
autocmd BufWritePre *.go :%s/\s\+$//e
autocmd BufWritePre *.yml :%s/\s\+$//e
autocmd BufWritePre *.yaml :%s/\s\+$//e
autocmd BufWritePre *.haml :%s/\s\+$//e
autocmd BufWritePre *.html :%s/\s\+$//e
autocmd BufWritePre *.scss :%s/\s\+$//e
autocmd BufWritePre *.slim :%s/\s\+$//e

" Set tabbing options
autocmd FileType ruby,yaml setlocal expandtab autoindent shiftwidth=2 softtabstop=2

au BufNewFile * set noeol

" NERDTree
nmap <leader>n :NERDTreeToggle<CR>
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg']

