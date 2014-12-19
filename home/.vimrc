" Generic Editor Configs
set number
" Highlight search results (turn off :nohlsearch)
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
set nocompatible
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

let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

":let mapleader = " "

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


" Vundle stuff
filetype off " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Plugin 'gmarik/vundle'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'bling/vim-airline'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'BufOnly.vim'
Plugin 'headerguard'
Plugin 'Valloric/YouCompleteMe'
Plugin 'sjbach/lusty'
Plugin 'moll/vim-bbye'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session'
Plugin 'vim-jp/cpp-vim'
Plugin 'bkad/CamelCaseMotion'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/YankRing.vim'
Plugin 'vim-scripts/TeTrIs.vim'
Plugin 'vim-scripts/a.vim'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'ConradIrwin/vim-bracketed-paste'
Plugin 'tmhedberg/matchit'
Plugin 'ciaranm/detectindent'
" IDE stuff in a separate file
"if $VIMIDE == "ide"
	"source ~/.vimrc.ide
	"echo "VIMIDE"
"endif
filetype plugin indent on " required!

" Pathogen
execute pathogen#infect()

" Auto commands
" Check whether a file has been changed by an other process then vim.
autocmd BufEnter * checktime
autocmd CursorHold * checktime
autocmd CursorHoldI * checktime
" Automatically fix whitspace errors in case of C++ files.
autocmd BufWritePost *.hpp,*.cpp :FixWhitespace

autocmd BufNewFile,BufRead *.md   set syntax=markdown

let g:nerdtree_tabs_open_on_console_startup = 1

" Airline config
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set laststatus=2
let g:airline_theme="kalisi"

" NERDTree config
map <Leader>n :NERDTreeFocus<cr>
map <Leader>f :NERDTreeFind<cr>
let g:NERDTreeDirArrows=0
let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeIgnore = ['\.o$', '\.o-.*$']

" CommandT config
let g:CommandTNeverShowDotFiles = 1
set wildignore+=*.o
set wildignore+=*build*
set wildignore+=*lastrun*
"set wildignore+=*test*


" Taglist config
let Tlist_Show_One_File = 1

" YankRing
let g:yankring_min_element_length = 2
let g:yankring_max_element_length = 4194304 " 4M
let g:yankring_history_dir = "/tmp"
nnoremap <silent> <Leader>p :YRShow<CR>

" a.vim
let g:alternateSearchPath="reg:/include/src//,reg:/include/source//,reg:/inc/src//,reg:/inc/source//,reg:/src/include//,reg:/source/include//,reg:/src/inc//,reg:/source/include//,sfr:..,sfr:../..,sfr:../../.."

" Headerguard
function! g:HeaderguardName()
	return toupper(expand('%:gs/[^0-9a-zA-Z_]/_/g'))
endfunction


" YouCompleteMe
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


" Lusty Juggler
let g:LustyJugglerAltTabMode = 1
noremap <silent> <C-E> :LustyJuggler<CR>


" vim-session
:let g:session_autosave = 'no'
:let g:session_autoload = 'no'


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

" detectindent
:autocmd BufReadPost * :DetectIndent
:let g:detectindent_preferred_expandtab = 0
:let g:detectindent_preferred_indent = 4

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


