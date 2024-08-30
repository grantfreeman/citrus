#!/usr/bin/env sh

script_dir=$(dirname $(realpath -s "$0"))
user=$(whoami)
install_dir=/opt/cortile

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
release=$(curl -sL https://api.github.com/repos/leukipp/cortile/releases/latest)
printf '%s\n' "$release" | jq -c ".assets.[]" | while read asset
do
    if printf '%s\n' "$asset" | jq -r ".name" | grep -q ".*linux_amd64.tar.gz"
    then
        name=$(printf '%s\n' "$asset" | jq -r ".name")
        url=$(printf '%s\n' "$asset" | jq -r ".browser_download_url")
        sudo wget -P $install_dir $url
        sudo tar --directory=$install_dir -xvf $install_dir/$name
        sudo rm $install_dir/$name
        sudo chmod 755 $install_dir/cortile
        break
    fi
done

# enable cortile service
mkdir -p /home/$user/.config/systemd/user
cp $script_dir/cortile.service /home/$user/.config/systemd/user
systemctl --user daemon-reload
systemctl --user enable cortile.service
systemctl --user start cortile.service
