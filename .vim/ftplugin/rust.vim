autocmd BufRead * :setlocal tags=./rusty-tags.vi;/,$RUST_SRC_PATH/rusty-tags.vi
autocmd BufWritePost * :silent! exec "!rusty-tags vi --quiet --start-dir=" . expand('%:p:h') . "&" | redraw!

" Templates

" autocmd FileType rust imap <++> <++><+<++>+><++>
nnoremap <C-_>it :read ~/.vim/templates/rs/
nnoremap <C-_>i<++> :read ~/.vim/templates/rs/<++><CR>


" Common constructions
inoremap <C-_>fn fn <++>(<++>) -> <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
inoremap <C-_>if if <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l

inoremap <C-_>ils if let Some(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
inoremap <C-_>ilo if let Ok(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l

inoremap <C-_>wls while let Some(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l
inoremap <C-_>wlo while let Ok(<++>) = <++> {<CR><++><CR>}<Esc>/<++><CR>"_c4l

inoremap <C-_>let let <++> = <++>;<Esc>0/<++><CR>"_c4l
inoremap <C-_>mut let mut <++> = <++>;<Esc>0/<++><CR>"_c4l


" Common macros
inoremap <C-_>pl println!("<++>", <++>);<Esc>0/<++><CR>"_c4l
inoremap <C-_>pv println!("{}", <++>);<Esc>0/<++><CR>"_c4l
inoremap <C-_>vec vec![<++>];<Esc>0/<++><CR>"_c4l


" Commands
nnoremap <C-_>r :!clear && cargo run<CR>
inoremap <C-_>r <Esc>:!clear && cargo run<CR>

nnoremap <C-_>t :!clear && cargo test --color=always \|& less -R<CR>
inoremap <C-_>t <Esc>:!clear && cargo test --color=always \|& less -R<CR>

nnoremap <C-_>b :!clear && cargo bench --color=always \|& less -R<CR>
inoremap <C-_>b <Esc>:!clear && cargo bench --color=always \|& less -R<CR>

nnoremap <C-_>c :!clear && cargo check --color=always \|& less -R<CR>
inoremap <C-_>c <Esc>:!clear && cargo check --color=always \|& less -R<CR>
