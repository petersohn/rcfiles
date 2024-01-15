source_if_available() {
  if [ -e "$1" ]; then
    source "$1"
  fi
}

setopt histignorespace

NO_GITSTATUS=

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to  shown in the command execution time stamp
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
HIST_STAMPS="yyyy-mm-dd"

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=240,bold'

export MANPATH="$(manpath):$HOME/usr/share/man"
export PATH="$HOME/bin:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/usr/bin:$HOME/.fzf/bin:$PATH:/opt/homebrew/bin"

if [ -f "/opt/homebrew/bin/brew" ]
then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -d "/opt/homebrew/opt/llvm/bin" ]
then
    export PATH="/opt/homebrew/opt/llvm/bin:${PATH}"
fi

if [ -d "/opt/homebrew/opt/qt@5/bin" ]
then
    export PATH="/opt/homebrew/opt/qt@5/bin:${PATH}"
fi

if [ -d "/opt/homebrew/opt/coreutils/libexec/gnubin" ]
then
    export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:${PATH}"
fi

fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

source $HOME/.zsh/antigen/antigen.zsh

antigen use oh-my-zsh

antigen bundle git
antigen bundle docker
antigen bundle screen
antigen bundle dircycle
antigen bundle mosh
antigen bundle vundle
antigen bundle jump
antigen bundle pip
antigen bundle sudo
antigen bundle zsh-users/zsh-completions
antigen bundle history-substring-search
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle supercrabtree/k
antigen bundle petersohn/zsh-comp-gsettings

antigen theme petersohn/zsh-theme themes/zsh-theme

source_if_available "$HOME/.antigen.local"

antigen apply

autoload -U compinit
compinit

PER_DIRECTORY_HISTORY_DEFAULT_GLOBAL_HISTORY=true

# Make solarized colors applied for directories as well (ls).
# eval $(dircolors --sh ~/dircolors-solarized/dircolors.ansi-universal)

function git-cd() {
  local git_dir
  git_dir=$(git rev-parse --show-toplevel)
  local result=$?
  if [[ $result != 0 ]]; then
    return $result
  fi
  cd "$git_dir/$1"
}

function git() {
  if [[ "$1" == cd ]]; then
    shift
    git-cd "$@"
  else
    command git "$@"
  fi
}

function mkcd() {
  mkdir -p "$1" && cd "$1"
}

#  Completion from tmux pane
_tmux_pane_words() {
  local expl
  local -a w
  if [[ -z "$TMUX_PANE" ]]; then
    _message "not running inside tmux!"
    return 1
  fi
  w=( ${(u)=$(tmux capture-pane \; show-buffer \; delete-buffer)} )
  _wanted values expl 'words from current tmux pane' compadd -a w
}

function preexec {
    # Update DISPLAY
    if [ -n "$TMUX" ]; then
        eval $(tmux show-environment -s)
    fi
}

zle -C tmux-pane-words-prefix   complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^Xt' tmux-pane-words-prefix
bindkey '^X^X' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'

# 'ctrl-x r' will complete the 12 last modified (mtime) files/directories
zle -C newest-files complete-word _generic
bindkey '^Xr' newest-files
zstyle ':completion:newest-files:*' completer _files
zstyle ':completion:newest-files:*' file-patterns '*~.*(omN[1,12])'
zstyle ':completion:newest-files:*' menu select yes
zstyle ':completion:newest-files:*' sort false
zstyle ':completion:newest-files:*' matcher-list 'b:=*' # important

function only-local-history-up () {
        zle set-local-history 1
        zle up-history
        zle set-local-history 0
}
function only-local-history-down () {
        zle set-local-history 1
        zle down-history
        zle set-local-history 0
}
zle -N only-local-history-up
zle -N only-local-history-down


# Custom widget to store a command line in history
# without executing it
commit-to-history() {
  print -s ${(z)BUFFER}
  zle send-break
}
zle -N commit-to-history


# Bindings
bindkey "^X^H" commit-to-history
bindkey "^Xh" push-line
bindkey -M viins "^X^H" commit-to-history
bindkey -M viins "^Xh" push-line

bindkey '^Xt' tmux-pane-words-prefix
bindkey '^X^X' tmux-pane-words-anywhere
bindkey -M viins '^Xt' tmux-pane-words-prefix
bindkey -M viins '^X^X' tmux-pane-words-anywhere

bindkey '^Xr' newest-files
bindkey -M viins '^Xr' newest-files

bindkey -M emacs "^[[1;5A" only-local-history-up    # [CTRL] + Cursor up
bindkey -M emacs "^[[1;5B" only-local-history-down  # [CTRL] + Cursor down
bindkey -M vicmd 'K' only-local-history-up
bindkey -M vicmd 'J' only-local-history-down

bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

bindkey -M vicmd '^r' redo
bindkey -M vicmd 'u' undo
bindkey -M viins 'jj' vi-cmd-mode

# Enabling vim text-objects (ciw and alike) for vi-mode
#source ~/.opp.zsh/opp.zsh

export REPORTTIME=5

HISTSIZE=1000000
SAVEHIST=1000000

alias gy=NO_GITSTATUS=
alias gn=NO_GITSTATUS="yes"
alias tmux='TERM=screen-256color-bce LANG=en_US.UTF-8 nice -n 1 tmux -2'
alias ran=run-and-notify
alias gsm='git submodule'
alias gsmu='git submodule update --init --recursive'
alias pipi='pip install --user --break-system-packages'
eval $(thefuck --alias f)

source "$HOME/.homesick/repos/homeshick/homeshick.sh"

source_if_available ~/.fzf/shell/completion.zsh
source_if_available ~/.fzf/shell/key-bindings.zsh

kitty + complete setup zsh | source /dev/stdin

source_if_available ~/.zshrc.local
