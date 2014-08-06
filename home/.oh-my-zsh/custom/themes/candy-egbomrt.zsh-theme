#function empty() {}
#zle -N .beep empty

PROMPT=$'%{$fg_bold[green]%}%m %{$fg[blue]%}%D{[%H:%M:%S]} %{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%} %(?.%{$fg[green]%}.%{$fg[red]%})[%?]%{$reset_color%} $(git_prompt_info2)\
%{$fg[blue]%}->%(?.%{$fg[green]%}.%{$fg[red]%}) %#%{$reset_color%} '

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
