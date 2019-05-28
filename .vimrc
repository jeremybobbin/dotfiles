call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vinegar'
Plug 'mxw/vim-jsx'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'neovimhaskell/haskell-vim'
call plug#end()

filetype indent plugin on
syntax on


set autoindent
set laststatus=2
"set backspace=indent,eol,start
"set confirm
"set hidden
set ignorecase
"set mouse=a
"set nocompatible
"set nostartofline
"set notimeout ttimeout ttimeoutlen=500
set number
set relativenumber
"set pastetoggle=<F11>
"set path+=**
set showcmd
set tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
"set ttimeoutlen=100
set wildmenu
"set wrap linebreak nolist

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

	" Control - L, C 
	nnoremap <C-L> :nohl<CR><C-L>
	nnoremap <C-C> :close<CR>
	" S launches terminal
	nnoremap S q:iterminal<CR>

" Place holders
	nnoremap  <C-_><C-_> i<++><Esc>
	inoremap  <C-_><C-_> <++>
	vnoremap  <C-_><C-_> "_c<++><Esc>

	"Jump
	nnoremap <Space> 0/<++><CR>"_c4l
	vnoremap <Space> "xd0/<++><CR>v3l"xp

" Terminal Remapping
	" CTRL+i for terminal insert mode
	tnoremap <C-i> <C-w>N
	

"" Clipboard commands - Commented for use with emmet-vim 
	nnoremap <C-_>xp :r !xclip -selection c -o -<CR><CR>
	vnoremap <C-_>xy :w !xclip -selection c<CR><CR>


" Vim

" Bash


augroup ft
	"autocmd!
	"autocmd FileType rust	:source $HOME/.vim/autoload/rust.vim
	"autocmd FileType sh	:source $HOME/.vim/autoload/sh.vim
	"autocmd FileType vim	:source $HOME/.vim/autoload/vim.vim
augroup END
