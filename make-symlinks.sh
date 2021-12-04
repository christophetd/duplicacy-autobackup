#!/bin/sh

# Duplicacy will follow symlinks at the top level of the working directory.
# (Note: these symlinks must point to absolute paths)
# For each item in /data, create a symlink (of the same name) to its _absolute path_ in /data/
cd /
find /data/ -mindepth 1 -maxdepth 1 -exec sh -c 'ln -s "$0" "/wd/$(basename "$0")"' {} \;
cd - > /dev/null
