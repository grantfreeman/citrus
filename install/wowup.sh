# #!/usr/bin/env sh

script_dir=$(dirname $(realpath -s "$0"))
user=$(whoami)
wowup_dir=/home/$user/games/wowup

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

# download appimage
release=$(curl -sL https://api.github.com/repos/wowup/wowup/releases/latest)
printf '%s\n' "$release" | jq -c ".assets.[]" | while read asset
do
    if printf '%s\n' "$asset" | jq -r ".name" | grep -q ".*.AppImage"
    then
        name=$(printf '%s\n' "$asset" | jq -r ".name")
        url=$(printf '%s\n' "$asset" | jq -r ".browser_download_url")
        wget -P $wowup_dir $url
        chmod 755 $wowup_dir/$name
        break
    fi
done

# move relevant files
cp $script_dir/wowup.desktop $wowup_dir
cp $script_dir/wowup.png $wowup_dir

# update freedesktop variables and link
app=$(find $wowup_dir -name "*.AppImage")
app=${app##*/}
sed -i "s|<USER>|${user}|g" $wowup_dir/wowup.desktop
sed -i "s|<APP>|${app}|g" $wowup_dir/wowup.desktop
ln $wowup_dir/wowup.desktop ~/.local/share/applications/wowup.desktop