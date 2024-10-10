#!/usr/bin/env sh

term_dir=$(pwd)
script_dir=$(dirname $(realpath -s "$0"))
user=$(whoami)
install_dir=/opt/magicavoxel

# install required tools
if ! type curl > /dev/null; then
    sudo apt install curl
fi

if ! type jq > /dev/null; then
    sudo apt install jq
fi

if ! type wget > /dev/null; then
    sudo apt install wget
fi

# download binary
sudo wget -P $install_dir https://github.com/ephtracy/ephtracy.github.io/releases/download/0.99.7/MagicaVoxel-0.99.7.1-win64.zip
cd $install_dir
sudo unzip $install_dir/MagicaVoxel-0.99.7.1-win64.zip

# add shortcut
sudo cp $script_dir/magicavoxel.png $install_dir
sudo cp $script_dir/magicavoxel.desktop $install_dir
sudo ln $install_dir/magicavoxel.desktop /usr/share/applications/magicavoxel.desktop