#!/usr/bin/env sh

script_dir=$(dirname $(realpath -s "$0"))
user=$(whoami)
install_dir=/home/$user/games/gameboy

# install required tools
if ! type curl > /dev/null; then
    sudo apt install curl
fi

if ! type wget > /dev/null; then
    sudo apt install wget
fi

# download binary
found=false
release=$(curl -sL https://api.github.com/repos/mgba-emu/mgba/releases/latest)
assets=$(printf '%s\n' "$release" | jq -c ".assets.[]")
for asset in $assets
do
    if printf '%s\n' "$asset" | jq -r ".name" | grep -q ".*appimage$"
    then
        filename=$(printf '%s\n' "$asset" | jq -r ".name")
        url=$(printf '%s\n' "$asset" | jq -r ".browser_download_url")
        wget -P $script_dir $url
        chmod 775 $filename
        found=true
        break
    fi
done

if [ "$found" = false ]
then
    printf 'unable to locate appimage for latest mgba release'
fi

# move to install location
mkdir -p $install_dir
mkdir $install_dir/roms
mv $script_dir/$filename $install_dir
cp $script_dir/mgba.desktop $install_dir
cp $script_dir/mgba.png $install_dir

# update freedesktop variables and link
sed -i "s|<USER>|${user}|g" $install_dir/mgba.desktop
sed -i "s|<APP>|${filename}|g" $install_dir/mgba.desktop
ln $install_dir/mgba.desktop ~/.local/share/applications/mgba.desktop

printf 'mGBA install complete.\n'