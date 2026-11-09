#!/usr/bin/env false

# Do not execute this file directly.
if ! (return 0 &> /dev/null); then
	echo "This file is not meant to be executed directly. Please run install.sh instead."
    exit 1
fi

# Array of dotfiles to symlink in the format:
# [source]=destination
# source is relative to the root of the repository
# destination is an absolute path
declare -A dotfiles=(
    ['bash/.bash_logout']="$HOME/.bash_logout"
    ['bash/.bash_profile']="$HOME/.bash_profile"
    ['bash/.bashrc']="$HOME/.bashrc"
    ['git/.gitconfig']="$HOME/.gitconfig"
    ['git/.gitignore']="$HOME/.gitignore"
    # ['nano/nano-syntax-highlighting']="$HOME/.config/nano/nano-syntax-highlighting"
    ['nano/nanorc']="$HOME/.config/nano/nanorc"
    ['oh-my-posh/custom.omp.json']="$HOME/.config/oh-my-posh/custom.omp.json"
    ['powershell/Microsoft.PowerShell_profile.ps1']="$HOME/.config/powershell/Microsoft.PowerShell_profile.ps1"
    ['sh/.aliases']="$HOME/.aliases"
    ['sh/.profile']="$HOME/.profile"
    ['zsh/.zprofile']="$HOME/.zprofile"
    ['zsh/.zshrc']="$HOME/.zshrc"
)

# Dotfiles that change paths when running on windows in the format:
# [source]=windows_destination
# source is relative to the root of the repository
# destination is an absolute path
declare -A windows_paths=(
    ['powershell/Microsoft.PowerShell_profile.ps1']="$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
)
