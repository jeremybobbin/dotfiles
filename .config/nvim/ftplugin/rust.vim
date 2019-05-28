setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
autocmd BufWritePost *.rs :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!

" Commands
nnoremap <leader>r :make run<CR>
nnoremap <leader>t :make test<CR>
nnoremap <leader>b :make run --bin 
nnoremap <leader>c :make check<CR>


" Impl Trait
nnoremap <leader>it :read ~/.vim/templates/rs/
nnoremap <leader>i<++> :read ~/.vim/templates/rs/<++><CR>


" Common constructions
inoremap <leader>fn fn <++>(<++>) -> <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
inoremap <leader>fm fn main() {<CR><++><CR>}<Esc>/<++><CR>"_c4l
inoremap <leader>if if <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l

inoremap <leader>ils if let Some(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
inoremap <leader>ilo if let Ok(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l

inoremap <leader>wls while let Some(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
inoremap <leader>wlo while let Ok(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l

"inoremap <leader>let let <++> = <++>;<Esc>0/<++><CR>"_c4l
"inoremap <leader>mut let mut <++> = <++>;<Esc>0/<++><CR>"_c4l
inoreabbrev let let = <++><Esc>6hi
inoreabbrev lm let mut = <++><Esc>6hi


" Common macros
"inoremap <leader>pl println!("<++>", <++>);<Esc>0/<++><CR>"_c4l
"inoremap <leader>pv println!("{}", <++>);<Esc>0/<++><CR>"_c4l
"inoremap <leader>vec vec![<++>];<Esc>0/<++><CR>"_c4l
inoreabbrev pl println!("<++>", <++>);<Esc>23h
inoreabbrev pv println!("{}", <++>);<Esc>21h
inoreabbrev vec vec![<++>];<Esc>11h

" More abbreviations
inoreabbrev ec extern crate
