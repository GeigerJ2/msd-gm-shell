#!/bin/bash
for shell in bash fish zsh; do
    for state in empty final; do
    docker buildx build -t "msd-gm-$shell-$state" -f "$shell-$state.docker" .
    done
done
