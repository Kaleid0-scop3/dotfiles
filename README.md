# My dotfiles and configs

This repository contains my personal dotfiles and configurations for various tools and applications.

## Installation

To install these dotfiles, clone this repository and run the `install.sh` script in the root directory of this repository. This will create symbolic links to the appropriate configuration files in your home directory.

The `install.sh` script has the following flags:

- `-l` or `--list`: List the dotfiles to be symlinked, without actually creating the symlinks.
- `-w` or `--windows`: Use Windows locations for the symlinks instead of the default Linux locations.
- `-h` or `--help`: Display the help message.

> [!TIP]
> If you want to customize the installation process, you can edit the `dotfiles.sh` file to change the list of dotfiles to be symlinked or the locations of the symlinks.

> [!NOTE]
> If you already have some dotfiles and they are not already symlinks to the right files, `install.sh` will back them up with a `.old` extension before creating the symlinks.

> [!WARNING]
> If you are using Windows, make sure to run the `install.sh` script in a Git Bash or WSL terminal, as the script may not work correctly in other environments.

> [!WARNING]
> Do not run the `dotfiles.sh` script directly, as it is meant to be sourced by the `install.sh` script.

## Updating

To update the dotfiles, simply pull the latest changes from this repository and it's submodules then run the `install.sh` script again. This will update the symlinks to point to the latest versions of the configuration files.

```shell
user@machine:~$ git pull --recurse-submodules
user@machine:~$ ./install.sh
```

## Making changes

### Adding new dotfiles

To add new dotfiles to this repository, follow these steps:

1. Create a new file in the appropriate directory and add the configuration to it.
2. Update the `dotfiles` array inside `dotfiles.sh` to include the new file.
3. If needed, update the `windows_paths` array inside `dotfiles.sh` to include the Windows location for the new file.
4. Commit and push the changes to the repository.
5. Run the `install.sh` script to create the symlink for the new dotfile.

### Adding new submodules

To add new submodules (a.k.a. references to other repositories that should be included in this repository), follow these steps:

1. Add the submodule with the `git submodule add` command, specifying the repository URL and the path where you want to add the submodule:

    ```shell
    user@machine:~$ git submodule add $REPOSITORY_URL $PATH_TO_SUBMODULE
    ```

2. Continue from step 2 of the [Adding new dotfiles](#adding-new-dotfiles) section using `$PATH_TO_SUBMODULE` as the path for the source file.
