call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
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


" Flavorful remappings
nnoremap Y y$

" Auto closers
inoremap {<CR> {<CR>}<Esc>O
inoremap (<CR> (<CR>)<Esc>O

" Command Window
nnoremap : q:i
au CmdwinEnter [:>] nnoremap : :q<CR>
au CmdwinLeave [:>] nnoremap : q:i

au CmdwinEnter [:>] nnoremap <Esc> :q<CR>
au CmdwinLeave [:>] nnoremap <Esc> <Esc> 


let mapleader = ""

" Place holders
inoremap  <leader><C-_> <++>
nnoremap  <leader><leader> i<++><Esc>
inoremap  <leader><C-_> <++>
vnoremap  <C-_><C-_> "_c<++><Esc>

nnoremap <Space> 0/<++><CR>"_c4l
vnoremap <Space> "xd0/<++><CR>v3l"xp

"" Clipboard commands - Commented for use with emmet-vim 
nnoremap <C-_>xp :r !xclip -selection c -o -<CR><CR>
vnoremap <C-_>xy :w !xclip -selection c<CR><CR>

" Terminal
nnoremap <leader>t :vert terminal bash<CR>

" Windowctl
inoremap <M-j> <C-W>j
nnoremap <M-j> <C-W>j
vnoremap <M-j> <C-W>j
tnoremap <M-j> <C-\><C-N>j

inoremap <M-k> <C-W>k
nnoremap <M-k> <C-W>k
vnoremap <M-k> <C-W>k
tnoremap <M-k> <C-\><C-N>k

inoremap <M-h> <C-W>h
nnoremap <M-h> <C-W>h
vnoremap <M-h> <C-W>h
tnoremap <M-h> <C-\><C-N>h

inoremap <M-l> <C-W>l
nnoremap <M-l> <C-W>l
vnoremap <M-l> <C-W>l
tnoremap <M-l> <C-\><C-N>l

inoremap <M-n> <C-W><C-W>
nnoremap <M-n> <C-W><C-W>
vnoremap <M-n> <C-W><C-W>
tnoremap <M-n> <C-\><C-N><C-W><C-W>

inoremap <M-p> <C-W>W
nnoremap <M-p> <C-W>W
vnoremap <M-p> <C-W>W
tnoremap <M-p> <C-\><C-N><C-W>W
