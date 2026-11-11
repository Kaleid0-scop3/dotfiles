# .zshrc

# Plugins
PLUGINSDIR='/usr/share/zsh/plugins'

if [[ -r "$PLUGINSDIR/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh" ]]; then
	source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
fi

if [[ -r "$PLUGINSDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh" ]]; then
	source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
fi

unset PLUGINSDIR

# Prompt
PS1='%F{106}%n%f@%F{73}%m%f %F{110}%~%f %# '
OMP_CFG="$HOME/.config/oh-my-posh/custom.omp.json"
[[ -r "$OMP_CFG" && -x "$(which oh-my-posh)" ]] && eval "$(oh-my-posh init zsh --config $OMP_CFG)"

# Keybinds
bindkey '^H' backward-delete-word
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[3;3~' delete-word
bindkey '^[[3;5~' delete-word
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[D' backward-char
bindkey '^[[1;3D' backward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[C' forward-char
bindkey '^[[1;3C' forward-word
bindkey '^[[1;5C' forward-word

# Magic Space (resolves aliases like !!)
bindkey ' ' magic-space

# Command Buffer
autoload -U edit-command-line
edit-command-line-and-redraw-prompt () {
    zle edit-command-line
    zle reset-prompt # redraw to fix mess of prompt and input text.
    zle end-of-buffer-or-history # move cursor to the end of input.
}
zle -N edit-command-line
zle -N edit-command-line-and-redraw-prompt
bindkey '^x^e' edit-command-line-and-redraw-prompt

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=1000
SAVEHIST=1000
HISTCONTROL='ignoreboth'

# Shell options
setopt globdots

# Alias
[[ -r "$HOME/.aliases" ]] && source "$HOME/.aliases"
