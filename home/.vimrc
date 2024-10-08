scriptencoding utf-8

" Generic Editor Configs
" Highlight search results (turn off :nohlsearch)
set number
"set hlsearch
set scrolloff=2
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab
set nolinebreak
" Enable syntax highlighting
syntax on
" Select case-insenitiv search (not default)
"set ignorecase
" Show cursor line and column in the status line
set ruler
" Show matching brackets
set showmatch
" Changes special characters in search patterns (default)
"set magic
"set timeoutlen=1000 ttimeoutlen=10
" make backspace work like most other apps
set backspace=2
" margin
set colorcolumn=81
" Control the position of the new window
set splitbelow
set splitright
" Allow hiding an unsaved buffer
set hidden
set hlsearch
set incsearch
set foldmethod=marker
set list
set listchars=tab:»\ ,eol:⏎
set history=10000
set mouse=a
set autoread
set noswapfile
set updatetime=500
set exrc
set ignorecase
set smartcase

function s:SourceIfAvailable(filename)
  if filereadable(a:filename)
    exec "source " . a:filename
  endif
endfunction

set title
if match($TERM, '^screen') == 0
  set t_ts=k
  set t_fs=\
endif
set titlestring=%t%m\ -\ VIM

let g:xml_syntax_folding=1

set t_Co=256
":let mapleader = " "


let g:vundle_default_git_proto = 'git'


" Vundle stuff
filetype off " required!
call plug#begin()

let plugins_file = $HOME . "/.vim/plugins.vim"
let plugins_local_file = $HOME . "/.vim/plugins.local.vim"

call s:SourceIfAvailable(plugins_file)
call s:SourceIfAvailable(plugins_local_file)

call plug#end()

filetype plugin indent on " required!

" Solarized colorscheme
" http://stackoverflow.com/questions/12774141/strange-changing-background-color-in-vim-solarized
":set t_ut=
" let g:solarized_termtrans=1
" let g:solarized_termcolors=256
" let g:solarized_degrade=1
" let g:solarized_contrast="high"
" let g:solarized_visibility="high"
" set termguicolors
set background=dark
" colorscheme solarized
"
let g:edge_style = 'neon'
let g:edge_disable_italic_comment = 1
set t_Co=256
colorscheme selenized
hi Search ctermbg=240
hi MatchParen ctermbg=240

" Auto commands
augroup vimrc
  autocmd!
" Check whether a file has been changed by an other process then vim.
  autocmd BufEnter * checktime
  autocmd CursorHold * checktime
  autocmd CursorHoldI * checktime

  " Automatically fix whitspace errors in case of C++ files.
  " autocmd BufWritePost *.hpp,*.cpp :FixWhitespace

  autocmd BufNewFile,BufRead *.md   set syntax=markdown
  autocmd FileType xml setlocal foldmethod=syntax
  autocmd FileType cmake RainbowToggleOff
  autocmd FileType qf wincmd J
  autocmd FileType text set formatoptions-=tc
  autocmd FileType c,cpp set formatoptions+=j
augroup END

" ---- termdebug ----
packadd termdebug
let g:termdebug_wide = 1
nnoremap <silent> <F12> :Run<CR>
nnoremap <silent> g<F12> :Stop<CR>
nnoremap <silent> <F10> :Over<CR>
nnoremap <silent> g<F10> :Step<CR>
nnoremap <silent> <F9> :Continue<CR>
nnoremap <silent> g<F9> :Finish<CR>
nnoremap <silent> <F8> :Break<CR>
if v:version >= 801
  nnoremap <silent> g<F8> :Clear<CR>
else
  nnoremap <silent> g<F8> :Delete<CR>
endif

" ---- Maximize window ----
nnoremap <C-W>O :call MaximizeToggle()<CR>
nnoremap <C-W>o :call MaximizeToggle()<CR>
nnoremap <C-W><C-O> :call MaximizeToggle()<CR>

function! MaximizeToggle()
  if exists("s:maximize_session")
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    tabonly
    only
  endif
endfunction

" ---- a.vim ----
let g:alternateSearchPath='reg:/include/src//,reg:/include/source//,reg:/inc/src//,reg:/inc/source//,reg:/src/include//,reg:/source/include//,reg:/src/inc//,reg:/source/include//,sfr:..,sfr:../..,sfr:../../..'

" ---- AsyncRun ----
let g:asyncrun_bell = 1
let g:asyncrun_exit = "silent call system(\"notify-send \\\"vim asyncrun\\\" \\\"Returned \" . g:asyncrun_code . \" (\" . g:asyncrun_status . \")\\\"\")"
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
augroup asyncrun
  autocmd User AsyncRunStart call asyncrun#quickfix_toggle(5, 1)
  autocmd User AsyncRunStop if (g:asyncrun_code == 0) | call asyncrun#quickfix_toggle(5, 0) | endif
augroup END
nnoremap <silent> <F6> :call asyncrun#quickfix_toggle(15)<CR>

" ---- CamelCaseMotion ----
call camelcasemotion#CreateMotionMappings(',')


" ---- CommandT ----
"  {{{
let g:CommandTNeverShowDotFiles = 1
set wildignore+=*.o
set wildignore+=*build*
set wildignore+=*lastrun*
"set wildignore+=*test*
" }}}


" ---- Fzf ----
" {{{
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit' }

let $FZF_DEFAULT_COMMAND = 'fd --hidden'

let s:ag_options = ' --hidden --ignore .git '
command! -bang -nargs=* Ag
      \ call fzf#vim#ag(
      \   <q-args>,
      \   s:ag_options,
      \  <bang>0 ? fzf#vim#with_preview('up:60%')
      \        : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0
      \ )

command! -bang -nargs=* Agw
      \ call fzf#vim#ag(
      \   <q-args>,
      \   s:ag_options . ' --word-regexp ',
      \  <bang>0 ? fzf#vim#with_preview('up:60%')
      \        : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0
      \ )

command! -bang -nargs=* Ags
      \ call fzf#vim#ag(
      \   <q-args>,
      \   s:ag_options . ' --case-sensitive ',
      \  <bang>0 ? fzf#vim#with_preview('up:60%')
      \        : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0
      \ )

command! -bang -nargs=* Agsw
      \ call fzf#vim#ag(
      \   <q-args>,
      \   s:ag_options . ' --case-sensitive --word-regexp ',
      \  <bang>0 ? fzf#vim#with_preview('up:60%')
      \        : fzf#vim#with_preview('right:50%:hidden', '?'),
      \   <bang>0
      \ )
" }}}


" ---- lightline ----
" {{{
let g:lightline = {
      \ 'colorscheme': 'edge',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'], ['obsession'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \   'ctrlpmark': 'CtrlPMark',
      \   'obsession': 'MyObsession'
      \ }
      \ }

function! MyObsession()
  if exists('g:this_obsession') && filereadable(g:this_obsession)
    return 'S'
  elseif !empty(v:this_session) && filereadable(g:this_session)
    return '[ S ]'
  else
    return '[ X ]'
  endif
endfunction

function! MyModified()
  return &ft =~# 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname ==# 'ControlP' ? g:lightline.ctrlp_item :
        \ fname ==# '__Tagbar__' ? g:lightline.fname :
        \ fname =~# '__Gundo\|NERD_tree' ? '' :
        \ &ft ==# 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft ==# 'unite' ? unite#get_status_string() :
        \ &ft ==# 'vimshell' ? vimshell#get_status_string() :
        \ ('' !=# MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' !=# fname ? fname : '[No Name]') .
        \ ('' !=# MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ': '  " edit here for cool mark
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname ==# '__Tagbar__' ? 'Tagbar' :
        \ fname ==# 'ControlP' ? 'CtrlP' :
        \ fname ==# '__Gundo__' ? 'Gundo' :
        \ fname ==# '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~# 'NERD_tree' ? 'NERDTree' :
        \ &ft ==# 'unite' ? 'Unite' :
        \ &ft ==# 'vimfiler' ? 'VimFiler' :
        \ &ft ==# 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~# 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
" }}}


" ---- NERDTree ----
"  {{{
map <Leader>n :NERDTreeFocus<cr>
map <Leader>f :NERDTreeFind<cr>
let g:NERDTreeDirArrows=0
let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeIgnore = ['\.o$', '\.o-.*$', '\.pyc$', '^\..*\.sw.$', '^\.git$']
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeWinSize = 50
let g:NERDTreeAutoDeleteBuffer = 1
let g:NERDTreeCustomOpenArgs={'file':{'reuse':'currenttab'}}
" }}}


" ---- clighter ----
"  {{{

if v:version >= 800
  if $LIBCLANG_PATH !=# ''
    let g:clighter8_libclang_path = $LIBCLANG_PATH
  endif

  let g:clighter8_highlight_whitelist = ['clighter8MacroInstantiation', 'clighter8StructDecl', 'clighter8ClassDecl', 'clighter8EnumDecl', 'clighter8EnumConstantDecl', 'clighter8TypeRef', 'clighter8DeclRefExpr', 'clighter8Namespace', 'clighter8NamespaceRef', 'clighter8MemberRefExpr', 'clighter8VarDecl']
  augroup vimrc
    autocmd FileType c,cpp,objc hi clighter8MemberRefExpr term=NONE cterm=NONE ctermfg=187 gui=NONE
    autocmd FileType c,cpp,objc hi clighter8DeclRefExpr term=NONE cterm=NONE ctermfg=73 gui=NONE
    autocmd FileType c,cpp,objc hi clighter8VarDecl term=NONE cterm=NONE ctermfg=37 gui=NONE
    autocmd FileType c,cpp,objc hi clighter8MacroInstantiation term=NONE cterm=NONE ctermfg=5 gui=NONE
    autocmd FileType c,cpp,objc hi clighter8Namespace term=NONE cterm=NONE ctermfg=60 gui=NONE
    autocmd FileType c,cpp,objc hi link clighter8NamespaceRef clighter8Namespace
    autocmd FileType c,cpp,objc hi clighter8TemplateTypeParameter term=NONE cterm=NONE ctermfg=59 gui=NONE
    autocmd FileType c,cpp,objc hi clighter8TemplateRef term=NONE cterm=NONE ctermfg=102 gui=NONE
  augroup END
else
  let g:clighter_highlight_groups = ['clighterMacroInstantiation', 'clighterStructDecl', 'clighterClassDecl', 'clighterEnumDecl', 'clighterEnumConstantDecl', 'clighterTypeRef', 'clighterDeclRefExprEnum', 'clighterNamespace']
  let g:clighter_occurrences_mode=1
  hi link clighterMemberRefExprCall clighterMemberRefExprVar
  augroup vimrc
    autocmd FileType c,cpp,objc hi clighterMemberRefExprVar term=NONE cterm=NONE ctermfg=187 gui=NONE
    autocmd FileType c,cpp,objc hi clighterMacroInstantiation term=NONE cterm=NONE ctermfg=5 gui=NONE
    autocmd FileType c,cpp,objc hi clighterNamespace term=NONE cterm=NONE ctermfg=60 gui=NONE
    autocmd FileType c,cpp,objc hi link clighterNamespaceRef clighterNamespace
  augroup END
endif
" }}}

" ---- Gundo ----
"  {{{
nnoremap <F5> :GundoToggle<CR>
let g:gundo_close_on_revert = 1
let g:gundo_prefer_python3 = 1
" }}}


" ---- Headerguard ----
"  {{{
function! g:HeaderguardName()
  return toupper(substitute(expand('%:gs/[^0-9a-zA-Z_]/_/g'), '\v.*(src|source|include|incl)_', '', ''))
endfunction
let g:headerguard_use_cpp_comments = 1
" }}}


" ---- lighttpd-syntax ----
" {{{
autocmd BufNewFile,BufReadPost /etc/lighttpd/*.conf,lighttpd.conf set filetype=lighttpd
" }}}

if !has('nvim')
" {{{ coc

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#insert()
    \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <c-@> coc#refresh()

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" }}}
endif

" ---- rainbow ----
"  {{{

let g:rainbow_active = 1
let g:rainbow_conf = {
    \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
    \   'ctermfgs': [
    \       '9', '10', '11', '12', '13', '14'],
    \   'operators': '_,_',
    \   'parentheses': [
    \       'start=/(/ end=/)/ fold',
    \       'start=/\[/ end=/\]/ fold',
    \       'start=/{/ end=/}/ fold'],
    \   'separately': {
    \       '*': {},
    \       'tex': {
    \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
    \       },
    \       'lisp': {
    \           'guifgs': [
    \               'royalblue3', 'darkorange3',
    \               'seagreen3', 'firebrick', 'darkorchid3'],
    \       },
    \       'vim': {
    \           'parentheses': [
    \               'start=/(/ end=/)/',
    \               'start=/\[/ end=/\]/',
    \               'start=/{/ end=/}/ fold',
    \               'start=/(/ end=/)/ containedin=vimFuncBody',
    \               'start=/\[/ end=/\]/ containedin=vimFuncBody',
    \               'start=/{/ end=/}/ fold containedin=vimFuncBody'],
    \       },
    \       'html': {
    \           'parentheses': [
    \               'start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
    \       },
    \       'css': 0,
    \   }
    \}
" }}}


" ---- semantic-highlight ----
"  {{{
:nnoremap <Leader>s :SemanticHighlightToggle<cr>
let g:semanticTermColors = [27, 28, 93, 100, 33, 34, 99, 142, 39, 40, 129, 178, 45, 48, 207, 220]
" }}}

" ---- tabman ----
"  {{{
let g:tabman_specials = 1
let g:tabman_width = 50
" }}}


" ---- syntastic ----
"  {{{
let g:syntastic_c_checkers=['ycm']
let g:syntastic_cpp_checkers=['ycm']
let g:syntastic_sh_checkers = []
" let g:syntastic_sh_shellcheck_args = '-x'
let g:syntastic_python_checkers = []
let g:syntastic_xml_checkers = []
let g:syntastic_enable_balloons = 0
let g:syntastic_enable_highlighting = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
" }}}


" ---- vim-crosshairs ----
"  {{{
set cursorline
highlight CursorLine ctermbg=8
highlight ColorColumn ctermbg=8
" }}}

" ---- vim-easyclip ----
"  {{{
" let g:EasyClipUseSubstituteDefaults = 0
" nmap <silent> S <plug>SubstituteOverMotionMap
" nmap <silent> SS <plug>SubstituteLine
" xmap <silent> S <plug>XEasyClipPaste
" let g:EasyClipShareYanks = 1
" let g:EasyClipCopyExplicitRegisterToDefault = 1
" let g:EasyClipShareYanksDirectory = "/tmp"
" let g:EasyClipEnableBlackHoleRedirect = 0
" let g:EasyClipUseCutDefaults = 0
" let g:EasyClipUsePasteToggleDefaults = 0 " TODO: Enable it when fixed
" let g:EasyClipYankHistorySize = 10
" }}}

" ---- vim-eighties ----
"  {{{
let g:eighties_bufname_additional_patterns = ['fugitiveblame']

map <Leader>h :nohl<CR>
map <Leader>H :let @/ = ""<CR>
" }}}


" ---- vim-markdown ----
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'cpp', 'c++=cpp']

" ---- vim-rtags ----
"  {{{
noremap <Leader>ro :call rtags#ProjectOpen(expand('%:p'))<CR>

" TMUX compatiblity for
" keys combined with modifiers such as Shift, Control, and Alt.
" See http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
if &term =~# '^screen'
  " Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
  execute "set t_kP=\e[5;*~"
  execute "set t_kN=\e[6;*~"

  " Arrow keys http://unix.stackexchange.com/a/34723
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif
" }}}

" ---- validator ----
"  {{{
let g:validator_python_checkers = ['python', 'flake8']
let g:validator_sh_checkers = []
" let g:validator_sh_checkers = ['sh', 'shellcheck']
let validator_sh_shellcheck_args = '-x -f gcc'
let g:validator_vim_checkers = ['vint']
let g:validator_c_checkers = []
let g:validator_cpp_checkers = []
let g:validator_xml_checkers = []
let g:validator_perl_checkers = []
" }}}


" --------

" nnoremap m ge
" nnoremap M gE

"(idea from http://blog.sanctum.geek.nz/vim-command-typos/)
if has('user_commands')
  command! -bang -nargs=? -complete=file W w<bang> <args>
  command! -bang -nargs=? -complete=file Wq wq<bang> <args>
  command! -bang -nargs=? -complete=file WQ wq<bang> <args>
  command! -bang Wa wa<bang>
  command! -bang WA wa<bang>
  command! -bang Q q<bang>
  command! -bang Qa qa<bang>
  command! -bang QA qa<bang>
  "TODO X is reserved for encryption
  command! -bang Xa xa<bang>
  command! -bang XA xa<bang>
endif

command! Wsudo :execute ':silent w !sudo tee % > /dev/null' | :edit!
map <F2> :Autoformat<CR>

call s:SourceIfAvailable($HOME . "/.vimrc.local")
