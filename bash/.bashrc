# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# History settings
HISTFILE="$HOME/.bash_history"
HISTSIZE=1000
SAVEHIST=1000
HISTCONTROL='ignoreboth'

# Bash features
shopt -s checkwinsize # Aggiorna la dimensione dopo ogni comando
shopt -s cdspell      # Correggi typo in cd
shopt -s dirspell     # Correggi typo in riga con [tab]
shopt -s autocd       # Prova a chiamare cd se uso un comando che non esiste
shopt -s cmdhist      # Storico unico per comandi con più righe
shopt -s lithist      # Ricorda le newline nello storico di comandi multilinea
shopt -s extglob      # Atttiva espansioni come ".{jpg,jpeg}"
shopt -s failglob     # Errore se espansione fallisce
shopt -s globstar     # Attiva ** per iterare recursivamente su tutte le directory
shopt -s histappend   # Aggiungi alla fine della cronologia di comandi invece di sovrascrivere

# Setting up prompt
reset=$'\[\e[0m\]'
cyan=$'\[\e[38;5;73m\]'
green=$'\[\e[38;5;106m\]'
blue=$'\[\e[38;5;110m\]'
PS1="${green}\u${reset}@${cyan}\h${reset} ${blue}\w${reset} \$ "
unset reset cyan green blue

OMP_CFG="$HOME/.config/oh-my-posh/custom.omp.json"
[[ -r "$OMP_CFG" ]] && command -v oh-my-posh &&
    eval "$(oh-my-posh init bash --config $OMP_CFG)"

# Setting up aliases
[[ -r "$HOME/.aliases" ]] && . "$HOME/.aliases"

# Source local .bashrc
[[ -r "$HOME/.bashrc.local" ]] && . "$HOME/.bashrc.local"
