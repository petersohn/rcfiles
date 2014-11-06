" Custom mappings
" Moving lines up and down
"map <A-Down> :m .+1<CR>==
"map <A-Up> :m .-2<CR>==
" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d
" chang editor mode
nnoremap <C-S> i
inoremap <C-S> <ESC>l
vnoremap <C-S> <ESC>l

map <silent> <Leader>h :nohl<CR>
map <silent> <Leader>H :let @/ = ""<CR>
map <Leader>[ :cp<CR>
map <Leader>] :cn<CR>
nmap <silent> <Leader>g :vimgrep // **/*.[ch]*<CR>
nnoremap <C-j> ddp
nnoremap <C-k> ddkkp
map <C-Down> <C-j>
map <C-Up> <C-k>
nmap Y y$


