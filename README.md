# My dotfiles and configs

This repository contains my personal dotfiles and configurations for various tools and applications.

## Installation

To install these dotfiles, clone this repository and run the `install.sh` script (or `install.ps1` if syncing on windows) in the root directory of this repository. This will create symbolic links to the appropriate configuration files in your home directory.

The `install.sh` script has the following flags:

- `-l` or `--list`: List the dotfiles to be symlinked, without actually creating the symlinks.
- `-h` or `--help`: Display the help message.

> [!TIP]
> If you want to customize the installation process, you can edit `dotfiles.csv` and `dotfiles_win.csv` to change the list of dotfiles to be symlinked or the locations of the symlinks.

> [!NOTE]
> If you already have some dotfiles and they are not already symlinks to the right files, the install script will back them up with a `.old` extension before creating the symlinks.

## Updating

To update the dotfiles, simply pull the latest changes from this repository and it's submodules then run the install script again. This will update the symlinks to point to the latest versions of the configuration files.

```shell
user@machine:~$ git pull --recurse-submodules
user@machine:~$ ./install.sh
```

## Making changes

### Adding new dotfiles

To add new dotfiles to this repository, follow these steps:

1. Create a new file in the appropriate directory and add the configuration to it.
2. Update `dotfiles.csv` to include the new file.
3. If needed, update `dotfiles_win.csv` to include the Windows location for the new file.
4. Commit and push the changes to the repository.
5. Run the install script to create the symlink for the new dotfile.

### Adding new submodules

To add new submodules (a.k.a. references to other repositories that should be included in this repository), follow these steps:

1. Add the submodule with the `git submodule add` command, specifying the repository URL and the path where you want to add the submodule:

    ```shell
    user@machine:~$ git submodule add $REPOSITORY_URL $PATH_TO_SUBMODULE
    ```

2. Continue from step 2 of the [Adding new dotfiles](#adding-new-dotfiles) section using `$PATH_TO_SUBMODULE` as the path for the source file.

> [!WARNING]
> This is still a work in progress. Use at your own risk.
