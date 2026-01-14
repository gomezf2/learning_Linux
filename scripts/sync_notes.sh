#!/bin/bash

SOURCE="/mnt/c/Users/franc/OneDrive/Documents/Osidian Notebook/Thinking and Thoughts/Devops Journey/Linux Journey"
DEST="$HOME/learning_linux"

rsync -avz "$SOURCE" "$DEST"
