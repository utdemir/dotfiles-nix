local return_code="%(?..%{$bg[red]%}! %? !%{$reset_color%} )"

PROMPT='${return_code}%F{magenta}%n%f@%F{yellow}%m%f:%B%F{green}%~%f%b$(git_prompt_info)
$ '

ZSH_THEME_GIT_PROMPT_PREFIX=' on %F{magenta}'
ZSH_THEME_GIT_PROMPT_SUFFIX='%f'
ZSH_THEME_GIT_PROMPT_DIRTY='%F{green}!'
ZSH_THEME_GIT_PROMPT_UNTRACKED='%F{green}?'
ZSH_THEME_GIT_PROMPT_CLEAN=''
