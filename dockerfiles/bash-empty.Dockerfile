# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install vim
RUN apt-get update && apt-get install -y vim

# Add a new user named 'bash-user'
RUN useradd -ms /bin/bash bash-user

# Set the default user to 'bash-user'
USER bash-user

# Set the hostname to 'bash-image'
# This needs to be done at runtime, hence adding it to .bashrc
RUN echo "export PS1='bash-user@bash-image:\\w\\$ '" >> /home/bash-user/.bashrc

# Set the working directory to the home directory of 'bash-user'
WORKDIR /home/bash-user

# Set the default shell to bash when running the container
CMD ["/bin/bash"]
