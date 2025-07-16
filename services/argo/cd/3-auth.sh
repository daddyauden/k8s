#!/usr/bin/env sh
set -e

unamestr=$(uname)

if [ "$unamestr" = 'Linux' ]; then
    cd /tmp

    # latest version
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64

    # latest stable version
    VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64

    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64

    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64
    cd ~
elif [ "$unamestr" = 'FreeBSD' ] || [ "$unamestr" = 'Darwin' ]; then
    ARCH=$(uname -m)

    if [ "$ARCH" = "x86_64" ]; then
        brew install argocd
    elif [ "$ARCH" = "arm64" ]; then
        cd /tmp
        VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
        curl -sSL -o argocd-darwin-arm64 https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-darwin-arm64
        sudo install -m 555 argocd-darwin-arm64 /usr/local/bin/argocd
        rm argocd-darwin-arm64
        cd ~
    else
        echo "Unsupported architecture: $ARCH"
        exit 1
    fi
fi
