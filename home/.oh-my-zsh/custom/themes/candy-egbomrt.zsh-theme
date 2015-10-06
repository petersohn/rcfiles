#function empty() {}
#zle -N .beep empty

function git_prompt_info2() {
    if [ -n "$NO_GITSTATUS" ]; then
        ref=$(git symbolic-ref HEAD 2> /dev/null) || return
        echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
    else
        echo -e "$(printBranch)"
    fi
}

function get_extra_info() {
    if type get_extra_prompt_info >/dev/null 2>&1; then
        get_extra_prompt_info
    fi
}

PROMPT=$'%{$fg[blue]%}╭%{$fg_bold[green]%}%m %{$fg[blue]%}%D{[%H:%M:%S]} %{$reset_color%}$(get_extra_info)%{$fg[white]%}[%~]%{$reset_color%} %(?.%{$fg[green]%}.%{$fg[red]%})[%?]%{$reset_color%} $(git_prompt_info2)\
%{$fg[blue]%}╰▶%(?.%{$fg[green]%}.%{$fg[red]%}) %#%{$reset_color%} '

PS2='%_ >'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
