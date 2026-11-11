# .profile

# Editor settings
export VISUAL='nano'
export EDITOR='nano'
export PAGER='less'
export MANPAGER='less'

## less color settings
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;31m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;33;44m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;1;32m'
export LESS_TERMCAP_mr=$'\e[7m'
export LESS_TERMCAP_mh=$'\e[2m'
export LESS_TERMCAP_ZN=$'\e[74m'
export LESS_TERMCAP_ZV=$'\e[75m'
export LESS_TERMCAP_ZO=$'\e[73m'
export LESS_TERMCAP_ZW=$'\e[75m'

# Locale
export LANG='it_IT.utf-8'

# Export Windows home directory if running in WSL
[ -f '/usr/bin/wslinfo' ] &&
    export WIN_HOME=$(wslpath -au "$(cmd.exe /c 'echo|set /p=%USERPROFILE%' 2> /dev/null)")

# PATH variable setup
## set PATH so it includes user's private bin if it exists
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

## set PATH so it includes user's go bin if it exists
[ -d "$HOME/go/bin" ] && PATH="$HOME/go/bin:$PATH"

export PATH
