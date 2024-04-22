# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install vim, git, and other utilities
RUN apt update && apt install -y sudo apt-utils vim git curl python3 python3-pip python3-dev
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

# Set the default shell to zsh
RUN chsh -s /usr/bin/zsh

# Recursively change user for the home directory
RUN chown -R shell-chad:shell-chad /home/shell-chad

# Installing customization packages via apt (bat -> RUST)
RUN apt install -y exa bat entr tmux fzf

# Set the default user to 'shell-chad' -> Required for installation of atuin and zoxide
USER shell-chad

## atuin -> RUST
RUN curl -s https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh | bash

# zoxide -> RUST
RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
## Move binary to /usr/bin, as it is not found on startup otherwise
RUN sudo mv "$HOME/.local/bin/zoxide" /usr/bin/

# zsh
## oh-my-zsh & powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh

## Further custom configuration
RUN echo "alias ls='exa --icons'" >> ~/.zshrc \
    && echo "alias cat=batcat" >> ~/.zshrc \
    && echo "alias cd=z" >> ~/.zshrc \
    && echo "alias cdi=zi" >> ~/.zshrc \
    && echo 'eval "$(atuin init zsh)"' >> ~/.zshrc \
    && echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc \
    && echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc \
    && echo 'export HOST=shell-chad' >> ~/.zshrc \
    && echo 'export HOSTNAME=shell-chad' >> ~/.zshrc \
    && echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc \
    && echo "export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true" >> ~/.zshrc
COPY zsh-configs/.p10k.zsh /home/shell-chad/
## Disable "[powerlevel10k] fetching gitstatusd" on startup
RUN echo exit | script -qec zsh /dev/null >/dev/null

# fish
# RUN mkdir -p ~/.config/fish/functions/
# Don't know if or why this should be needed, but it seems it is...
RUN rm -rf ~/.config/fish
RUN fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
RUN fish -c "fisher install ilancosman/tide@v6"
RUN fish -c "fisher install jhillyerd/plugin-git"
RUN fish -c "fisher install geigerj2/plugin-aiida"
RUN fish -c "fisher install patrickf1/fzf.fish"
RUN fish -c "fisher install kidonng/zoxide.fish"
RUN fish -c "fisher install halostatue/fish-docker@v1.x"

# Clean apt cache
RUN sudo apt clean

# Create arbitary directory tree for demonstration
RUN bash -c "mkdir -p demo/{dir1,dir2,dir3}/{subdir1,subdir2} && touch demo/dir{1..3}/subdir{1..2}/{file1,file2,file3}"

# Change to aiida-core directory for demonstration
WORKDIR /home/shell-chad/aiida-core

# CMD ["/bin/zsh"]
CMD ["/bin/zsh", "-c", "source ~/.zshrc && /bin/zsh"]
