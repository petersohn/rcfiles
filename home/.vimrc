scriptencoding utf-8

" Generic Editor Configs
" Highlight search results (turn off :nohlsearch)
set number
"set hlsearch
set scrolloff=2
set autoindent
set tabstop=4
set shiftwidth=4
set linebreak
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
" Required to be able to use keypad keys and map missed escape sequences
set esckeys
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
set expandtab
set list
set listchars=tab:»\ 
set history=10000
set mouse=a
set autoread
set noswapfile

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
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

Plugin 'gmarik/Vundle.vim'


Plugin        'nacitar/a.vim'
Plugin    'vim-scripts/bash-support.vim'
Plugin    'jlanzarotta/bufexplorer'
Plugin        'ciaranm/detectindent'
Plugin           'bkad/CamelCaseMotion'
if v:version >= 800
  Plugin        'bbchung/clighter8'
else
  Plugin        'bbchung/clighter'
endif
"Plugin      'petersohn/clighter'
Plugin         'vim-jp/cpp-vim'
Plugin          'rhysd/committia.vim'
Plugin       'junegunn/fzf'
Plugin       'junegunn/fzf.vim'
Plugin            'sjl/gundo.vim'
Plugin        'itchyny/lightline.vim'
Plugin    'vim-scripts/lighttpd-syntax'
Plugin      'tmhedberg/matchit'
Plugin     'scrooloose/nerdtree'
Plugin        'Xuyuanp/nerdtree-git-plugin'
Plugin   'luochen1990/rainbow'
Plugin         'mfukar/robotframework-vim'
Plugin         'jaxbot/semantic-highlight.vim'
Plugin     'scrooloose/syntastic'
Plugin         'tomtom/tcomment_vim'
Plugin        'solarnz/thrift.vim'
Plugin        'maralla/validator.vim'
Plugin           'moll/vim-bbye'
Plugin    'ConradIrwin/vim-bracketed-paste'
Plugin          'rhysd/vim-clang-format'
Plugin 'nickhutchinson/vim-cmake-syntax'
Plugin    'altercation/vim-colors-solarized'
Plugin        'bronson/vim-crosshairs'
Plugin 'justincampbell/vim-eighties'
Plugin          'tpope/vim-fugitive'
Plugin    'drmikehenry/vim-headerguard'
Plugin          'tpope/vim-markdown'
Plugin          'xolox/vim-misc'
Plugin          'tpope/vim-obsession'
Plugin          'tpope/vim-repeat'
Plugin          'lyuts/vim-rtags'
"Plugin     'petersohn/vim-rtags'
Plugin          'tpope/vim-surround'
Plugin   'tmux-plugins/vim-tmux'
Plugin        'bronson/vim-trailing-whitespace'
Plugin        'bronson/vim-visual-star-search'
Plugin    'vim-scripts/YankRing.vim'
Plugin       'Valloric/YouCompleteMe'

call vundle#end()

filetype plugin indent on " required!

" Solarized colorscheme
" http://stackoverflow.com/questions/12774141/strange-changing-background-color-in-vim-solarized
":set t_ut=
let g:solarized_termtrans=1
"let g:solarized_termcolors=256
"let g:solarized_degrade=1
"let g:solarized_contrast="high"
"let g:solarized_visibility="high"
set background=dark
colorscheme solarized
set t_Co=256

" Auto commands
" Check whether a file has been changed by an other process then vim.
augroup vimrc
  autocmd!
  autocmd BufEnter * checktime
  autocmd CursorHold * checktime
  autocmd CursorHoldI * checktime
  " Automatically fix whitspace errors in case of C++ files.
  autocmd BufWritePost *.hpp,*.cpp :FixWhitespace

  autocmd BufNewFile,BufRead *.md   set syntax=markdown
  autocmd FileType xml setlocal foldmethod=syntax
augroup END


" ---- a.vim ----
let g:alternateSearchPath='reg:/include/src//,reg:/include/source//,reg:/inc/src//,reg:/inc/source//,reg:/src/include//,reg:/source/include//,reg:/src/inc//,reg:/source/include//,sfr:..,sfr:../..,sfr:../../..'


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
" }}}


" ---- lightline ----
" {{{
let g:lightline = {
      \ 'colorscheme': 'wombat',
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


" ---- detectindent ----
"  {{{
augroup vimrc_detectindent
  :autocmd BufReadPost * :DetectIndent
augroup_END
:let g:detectindent_preferred_expandtab = 1
:let g:detectindent_preferred_indent = 4
" }}}


" ---- Gundo ----
"  {{{
nnoremap <F5> :GundoToggle<CR>
let g:gundo_close_on_revert = 1
" }}}


" ---- Headerguard ----
"  {{{
function! g:HeaderguardName()
  return toupper(substitute(expand('%:gs/[^0-9a-zA-Z_]/_/g'), '\v.*(src|source|include|incl)_', '', ''))
endfunction
let g:headerguard_use_cpp_comments = 1
" }}}


" ---- lighttpd-syntax ----
autocmd BufNewFile,BufReadPost /etc/lighttpd/*.conf,lighttpd.conf set filetype=lighttpd


" ---- rainbow ----
"  {{{

let g:rainbow_active = 1
let g:rainbow_conf = {
    \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
    \   'ctermfgs': [
    \       '27', '28', '93', '100',
    \       '33', '34', '99', '142',
    \       '39', '40', '129', '178',
    \       '45', '48', '207', '220'],
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


" ---- syntastic ----
"  {{{
let g:syntastic_c_checkers=['ycm']
let g:syntastic_cpp_checkers=['ycm']
let g:syntastic_sh_checkers = []
" let g:syntastic_sh_shellcheck_args = '-x'
let g:syntastic_python_checkers = []
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


" ---- vim-eighties ----
"  {{{
let g:eighties_bufname_additional_patterns = ['fugitiveblame']

map <Leader>h :nohl<CR>
map <Leader>H :let @/ = ""<CR>
" }}}


" ---- vim-markdown ----
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'cpp']


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


" ---- YankRing ----
"  {{{
let g:yankring_min_element_length = 2
let g:yankring_max_element_length = 4194304 " 4M
nnoremap <silent> <Leader>p :YRShow<CR>
" }}}


" ---- YouCompleteMe ----
"  {{{
"let g:ycm_server_use_vim_stdout = 1
"let g:ycm_server_log_level = 'debug'
let g:ycm_global_ycm_extra_conf = $HOME.'/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_select_completion = ['<Down>', '<Enter>']
let g:ycm_auto_trigger = 0
"let g:ycm_semantic_triggers =  {
"  \   'c' : ['->', '.'],
"  \   'objc' : ['->', '.'],
"  \   'perl' : ['->'],
"  \   'php' : ['->', '::'],
"  \   'cs,java,javascript,d,vim,ruby,python,perl6,scala,vb,elixir,go' : ['.'],
"  \   'lua' : ['.', ':'],
"  \   'erlang' : [':'],
"  \ }

map gd :YcmCompleter GoToDefinitionElseDeclaration<CR>
map <Leader>y :YcmDiags<cr>
"map <F4> :YcmCompleter GoToDefinition<CR>
"map <F5> :YcmCompleter GoToDeclaration<CR>
" }}}


" ---- validator ----
"  {{{
let g:validator_python_checkers = ['python', 'flake8']
let g:validator_sh_checkers = ['sh', 'shellcheck']
let validator_sh_shellcheck_args = '-x'
let g:validator_vim_checkers = ['vint']
" }}}


" --------

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

if !empty(glob('~/.vimrc.local'))
  source ~/.vimrc.local
endif

