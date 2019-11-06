call plug#begin('~/.config/vim/plugged')
Plug 'chrisbra/csv.vim'
Plug 'elzr/vim-json'
Plug 'mxw/vim-jsx'
Plug 'neovimhaskell/haskell-vim'
Plug 'pangloss/vim-javascript'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
call plug#end()

let mapleader = ""
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:lisp_rainbow = 1


filetype indent plugin on
syntax on

let g:mainruntimepath = $HOME . "/.vim"

colorscheme delek
set autoindent
set laststatus=2
set confirm
set ignorecase
set notimeout ttimeout ttimeoutlen=10
set number
set relativenumber
set nohlsearch
set showcmd
set wildmenu

" General remaps
nnoremap Y y$

" Command Window
nnoremap : q:i
au CmdwinEnter [:>] nnoremap : :q<CR>
au CmdwinLeave [:>] nnoremap : q:i

au CmdwinEnter [:>] nnoremap <Esc> :q<CR>
au CmdwinLeave [:>] nnoremap <Esc> <Esc> 



" Source Vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>

" Place holders
inoremap  <leader><leader> <++>
nnoremap  <leader><leader> i<++><Esc>
vnoremap  <leader><leader> "_c<++><Esc>

nnoremap <Space> /<++><CR>"_c4l
vnoremap <Space> "xd0/<++><CR>v3l"xp

" Terminal
nnoremap <M-t> :vsplit term://bash<CR>
tnoremap <M-n> <C-\><C-N>

"autocmd BufNewFile *.sh,~/.local/bin/* r ~/.config/nvim/templates/sh/skeleton.sh
