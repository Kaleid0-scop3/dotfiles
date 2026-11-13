#!/usr/bin/env bash

# Dotfiles array, populated by load_dotfiles()
declare -A DOTFILES

# Repos array, populated by load_repos()
declare -A REPOS

# Prints usage information
usage() {
    cat << EOF
Usage: $0 [options]
Options:
  -l, --list      List the dotfiles and repositories to be symlinked, then exit
  -h, --help      Show this help message
EOF
}

check_dependencies() {
    local deps
    deps=('git' 'envsubst')
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            echo "Error: '$dep' is not installed. Please install it and try again."
            return 1
        fi
    done
}

# Loads a file containing dotfiles into the DOTFILES array.
# Each line of the file must have the format:
# source,destination
# source is relative to the root of the repository
# destination is an absolute path
load_dotfiles() {
    local file content src dst
    file="$1"
    if [[ ! -f "$file" ]]; then
        echo "Dotfiles file '$file' not found."
        return 1
    fi

    # Read each line of $file as src,dst
    while IFS=',' read -r src dst || [[ -n "$src" ]]; do
        # Skip empty lines and comments
        [[ -z "$src" || "$src" =~ ^# ]] && continue

        # Expand variables inside destination path
        dst=$(envsubst <<< "$dst")
        DOTFILES["$src"]="$dst"
    done < "$file"
}

# Loads a file containing repos into the REPOS array.
# Each line of the file must have the format:
# source,destination
# source is an url to a git repository
# destination is an absolute path
load_repos() {
    local file content src dst
    file="$1"
    if [[ ! -f "$file" ]]; then
        echo "Repo file '$file' not found."
        return 1
    fi

    # Read each line of $file as src,dst
    while IFS=',' read -r src dst || [[ -n "$src" ]]; do
        # Skip empty lines and comments
        [[ -z "$src" || "$src" =~ ^# ]] && continue

        # Expand variables inside destination path
        dst=$(envsubst <<< "$dst")
        REPOS["$src"]="$dst"
    done < "$file"
}

# Prints the dotfiles and repos to be symlinked in the format:
# source -> destination
print_dotfiles() {
    local src dst
    echo "${#DOTFILES[@]} dotfiles and ${#REPOS[@]} repositories to be symlinked:"
    for src in "${!DOTFILES[@]}"; do
        dst="${DOTFILES[$src]}"
        src="$PWD/$src"
        echo "$dst -> $src"
    done
    for src in "${!REPOS[@]}"; do
        dst="${REPOS[$src]}"
        echo "$dst -> $src"
    done
}

# Creates symlinks for the dotfiles in the DOTFILES array
symlink_dotfiles() {
    local src dst
    echo "Creating symlinks for ${#DOTFILES[@]} dotfiles..."
    for src in "${!DOTFILES[@]}"; do
        dst="${DOTFILES[$src]}"
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
        mkdir -p "$(dirname $dst)"
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

# Clones the repositories in the REPOS array
clone_repos() {
    local src dst
    echo "Cloning ${#REPOS[@]} repositories..."
    for src in "${!REPOS[@]}"; do
        dst="${REPOS[$src]}"

        # Pull the repo if it already exists, otherwise clone it
        if [[ -d "$dst/.git" ]]; then
            echo "'$dst' already exists. Pulling latest changes from '$src'..."
            git -C "$dst" pull &> /dev/null
            if [[ $? -ne 0 ]]; then
                echo "Failed to pull latest changes from '$src' into '$dst'."
                return 1
            fi
        else
            echo "Cloning '$src' into '$dst'..."
            mkdir -p "$dst"
            git clone "$src" "$dst" &> /dev/null
            if [[ $? -ne 0 ]]; then
                echo "Failed to clone '$src' into '$dst'."
                return 1
            fi
        fi
        echo 'Repository cloned or updated.'
    done
}

main() {
    local opt src
    # Check if the script is being run from the root of the repository
    if [[ -d '.git' && ! -e $(basename "$0") ]]; then
        echo 'This script must be ran from the root of the repository.'
        exit 1
    fi

    # Check for dependencies
    if ! check_dependencies; then
        echo 'Please install the missing dependencies and try again.'
        exit 1
    fi

    # Load dotfiles from dotfiles.csv
    load_dotfiles "dotfiles.csv"
    if [[ $? -ne 0 ]]; then
        echo 'Failed to read dotfiles from dotfiles.csv.'
        exit 1
    fi

    # Load repos from repos.csv
    load_repos "repos.csv"
    if [[ $? -ne 0 ]]; then
        echo 'Failed to read repos from repos.csv.'
        exit 1
    fi

    # Parse command line arguments
    for opt in "$@"; do
        case $opt in
            -l|--list)
                print_dotfiles
                exit 0
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

    symlink_dotfiles
    if [[ $? -ne 0 ]]; then
        echo 'Failed to create symlinks for dotfiles.'
        exit 1
    fi
    echo 'Symlinks for dotfiles created successfully.'

    clone_repos
    if [[ $? -ne 0 ]]; then
        echo 'Failed to clone repositories.'
        exit 1
    fi
    echo 'Repositories cloned successfully.'
}

main "$@"
