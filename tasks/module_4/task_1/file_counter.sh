#!/usr/bin/env bash
dir=.
[ ! -z "$1" ] && dir=$1

echo "Counting files $dir directory..."
echo -e "Files count: \033[1m$(find $dir -type f | wc -l)\033[0m"