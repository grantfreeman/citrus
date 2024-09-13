#!/usr/bin/env sh

script_dir=$(dirname $(realpath -s "$0"))
user=$(whoami)

# install required tools
if ! type curl > /dev/null; then
    sudo apt install curl
fi

if ! type wget > /dev/null; then
    sudo apt install wget
fi

# download binary
release=$(curl -sL https://api.github.com/repos/VSCodium/vscodium/releases/latest)
printf '%s\n' "$release" | jq -c ".assets.[]" | while read asset
do
    if printf '%s\n' "$asset" | jq -r ".name" | grep -q ".*amd64.deb$"
    then
        name=$(printf '%s\n' "$asset" | jq -r ".name")
        url=$(printf '%s\n' "$asset" | jq -r ".browser_download_url")
        wget -P $script_dir $url
        sudo apt install $script_dir/$name -y
        rm $script_dir/$name
        exit
    fi
done

printf 'unable to find amd64.deb version of codium\n'
