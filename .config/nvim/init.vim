call plug#begin('~/.config/nvim/plugged')
Plug 'aurieh/discord.nvim'
Plug 'chrisbra/csv.vim'
Plug 'elzr/vim-json'
Plug 'mattn/emmet-vim'
Plug 'mxw/vim-jsx'
Plug 'neovimhaskell/haskell-vim'
Plug 'pangloss/vim-javascript'
Plug 'racer-rust/vim-racer'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
call plug#end()

let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'

filetype indent plugin on
syntax on

if isdirectory($HOME . "/.vim")
	let g:mainruntimepath = $HOME . "/.vim"
elseif isdirectory(s:red)
	let g:mainruntimepath = $XDG_CONFIG_HOME . "nvim"
else
	echoerr "No main runtime path"
endif

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



" Command Window
nnoremap : q:i
au CmdwinEnter [:>] nnoremap : :q<CR>
au CmdwinLeave [:>] nnoremap : q:i

au CmdwinEnter [:>] nnoremap <Esc> :q<CR>
au CmdwinLeave [:>] nnoremap <Esc> <Esc> 


let mapleader = ""


" Source Vimrc
nnoremap <leader>sv :source $MYVIMRC<CR>

" Place holders
inoremap  <leader><leader> <++>
nnoremap  <leader><leader> i<++><Esc>
vnoremap  <leader><leader> "_c<++><Esc>

nnoremap <Space> /<++><CR>"_c4l
vnoremap <Space> "xd0/<++><CR>v3l"xp

" Terminal
nnoremap <M-t> :vsplit terminal<CR>

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

" OMAP (asdfjkl)
" Inner Next
onoremap in( :<c-u>:execute "normal! /(\rvi("<CR>
onoremap in[ :<c-u>:execute "normal! /[\rvi["<CR>
onoremap in{ :<c-u>:execute "normal! /{\rvi{"<CR>
onoremap in" :<c-u>:execute "normal! /"\rvi""<CR>
onoremap in' :<c-u>:execute "normal! /'\rvi'"<CR>
onoremap in` :<c-u>:execute "normal! /`\rvi`"<CR>
" Inner Previous
onoremap iN( :<c-u>:execute "normal! ?)\rvi("<CR>
onoremap iN[ :<c-u>:execute "normal! ?[\rvi["<CR>
onoremap iN{ :<c-u>:execute "normal! ?}\rvi{"<CR>
onoremap iN" :<c-u>:execute "normal! ?"\rvi""<CR>
onoremap iN' :<c-u>:execute "normal! ?'\rvi'"<CR>
onoremap iN` :<c-u>:execute "normal! ?`\rvi`"<CR>
" Around Next
onoremap an( :<c-u>:execute "normal! /(\rva("<CR>
onoremap an[ :<c-u>:execute "normal! /[\rva["<CR>
onoremap an{ :<c-u>:execute "normal! /{\rva{"<CR>
onoremap an" :<c-u>:execute "normal! /"\rva""<CR>
onoremap an' :<c-u>:execute "normal! /'\rva'"<CR>
onoremap an` :<c-u>:execute "normal! /`\rva`"<CR>
" Arround Previous
onoremap aN( :<c-u>:execute "normal! ?)\rva("<CR>
onoremap aN[ :<c-u>:execute "normal! ?[\rva["<CR>
onoremap aN{ :<c-u>:execute "normal! ?}\rva{"<CR>
onoremap aN" :<c-u>:execute "normal! ?"\rva""<CR>
onoremap aN' :<c-u>:execute "normal! ?'\rva'"<CR>
onoremap aN` :<c-u>:execute "normal! ?`\rva`"<CR>

" Visual equivalent
vnoremap in( :<c-u>:execute "normal! /(.*)\rvi("<CR>
