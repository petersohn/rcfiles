" Generic Editor Configs
set nocompatible
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

set title
if match($TERM, "^screen") == 0
  set t_ts=k
  set t_fs=\
endif
set titlestring=%t%m\ -\ VIM

let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

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
Plugin                'BufOnly.vim'
Plugin        'ciaranm/detectindent'
Plugin           'bkad/CamelCaseMotion'
Plugin        'bbchung/clighter'
"Plugin      'petersohn/clighter'
Plugin         'vim-jp/cpp-vim'
Plugin       'ctrlpvim/ctrlp.vim'
Plugin          'rhysd/committia.vim'
Plugin            'sjl/gundo.vim'
Plugin        'itchyny/lightline.vim'
Plugin      'tmhedberg/matchit'
Plugin     'scrooloose/nerdcommenter'
Plugin     'scrooloose/nerdtree'
Plugin        'Xuyuanp/nerdtree-git-plugin'
Plugin        'eapache/rainbow_parentheses.vim'
Plugin         'jaxbot/semantic-highlight.vim'
Plugin     'scrooloose/syntastic'
Plugin        'solarnz/thrift.vim'
Plugin           'moll/vim-bbye'
Plugin    'ConradIrwin/vim-bracketed-paste'
Plugin          'rhysd/vim-clang-format'
Plugin    'altercation/vim-colors-solarized'
Plugin        'martong/vim-compiledb-path'
Plugin        'bronson/vim-crosshairs'
Plugin 'justincampbell/vim-eighties'
Plugin          'tpope/vim-fugitive'
Plugin    'drmikehenry/vim-headerguard'
Plugin          'xolox/vim-misc'
Plugin          'tpope/vim-obsession'
Plugin          'tpope/vim-repeat'
Plugin          'lyuts/vim-rtags'
"Plugin     'petersohn/vim-rtags'
Plugin          'tpope/vim-surround'
Plugin        'bronson/vim-toggle-wrap'
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
autocmd BufEnter * checktime
autocmd CursorHold * checktime
autocmd CursorHoldI * checktime
" Automatically fix whitspace errors in case of C++ files.
autocmd BufWritePost *.hpp,*.cpp :FixWhitespace

autocmd BufNewFile,BufRead *.md   set syntax=markdown


" ---- CommandT ----
let g:CommandTNeverShowDotFiles = 1
set wildignore+=*.o
set wildignore+=*build*
set wildignore+=*lastrun*
"set wildignore+=*test*


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
  if exists("g:this_obsession") && filereadable(g:this_obsession)
    return "S"
  elseif !empty(v:this_session) && filereadable(g:this_session)
    return "[ S ]"
  else
    return "[ X ]"
  endif
endfunction

function! MyModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! MyFilename()
  let fname = expand('%')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
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
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
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
map <Leader>n :NERDTreeFocus<cr>
map <Leader>f :NERDTreeFind<cr>
let g:NERDTreeDirArrows=0
let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeIgnore = ['\.o$', '\.o-.*$']
let g:NERDTreeQuitOnOpen = 1
let g:NERDTreeWinSize = 50


" ---- YankRing ----
let g:yankring_min_element_length = 2
let g:yankring_max_element_length = 4194304 " 4M
let g:yankring_history_dir = "/tmp"
nnoremap <silent> <Leader>p :YRShow<CR>


" ---- a.vim ----
let g:alternateSearchPath="reg:/include/src//,reg:/include/source//,reg:/inc/src//,reg:/inc/source//,reg:/src/include//,reg:/source/include//,reg:/src/inc//,reg:/source/include//,sfr:..,sfr:../..,sfr:../../.."


" ---- clighter ----
let g:clighter_highlight_groups = ['clighterMacroInstantiation', 'clighterStructDecl', 'clighterClassDecl', 'clighterEnumDecl', 'clighterEnumConstantDecl', 'clighterTypeRef', 'clighterDeclRefExprEnum', 'clighterNamespace']
hi link clighterNamespace Constant
let g:clighter_occurrences_mode=1
nmap <silent> <Leader>w :call clighter#Rename()<CR>
hi link clighterMemberRefExprCall clighterMemberRefExprVar
autocmd FileType c,cpp,objc hi clighterMemberRefExprVar term=NONE cterm=NONE ctermfg=187 gui=NONE
autocmd FileType c,cpp,objc hi clighterMacroInstantiation term=NONE cterm=NONE ctermfg=5 gui=NONE
autocmd FileType c,cpp,objc hi clighterNamespace term=NONE cterm=NONE ctermfg=60 gui=NONE
autocmd FileType c,cpp,objc hi link clighterNamespaceRef clighterNamespace


" ---- ctrlp ----
let g:ctrlp_map = '<c-t>'


" ---- detectindent ----
:autocmd BufReadPost * :DetectIndent
:let g:detectindent_preferred_expandtab = 1
:let g:detectindent_preferred_indent = 4


" ---- Gundo ----
nnoremap <F5> :GundoToggle<CR>
let g:gundo_close_on_revert = 1


" ---- Headerguard ----
function! g:HeaderguardName()
  return toupper(substitute(expand('%:gs/[^0-9a-zA-Z_]/_/g'), '\v.*(src|source|include|incl)_', '', ''))
endfunction
let g:headerguard_use_cpp_comments = 1


" ---- rainbow_parentheses ----
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

let g:rbpt_max = 32
let g:rbpt_colorpairs = [
    \ [' 27', 'RoyalBlue3'],
    \ [' 28', 'SeaGreen3'],
    \ [' 93', 'DarkOrchid3'],
    \ ['100', 'firebrick3'],
    \
    \ [' 33', 'RoyalBlue3'],
    \ [' 34', 'SeaGreen3'],
    \ [' 99', 'DarkOrchid3'],
    \ ['142', 'firebrick3'],
    \
    \ [' 39', 'RoyalBlue3'],
    \ [' 40', 'SeaGreen3'],
    \ ['129', 'DarkOrchid3'],
    \ ['178', 'firebrick3'],
    \
    \ [' 45', 'RoyalBlue3'],
    \ [' 48', 'SeaGreen3'],
    \ ['207', 'DarkOrchid3'],
    \ ['220', 'firebrick3']
    \ ]


" ---- vim-crosshairs ----
set cursorline
highlight CursorLine ctermbg=8
highlight ColorColumn ctermbg=8


" ---- vim-eighties ----
let g:eighties_bufname_additional_patterns = ['fugitiveblame']

map <Leader>h :nohl<CR>
map <Leader>H :let @/ = ""<CR>


" ---- vim-rtags ----
noremap <Leader>ro :call rtags#ProjectOpen(expand('%:p'))<CR>

" TMUX compatiblity for
" keys combined with modifiers such as Shift, Control, and Alt.
" See http://www.reddit.com/r/vim/comments/1a29vk/_/c8tze8p
if &term =~ '^screen'
  " Page keys http://sourceforge.net/p/tmux/tmux-code/ci/master/tree/FAQ
  execute "set t_kP=\e[5;*~"
  execute "set t_kN=\e[6;*~"

  " Arrow keys http://unix.stackexchange.com/a/34723
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif


" ---- YouCompleteMe ----
"let g:ycm_server_use_vim_stdout = 1
"let g:ycm_server_log_level = 'debug'
let g:ycm_global_ycm_extra_conf = $HOME.'/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_confirm_extra_conf = 0
let g:ycm_key_list_select_completion = ['<TAB>', '<Down>', '<Enter>']
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


" --------

"(idea from http://blog.sanctum.geek.nz/vim-command-typos/)
if has("user_commands")
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

if !empty(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif

