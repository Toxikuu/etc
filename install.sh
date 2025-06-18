#!/usr/bin/env bash

set -eu

# https://stackoverflow.com/questions/59895/how-do-i-get-the-directory-where-a-bash-script-is-located-from-within-the-script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pushd "$SCRIPT_DIR" &>/dev/null

# Adjust PartUUIDs and delete a note
echo "Adjusting fstab"
sed \
    -e "s,|ROOT_PARTUUID|,$ROOT_PARTUUID," \
    -e "s,|ESP_PARTUUID|,$ESP_PARTUUID," \
    -e 3d \
    -i fstab

# Adjust hostname
echo "Adjusting hostname"
sed "s,|HOSTNAME|,$HOSTNAME,g" -i hostname hosts

# Install stuff
echo "Installing stuff"
find . -mindepth 1 -maxdepth 1          \
        ! -name '.*' -a                 \
        ! -name 'install.sh' -a         \
        ! -name 'LICENSE' -a            \
        ! -name 'README.md' -exec       \
    install -vDm644 {} -t "${D-}/etc"   \;
cp -af "profile.d" "${D-}/etc/"

popd &>/dev/null
