set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/syntastic'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'Shougo/neocomplcache.vim'
Plugin 'ervandew/supertab'
Plugin 'sjl/gundo.vim'
Plugin 'tomtom/tcomment_vim'
Plugin 'ScrollColors'
Plugin 'haskell.vim'
Plugin 'tomasr/molokai'

call vundle#end()
filetype plugin indent on

set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

syntax enable
set background=light

colorscheme molokai


set number
set showmatch

set hlsearch
set smartcase

set errorbells
set visualbell

set shiftwidth=4
set tabstop=4
set expandtab

set cursorline
set nowrap
set ttyfast

set ruler
set undolevels=1000
set backspace=indent,eol,start

set nofoldenable

set wildmenu

set noswapfile

map <C-n> :NERDTreeToggle<CR>
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
map <Leader> <Plug>(easymotion-prefix)

map <Esc><Esc> :w<CR>
nnoremap U :GundoToggle<CR>

let g:neocomplcache_enable_at_startup = 1
