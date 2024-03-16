#!/usr/bin/bash
# Run this after cloning the dotfiles repo to copy the config files to their
# appropriate location.

# Git config
if [ -f "$HOME/.gitconfig" ]
	then
		rm "$HOME/.gitconfig"
fi;
cp "$HOME/dev/itrew/dotfiles/git/.gitconfig" "$HOME/.gitconfig"
