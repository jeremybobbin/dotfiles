setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!

func! ListBins()
	let l:dirs = split(system("list_bins"), "\n")
	call complete(col('.'), l:dirs)
	return ''
endfunc

" Commands
nnoremap <leader>r :make run<CR>
nnoremap <leader>t :make test<CR>
nnoremap <leader>b q:imake run --bin <C-R>=ListBins()<CR>
nnoremap <leader>c :make check<CR>



" Impl Trait
nnoremap <leader>it :read ~/.vim/templates/rs/
nnoremap <leader>i<++> :read ~/.vim/templates/rs/<++><CR>

" Common constructions
inoremap <leader>fn fn <++>(<++>) -> <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
inoremap <leader>fm fn main() {<CR><++><CR>}<Esc>/<++><CR>"_c4l
inoremap <leader>if if <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
inoremap <leader>pfn pub fn <++>(<++>) -> <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l

inoremap <leader>ils if let Some(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
inoremap <leader>ilo if let Ok(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l

inoremap <leader>wls while let Some(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
inoremap <leader>wlo while let Ok(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l

inoremap <leader>lt let <++> = <++><Esc>0/<++><CR>"_c4l
inoremap <leader>lm let mut <++> = <++><Esc>0/<++><CR>"_c4l

inoremap <leader>sc struct <++> {<CR><++>,<CR>}<Esc>/<++><CR>"_c4l
inoremap <leader>psc struct <++> {<CR><++>,<CR>}<Esc>/<++><CR>"_c4l

" Common macros
inoremap <leader>pl println!("<++>", <++>);<Esc>0/<++><CR>"_c4l
inoremap <leader>pv println!("{}", <++>);<Esc>0/<++><CR>"_c4l
inoremap <leader>vec vec![<++>];<Esc>0/<++><CR>"_c4l
inoremap <leader>exp .expect("<++>")<Esc>0/<++><CR>"_c4l

" Import Statements
inoremap <leader>ec extern crate 
inoremap <leader>std use std::{<CR>};<Esc>O

" Nitpicks
inoremap (; ();<Esc>hi
inoremap (. ()<CR>.
inoremap (" ("")<Esc>hi
inoremap <leader>std use std::{<CR>};<Esc>O


" O remaps
onoremap ifd :<c-u>execute "normal! ?^\\s*fn\\s\\+\\w*\\s*\\(<.*>\\)\\=\\s*(.*)\r:nohlsearch\rgn"<cr>





" Vim Surround customization
" let b:surround_111 = "**\r**"
let b:surround_{char2nr('s')} = "(\"\r\")"


