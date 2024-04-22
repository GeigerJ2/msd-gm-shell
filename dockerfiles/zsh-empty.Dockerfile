# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install vim, git, and other utilities
RUN apt update && apt install -y sudo vim git curl

# Install fish
RUN apt install -y fish

# Install zsh
RUN apt-get install -y zsh

# Add a new user named 'shell-chad'
RUN useradd -m shell-chad && echo "shell-chad:shell-chad" | chpasswd && adduser shell-chad sudo

# Disable password requirement for sudo for all users in the sudo group
RUN echo '%sudo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Set the working directory to the home directory of 'shell-chad'
WORKDIR /home/shell-chad

# Install aiida-core -> Early on Dockerfile to keep cached layer with cloned repository
RUN git clone https://github.com/aiidateam/aiida-core.git

# Set the default shell to zsh
RUN chsh -s /usr/bin/zsh

# Set the zsh prompt
# RUN echo "export PS1='shell-chad@zsh-image:$ '" >> /home/shell-chad/.zshrc

# Recursively change user for the home directory
RUN chown -R shell-chad:shell-chad /home/shell-chad

# Installing customization packages via apt

## exa
RUN apt install -y exa -y

## bat -> RUST
RUN apt install -y bat

## entr
RUN apt install -y entr

## tmux
RUN apt install -y tmux

## fzf
RUN apt install -y fzf

## zoxide
RUN curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# Set the default user to 'shell-chad'
USER shell-chad

## atuin -> RUST
RUN curl -s https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh | bash

# bash

# zsh
## oh-my-zsh & powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
RUN curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | zsh

## Further custom configuration
RUN mkdir /home/shell-chad/zsh-configs/
COPY zsh-configs/zsh-customization.zsh /home/shell-chad/zsh-configs/
RUN zsh /home/shell-chad/zsh-configs/zsh-customization.zsh
COPY zsh-configs/.p10k.zsh /home/shell-chad/

# fish
RUN mkdir -p ~/.config/fish/functions/
RUN fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
# RUN fish -c "fisher install ilancosman/tide@v6"
# RUN fish -c "fisher install jhillyerd/plugin-git"
# RUN fish -c "fisher install geigerj2/plugin-aiida"
# RUN fish -c "fisher install patrickf1/fzf.fish"
# RUN fish -c "fisher install kidonng/zoxide.fish"
# RUN fish -c "fisher install halostatue/fish-docker@v1.x"


# Clean apt cache
RUN sudo apt clean


# Change to aiida-core directory for demonstration
WORKDIR /home/shell-chad/aiida-core

CMD ["/bin/zsh"]
# CMD ["/bin/zsh", "-c", "source ~/.zshrc && /bin/zsh"]
