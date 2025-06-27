#!/usr/bin/env sh
set -e

if [ ! -d "github" ]; then
    mkdir ./github
    touch ./github/.gitkeep
fi

cd github

if [ ! -d "rook/deploy/examples" ]; then
    git clone https://github.com/rook/rook.git
fi

cd rook/deploy/examples
