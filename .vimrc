filetype indent plugin on
syntax on

set autoindent
set backspace=indent,eol,start
set confirm
set hidden
set ignorecase
set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab
set mouse=a
set nocompatible
set nostartofline
set notimeout ttimeout ttimeoutlen=500
set number
set pastetoggle=<F11>
set path+=**
set relativenumber
set showcmd
set ttimeoutlen=100
set wildmenu

" Flavorful remappings

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
	

"" Clipboard commands
	nnoremap <C-p> :r !xclip -selection c -o -<CR><CR>
	vnoremap <C-y> :w !xclip -selection c<CR><CR>


" Vim
	autocmd FileType vim inoremap <C-_>ck <C-_<Esc>a><Esc>
	autocmd FileType vim inoremap <C-_>es <Esc<Esc>a><Esc>
	autocmd FileType vim inoremap <C-_>st <Space<Esc>a><Esc>
	autocmd FileType vim inoremap <C-_>cr <CR<Esc>a>
	autocmd FileType vim inoremap <C-_>jmp <Esc<Esc>a>/<++><CR<Esc>a>"_c4l

" Bash
	autocmd FileType sh map <C-_>a oalias <++>='<++>'<Space>

	autocmd FileType sh nnoremap <C-_>r :!clear && %:p 


" Rust
	autocmd BufRead *.rs :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
	autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!

	" Templates
	
	" autocmd FileType rust imap <++> <++><+<++>+><++>
	autocmd FileType rust inoremap {<CR> {<CR>}<Esc>O
	autocmd FileType rust nnoremap <C-_>it :read ~/.vim/templates/rs/
		" autocmd FileType rust nnoremap <C-_>i<++> :read ~/.vim/templates/rs/<++><CR>

	" Common constructions
	autocmd FileType rust inoremap <C-_>fn fn <++>(<++>) -> <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
	autocmd FileType rust inoremap <C-_>if if <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l

	autocmd FileType rust inoremap <C-_>ils if let Some(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
	autocmd FileType rust inoremap <C-_>ilo if let Ok(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l

	autocmd FileType rust inoremap <C-_>wls while let Some(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
	autocmd FileType rust inoremap <C-_>wlo while let Ok(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l

	autocmd FileType rust inoremap <C-_>let let <++> = <++>;<Esc>0/<++><CR>"_c4l
	autocmd FileType rust inoremap <C-_>mut let mut <++> = <++>;<Esc>0/<++><CR>"_c4l

	" Common macros
	autocmd FileType rust inoremap <C-_>pl println!("<++>", <++>);<Esc>0/<++><CR>"_c4l
	autocmd FileType rust inoremap <C-_>pv println!("{}", <++>);<Esc>0/<++><CR>"_c4l
	autocmd FileType rust inoremap <C-_>vec vec![<++>];<Esc>0/<++><CR>"_c4l
	
	" Commands
	autocmd FileType rust nnoremap <C-_>r :!clear && cargo run<CR>
	autocmd FileType rust inoremap <C-_>r <Esc>:!clear && cargo run<CR>

	autocmd FileType rust nnoremap <C-_>t :!clear && cargo test<CR>
	autocmd FileType rust inoremap <C-_>t <Esc>:!clear && cargo test<CR>

	autocmd FileType rust nnoremap <C-_>b :!clear && cargo bench<CR>
	autocmd FileType rust inoremap <C-_>b <Esc>:!clear && cargo bench<CR>

	autocmd FileType rust nnoremap <C-_>c :!clear && cargo check<CR>
	autocmd FileType rust inoremap <C-_>c <Esc>:!clear && cargo check<CR>
