#!/bin/sh

# Delete all files in /wd/ except for .duplicacy
# This needs rm -f because the symlinks created previously may inherit read-only permissions.
cd / 
find /wd/ -mindepth 1 -maxdepth 1 -not -path /wd/.duplicacy -exec rm -f {} \;
cd - > /dev/null
