call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'rust-lang/rust.vim'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'neovimhaskell/haskell-vim'
call plug#end()

filetype indent plugin on
syntax on


colorscheme delek
set autoindent
set laststatus=2
"set backspace=indent,eol,start
set confirm
"set hidden
set ignorecase
"set mouse=a
"set nocompatible
"set nostartofline
set notimeout ttimeout ttimeoutlen=10
set number
set relativenumber
set nohlsearch
"set pastetoggle=<F11>
"set path+=**
set showcmd
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
set wildmenu

" General remaps
nnoremap Y y$

" Auto closers
inoremap {<CR> {<CR>}<Esc>O

inoremap (<CR> (<CR>)<Esc>O
inoremap ( ()<Esc>i
inoremap (; ();<Esc>
inoremap (. ().
inoremap () ()

inoremap " ""<Esc>i
inoremap "" ""

" Command Window
nnoremap : q:i
au CmdwinEnter [:>] nnoremap : :q<CR>
au CmdwinLeave [:>] nnoremap : q:i

au CmdwinEnter [:>] nnoremap <Esc> :q<CR>
au CmdwinLeave [:>] nnoremap <Esc> <Esc> 


let mapleader = ""

" Source Vim
nnoremap <leader>sv :source $MYVIMRC<CR>

" Place holders
inoremap  <leader><leader> <++>
nnoremap  <leader><leader> i<++><Esc>
inoremap  <leader><leader> <++>
vnoremap  <leader><leader> "_c<++><Esc>

nnoremap <Space> 0/<++><CR>"_c4l
vnoremap <Space> "xd0/<++><CR>v3l"xp

" Terminal
nnoremap <M-t> :vert terminal<CR>

" Window
nnoremap <C-c> <C-W><C-c>

inoremap <M-j> <C-W><C-W>
nnoremap <M-j> <C-W><C-W>
vnoremap <M-j> <C-W><C-W>
tnoremap <M-j> <C-\><C-N><C-W><C-W>

inoremap <M-k> <C-W>W
nnoremap <M-k> <C-W>W
vnoremap <M-k> <C-W>W
tnoremap <M-k> <C-\><C-N><C-W>W


nnoremap <M-o> :copen<CR>
nnoremap <M-n> :cnext<CR>
nnoremap <M-p> :cprev<CR>

