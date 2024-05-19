# My's Dotfile

This dotfile contains boostrap commands for setting linuxbrew, golang, rust, neovim, astrovim, zoxide, fnm, gdu, bottom, python3, oh-my-zsh, powerlevel10k

- tmux: tpm(plugin manager for tmux), key mapping
- neovim: astrovim distro and its dependencies.
- zsh: oh-my-zsh, powerlevel10k, zoxide(alternative for `cd` command)

## Requirement

- Install zsh and chsh to zsh for current user

## Plantform Supported

- Ubuntu 20.04

## Installation

Run each command below to install

1. clone this repo into your home directory

```bash
cd
git clone https://github.com/cyrilwongmy/mysdotfile.git
```

2. run the install.sh script

```bash
cd mysdotfile
sh dotfile.sh
```

Since .oh-my-zsh will interfere with the installation of the dotfiles, you will need to exit oh-my-zsh manually when you see the installation done for oh-my-zsh.

```bash
exit
```

After that, the installation will continue.

When the installation is done, you should run `zsh` to start the zsh shell and setup powerlevel10k.
When you set up powerlevel10k, you should run `source ~/.zshrc` to apply the changes.
