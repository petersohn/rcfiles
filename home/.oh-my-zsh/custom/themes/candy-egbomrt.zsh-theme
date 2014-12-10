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

function cdf_info() {
	if [ -n "$CDF_USERENVIRONMENT" ]; then
		echo "%{$fg_bold[white]%}[$CDF_USERENVIRONMENT] %{$reset_color%}"
	fi
}

PROMPT=$'%{$fg_bold[green]%}%m %{$fg[blue]%}%D{[%H:%M:%S]} $(cdf_info)%{$reset_color%}%{$fg[white]%}[%~]%{$reset_color%} %(?.%{$fg[green]%}.%{$fg[red]%})[%?]%{$reset_color%} $(git_prompt_info2)\
%{$fg[blue]%}->%(?.%{$fg[green]%}.%{$fg[red]%}) %#%{$reset_color%} '

PS2='%_ >'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}*%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
