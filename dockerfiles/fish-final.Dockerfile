# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Install vim and fish
RUN apt-get update && \
    apt-get install -y vim fish

# Change default shell to fish
RUN chsh -s /usr/bin/fish
SHELL ["/usr/bin/fish", "-c"]
