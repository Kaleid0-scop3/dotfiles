#!/usr/bin/env bash

IS_WINDOWS=
PRINT_DOTFILES=

. ./dotfiles.sh

# Prints usage information
usage() {
    cat << EOF
Usage: $0 [options]
Options:
  -w, --windows   Set this flag for Windows machines
  -l, --list      List the dotfiles to be symlinked, then exit
  -h, --help      Show this help message
EOF
}

# Prints the dotfiles to be symlinked in the format:
# source -> destination
print_dotfiles() {
    local src dst
    echo "${#dotfiles[@]} dotfiles to be symlinked:"
    for src in "${!dotfiles[@]}"; do
        dst="${dotfiles[$src]}"
        src="$PWD/$src"
        echo "$dst -> $src"
    done
}

# Creates symlinks for the dotfiles in the array
symlink_dotfiles() {
    local src dst
    echo "Creating symlinks for ${#dotfiles[@]} dotfiles..."
    for src in "${!dotfiles[@]}"; do
        dst="${dotfiles[$src]}"
        src="$PWD/$src"

        # Ignore file if it is already symlinked to the correct source
        if [[ -L "$dst" && $(readlink "$dst") == "$src" ]]; then
            echo "'$dst' is already a symlink to '$src'. Skipping..."
            continue
        fi

        # Backup existing file if it exists
        if [[ -e "$dst" || -L "$dst" ]]; then
            echo "'$dst' already exists. Backing it up to '$dst.old'..."
            mv "$dst" "$dst.old"
            if [[ $? -ne 0 ]]; then
                echo "Failed to backup '$dst'."
                return 1
            else
                echo 'Backup complete.'
            fi
        fi

        # Create the symlink
        echo "Creating symlink from '$src' to '$dst'"
        mkdir -p "$(dirname "$dst")"
        if [[ $? -ne 0 ]]; then
            echo "Failed to create directory for '$dst'."
            return 1
        fi

        ln -s "$src" "$dst"
        if [[ $? -ne 0 ]]; then
            echo "Failed to create symlink from '$src' to '$dst'."
            return 1
        fi
        echo 'Symlink created.'
    done
}

main() {
    local opt src
    # Check if the script is being run from the root of the repository
    if [[ -d '.git' && ! -e $(basename "$0") ]]; then
        echo 'This script must be ran from the root of the repository.'
        exit 1
    fi

    # Gather submodules
    git submodule init && git submodule update
    if [[ $? -ne 0 ]]; then
        echo 'Failed to initialize and update submodules.'
        exit 1
    fi

    # Parse command line arguments
    for opt in "$@"; do
        case $opt in
            -l|--list)
                PRINT_DOTFILES='yes'
                ;;
            -w|--windows)
                IS_WINDOWS='yes'
                shift
                echo "THIS IS NOT SUPPORTED YET!"
                exit 1
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done

    # Replace dotfiles with windows paths if the --windows flag is set
    if [[ "$IS_WINDOWS" == 'yes' ]]; then
        for src in "${!windows_paths[@]}"; do
            dotfiles["$src"]="${windows_paths[$src]}"
        done
    fi

    if [[ "$PRINT_DOTFILES" == 'yes' ]]; then
        print_dotfiles
        exit 0
    fi

    symlink_dotfiles
    if [[ $? -ne 0 ]]; then
        echo 'Failed to create symlinks for dotfiles.'
        exit 1
    fi
    echo 'Symlinks for dotfiles created successfully.'
}

main "$@"
