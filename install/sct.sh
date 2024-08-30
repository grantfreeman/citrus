#!/usr/bin/env sh

script_dir=$(dirname $(realpath -s "$0"))
user=$(whoami)
build_dir=$script_dir/build

if [ ! "$(dpkg -s libx11-dev | grep installed)" ]; then
    sudo apt install libx11-dev
fi

if [ ! "$(dpkg -s libxrandr-dev | grep installed)" ]; then
    sudo apt install libxrandr-dev
fi

# install required tools
if ! type curl > /dev/null; then
    sudo apt install curl
fi

if ! type jq > /dev/null; then
    sudo apt install jq
fi

if ! type make > /dev/null; then
    sudo apt install make
fi

if ! type wget > /dev/null; then
    sudo apt install wget
fi

# download source
release=$(curl -sL https://api.github.com/repos/faf0/sct/releases/latest)
url=$(printf '%s\n' "$release" | jq -r ".tarball_url")
mkdir -p $build_dir
sudo wget -O $build_dir/sct.tar.gz $url
sudo chmod 777 $build_dir/sct.tar.gz

# # build from source
tar --directory=$build_dir -xvf $build_dir/sct.tar.gz
sct_src=$(ls -d $build_dir/*/)
cd $sct_src
make
chmod 777 xsct

# install
sudo cp xsct /usr/local/bin

# clean up
cd $script_dir
sudo rm -rf $build_dir