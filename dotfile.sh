#!/bin/zsh

GREEN='\033[0;32m'
NC='\033[0m'

# Function to check if a command exists
command_exists() {
    # check -V or -v, if any of them works
    command -V "$1" >/dev/null 2>&1 || command -v "$1" >/dev/null 2>&1
}

colorize() {
    local color="$1"
    local text="$2"
    local NC='\033[0m' # No Color

    case "$color" in
    "red")
        echo "\033[0;31m$text${NC}"
        ;;
    "green")
        echo "\033[0;32m$text${NC}"
        ;;
    "yellow")
        echo "\033[0;33m$text${NC}"
        ;;
    "blue")
        echo "\033[0;34m$text${NC}"
        ;;
    "purple")
        echo "\033[0;35m$text${NC}"
        ;;
    "cyan")
        echo "\033[0;36m$text${NC}"
        ;;
    *)
        echo "Unknown color"
        ;;
    esac
}

# Check if Zsh is installed
if ! command_exists zsh; then
    echo "$(colorize "red" "Zsh is not installed. Please install Zsh before running this script.")"
    exit 1
else
    echo "$(colorize "green" "requirements satisfied: Zsh is installed.")"
fi

# Update and upgrade the system
echo "Updating and upgrading the system..."
sudo apt-get update -y
sudo apt-get upgrade -y

# Install required packages
echo "Installing required packages..."
sudo apt-get install -y curl git build-essential unzip python3 python3-pip tmux

# output log with spaces to indicate system update and package installation is completed
echo "$(colorize "green" "System update and package installation completed.")"
echo ""
echo ""

# Check if Homebrew exists
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
echo "$(colorize "green" "Homebrew installation completed.")"
# if ! command_exists brew; then
    # If it doesn't exist, run the installation script
    # (
    #     echo
    #     echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
    # ) >>$HOME/.zshrc
# else
#     echo "$(colorize "green" "Skipped: Homebrew is already installed.")"
# fi


echo "Setting zoxide configuration"
if ! command_exists $HOME/.local/bin/zoxide; then
    echo "Zoxide is not installed. Installing"
    brew install zoxide
    echo "Make sure your .zshrc file contains eval \$(zoxide init zsh)"
    brew install fzf
fi

if ! command_exists lazygit; then
    echo "Lazygit is not installed. Installing"
    brew install jesseduffield/lazygit/lazygit
    echo "$(colorize "green" "lazygit installation completed.")"
else
    echo "$(colorize "green" "Skipped: lazygit is already installed.")"
fi

echo "Installing neovim"
if ! command_exists nvim; then
    echo "Neovim is not installed. Installing"
    brew install neovim
    echo "$(colorize "green" "Neovim installation completed.")"
else
    echo "$(colorize "green" "Skipped: Neovim is already installed.")"
fi

echo "Installing dependencies for astrovim"
if ! command_exists cargo; then
    echo "Cargo is not installed. Installing"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    . "$HOME/.cargo/env"
    echo "Cargo installation completed."
else
    echo "$(colorize "green" "Skipped: Cargo is already installed.")"
fi

if ! command_exists fnm; then
    echo "fnm is not installed. Installing"
    brew install fnm
    echo "fnm installation completed."
    # install latest node version
    fnm install latest
else
    echo "$(colorize "green" "Skipped: fnm is already installed.")"
fi

if ! command_exists rg; then
    echo "ripgrep is not installed. Installing"
    brew install ripgrep
    echo "$(colorize "green" "ripgrep installation completed.")"
else
    echo "$(colorize "green" "Skipped: ripgrep is already installed.")"
fi

if ! command_exists btm; then
    echo "Bottom is not installed. Installing"
    cargo install bottom --locked
    echo "$(colorize "green" "bottom installation completed.")"
else
    echo "$(colorize "green" "Skipped: bottom is already installed.")"
fi

# check if linux machine and install golang
case "$(uname -sr)" in
Darwin*)
    echo 'Mac OS X'
    ;;

Linux*Microsoft*)
    echo 'WSL' # Windows Subsystem for Linux
    ;;

Linux*)
    echo 'Linux Golang installation'
    # check whether go is installed
    if command_exists go; then
        echo "$(colorize "green" "Skipped: Golang is already installed.")"
    else
        sudo rm -rf /usr/local/go
        wget https://go.dev/dl/go1.22.3.linux-amd64.tar.gz
        sudo tar -C /usr/local -xzf go1.22.3.linux-amd64.tar.gz
        rm go1.22.3.linux-amd64.tar.gz
        source ~/.zshrc
        go version
    fi
    ;;

CYGWIN* | MINGW* | MINGW32* | MSYS*)
    echo 'MS Windows'
    ;;

# Add here more strings to compare
# See correspondence table at the bottom of this answer

*)
    echo 'Other OS'
    ;;
esac

# install gdu - golang disk usage
if ! command_exists gdu; then
    echo "gdu is not installed. Installing"
    curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz
    chmod +x gdu_linux_amd64
    sudo mv gdu_linux_amd64 /usr/bin/gdu
    echo "$(colorize "green" "gdu installation completed.")"
else
    echo "$(colorize "green" "Skipped: gdu is already installed.")"
fi

# install astrovim
echo "Installing astrovim"
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
rm -rf ~/.config/nvim/.git
# nvim

echo "Installing tmux"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# check if tmux.conf exists
if [ -f ~/.tmux.conf ]; then
    echo "Backing up existing tmux.conf"
    mv ~/.tmux.conf ~/.tmux.conf.bak
fi
ln -s ~/mysdotfile/.tmux.conf ~/.tmux.conf
echo "$(colorize "green" "tmux installation completed.")"

# Install Oh My Zsh for managing Zsh configuration
oh_my_zsh_dir="$HOME/.oh-my-zsh"

# Check if ~/.oh-my-zsh exists
if [ ! -d "$oh_my_zsh_dir" ]; then
    # If it doesn't exist, run the installation script
    sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
    echo "Oh My Zsh installation completed."
else
    echo "$(colorize "green" "Skipped: Oh My Zsh is already installed in ~/.oh-my-zsh.")"
fi

zsh_autosuggestions_path="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [ ! -d "$zsh_autosuggestions_path" ]; then
    echo "Installing zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    echo "$(colorize "green" "zsh-autosuggestions installation completed.")"
else
    echo "$(colorize "green" "Skipped: zsh-autosuggestions is already installed.")"
fi

zsh_syntax_highlighting_path="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
if [ ! -d "$zsh_syntax_highlighting_path" ]; then
    echo "Installing zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    echo "$(colorize "green" "zsh-syntax-highlighting installation completed.")"
else
    echo "$(colorize "green" "Skipped: zsh-syntax-highlighting is already installed.")"
fi

echo "Setting zsh configuration"
zshrc_path="$HOME/.zshrc"
link_path="$HOME/mysdotfile/.zshrc"

# Check if ~/.zshrc exists
if [ -f "$zshrc_path" ]; then
    # If it exists, remove it
    rm "$zshrc_path"
    echo "Removed existing ~/.zshrc file."
fi

# Create a symbolic link
ln -s "$link_path" "$zshrc_path"
echo "Created symbolic link from mysdotfile/.zshrc to ~/.zshrc."

powerlevel10k_path="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
if [ ! -d "$powerlevel10k_path" ]; then
    echo "Installing powerlevel10k"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    echo "$(colorize "green" "powerlevel10k installation completed.")"
else
    echo "$(colorize "green" "Skipped: powerlevel10k is already installed.")"
fi

echo "Run the following command to apply the changes for powerlevel10k:"
echo "source ~/.zshrc"