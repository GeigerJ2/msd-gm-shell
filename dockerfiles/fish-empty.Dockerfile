# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install vim and fish
RUN apt-get update && apt-get install -y vim fish

# Add a new user named 'fish-user'
RUN useradd -ms /usr/bin/fish fish-user

# Set the working directory to the home directory of 'fish-user'
WORKDIR /home/fish-user

# Set the default user to 'fish-user'
USER fish-user

# Set the fish prompt
RUN echo "function fish_prompt; echo 'fish-user@fish-image '\$PWD '>'; end" > .config/fish/config.fish

# Set the default shell to fish when running the container
CMD ["/usr/bin/fish"]
