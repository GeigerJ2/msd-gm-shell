# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install vim, git, and other utilities
RUN apt update && apt install -y sudo apt-utils dialog vim git curl wget unzip fontconfig python3 python3-pip python3-dev python3-venv python-is-python3
RUN apt install -y software-properties-common

# Install zsh
RUN apt install -y zsh

# Install latest fish
RUN apt-add-repository ppa:fish-shell/release-3 \
    && apt update \
    && apt install -y fish

# Add a new user named 'shell-chad'
RUN useradd -m shell-chad && echo "shell-chad:shell-chad" | chpasswd && adduser shell-chad sudo

# Disable password requirement for sudo for all users in the sudo group
RUN echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Set the working directory to the home directory of 'shell-chad'
WORKDIR /home/shell-chad

# Install aiida-core -> Early in Dockerfile to keep cached layer with cloned repositories
RUN git clone https://github.com/aiidateam/aiida-core.git
RUN git clone https://github.com/aiidateam/aiida-quantumespresso.git
RUN git clone https://github.com/aiidateam/aiida-project.git

# Actually install aiida-core to have `verdi` commands available for fish plugin demo
RUN pip install aiida-core

# Download the JetBrains Mono Nerd Font and install
RUN curl -fLo "JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip \
    && mkdir -p ~/.local/share/fonts \
    && unzip JetBrainsMono.zip -d ~/.local/share/fonts \
    && fc-cache -f -v \
    && rm JetBrainsMono.zip

# Optional: Set the default shell to zsh/fish
# RUN chsh -s /usr/bin/zsh
# RUN chsh -s /usr/bin/fish

# Recursively change user for the home directory
RUN chown -R shell-chad:shell-chad /home/shell-chad

# Installing customization packages presented in this seminar via apt (bat -> RUST 🦀)
RUN apt install -y exa bat entr tmux fzf

# Some other recommendable tools (many of which are optional dependencies of AstroNvim)
RUN apt install -y fd-find ripgrep htop

## lazygit
RUN wget https://github.com/jesseduffield/lazygit/releases/download/v0.41.0/lazygit_0.41.0_Linux_arm64.tar.gz \
    &&  tar xzvf lazygit_0.41.0_Linux_arm64.tar.gz \
    && mv lazygit /usr/bin/ \
    && rm lazygit_0.41.0_Linux_arm64.tar.gz LICENSE README.md
## gdu
RUN curl -L https://github.com/dundee/gdu/releases/latest/download/gdu_linux_amd64.tgz | tar xz \
    && chmod +x gdu_linux_amd64 \
    && mv gdu_linux_amd64 /usr/bin/gdu
## bottom
RUN curl -LO https://github.com/ClementTsang/bottom/releases/download/0.9.6/bottom_0.9.6_amd64.deb \
    && sudo dpkg -i bottom_0.9.6_amd64.deb \
    && rm bottom_0.9.6_amd64.deb
## nvm and node.js
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash \
    && export NVM_DIR="$HOME/.nvm" \
    && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
    && nvm install node

# Set the default user to 'shell-chad' -> Required so that installation of atuin and zoxide work (shouldn't be installed
# via root?)
USER shell-chad

## atuin -> RUST 🦀
RUN curl -s https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh | bash

# zoxide -> RUST 🦀
RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
## Move binary to /usr/bin, as it is not found on startup otherwise
RUN sudo mv "$HOME/.local/bin/zoxide" /usr/bin/

# oh-my installations -> Overwrites ~/.bashrc and ~/.zshrc

## oh-my-bash
RUN bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmybash/oh-my-bash/master/tools/install.sh)"

## oh-my-zsh & powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh

# Further custom configuration options (aliases, environment variables, and initialization commands)

## For bash
RUN echo 'alias ls="exa --icons"' >> ~/.bashrc \
    && echo 'alias cat=batcat' >> ~/.bashrc \
    && echo 'alias bat=batcat' >> ~/.bashrc \
    && echo 'alias cd=z' >> ~/.bashrc \
    && echo 'alias cdi=zi' >> ~/.bashrc \
    && echo 'alias nvim=/home/shell-chad/nvim-linux64/bin/nvim' >> ~/.bashrc \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc \
    && echo 'export HOST=shell-chad' >> ~/.bashrc \
    && echo 'export HOSTNAME=shell-chad' >> ~/.bashrc \
    && echo 'eval "$(atuin init bash)"' >> ~/.bashrc \
    && echo 'eval "$(zoxide init bash)"' >> ~/.bashrc

## For zsh
RUN echo "alias ls='exa --icons'" >> ~/.zshrc \
    && echo 'alias cat=batcat' >> ~/.zshrc \
    && echo 'alias bat=batcat' >> ~/.zshrc \
    && echo 'alias cd=z' >> ~/.zshrc \
    && echo 'alias cdi=zi' >> ~/.zshrc \
    && echo 'alias nvim=/home/shell-chad/nvim-linux64/bin/nvim' >> ~/.zshrc \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc \
    && echo 'export HOST=shell-chad' >> ~/.zshrc \
    && echo 'export HOSTNAME=shell-chad' >> ~/.zshrc \
    && echo 'export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true' >> ~/.zshrc \
    && echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc \
    && echo 'eval "$(atuin init zsh)"' >> ~/.zshrc \
    && echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc \
    COPY zsh-configs/.p10k.zsh /home/shell-chad/

## Disable "[powerlevel10k] fetching gitstatusd" on startup
RUN echo exit | script -qec zsh /dev/null >/dev/null

## For fish
RUN mkdir -p ~/.config/fish
RUN echo 'alias ls="exa --icons"' >> ~/.config/fish/config.fish \
    && echo 'alias cat=batcat' >> ~/.config/fish/config.fish \
    && echo 'alias bat=batcat' >> ~/.config/fish/config.fish \
    && echo 'alias cd=z' >> ~/.config/fish/config.fish \
    && echo 'alias cdi=zi' >> ~/.config/fish/config.fish \
    && echo 'alias nvim=/home/shell-chad/nvim-linux64/bin/nvim' >> ~/.config/fish/config.fish \
    && echo 'set -gx PATH $HOME/.local/bin $PATH' >> ~/.config/fish/config.fish \
    && echo 'set -gx HOST shell-chad' >> ~/.config/fish/config.fish \
    && echo 'set -gx HOSTNAME shell-chad' >> ~/.config/fish/config.fish \
    && echo 'atuin init fish | source' >> ~/.config/fish/config.fish \
    && echo 'zoxide init fish | source' >> ~/.config/fish/config.fish

# Fish plugins
RUN fish -c 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
RUN fish -c 'fisher install jhillyerd/plugin-git' \
    && fish -c 'fisher install patrickf1/fzf.fish' \
    && fish -c 'fisher install kidonng/zoxide.fish' \
    && fish -c 'fisher install jethrokuan/z' \
    && fish -c 'fisher install geigerj2/plugin-aiida'
## We will install this during the seminar
# && fish -c 'fisher install ilancosman/tide@v6' \
# && fish -c 'fisher install geigerj2/plugin-aiida'

# Copy tmux config
COPY tmux-config/.tmux.conf /home/shell-chad/

# AstroNvim
RUN wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz \
    && tar xzvf ~/nvim-linux64.tar.gz \
    && rm nvim-linux64.tar.gz \
    && git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim

# Clean apt cache
RUN sudo apt clean

# Create arbitary directory tree for demonstration
RUN bash -c "mkdir -p demo/{dir1,dir2,dir3}/{subdir1,subdir2} && touch demo/dir{1..3}/subdir{1..2}/{file1,file2,file3}"

# Change to aiida-core directory for demonstration
WORKDIR /home/shell-chad/aiida-core

# Start bash with autmomatic sourcing ~/.bashrc
CMD ["/bin/bash", "-c", "source ~/.bashrc && /bin/bash"]
