# Powerlevel10k

# Powerlevel10k via oh-my-zsh
# git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# echo ZSH_THEME="powerlevel10k/powerlevel10k" >> ~/.zshrc
# echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

# zsh
## aliases
echo "alias ls='exa --icons'" >> ~/.zshrc
echo "alias cat=batcat" >> ~/.zshrc

## atuin, zoxide,
echo 'eval "$(atuin init zsh)"' >> ~/.zshrc
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc

## Other settings
echo 'export HOST=zsh-user' >> ~/.zshrc
echo 'export HOSTNAME=zsh-user' >> ~/.zshrc
### Powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc
#### Disable configuration prompt
echo "export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true" >> ~/.zshrc
