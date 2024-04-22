### Custom setup start

# oh-my-zsh
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

# Powerlevel10k via oh-my-zsh
# git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# echo ZSH_THEME="powerlevel10k/powerlevel10k" >> ~/.zshrc
# echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

# atuin


# zoxide

# bat -> RUST!
# exa
# sudo -u zsh-user apt install exa

# entr
sudo -u zsh-user apt install entr

# .zshrc aliases
echo 'export HOST=zsh-user' >> ~/.zshrc
echo 'export HOSTNAME=zsh-user' >> ~/.zshrc
echo "alias ls='exa --icons'" >> ~/.zshrc
echo "alias cat=bat" >> ~/.zshrc

# Other .zshrc settings
echo "export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true" >> ~/.zshrc

### Custom setup end

