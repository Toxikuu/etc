# /etc/profile.d/05-lfs/25-convenience.sh
# Defines some LFS niceties


# Convenience function for tarball extraction
xt() {

    local dir=$(tar tf "$1" | head -n1 | cut -d/ -f1)

    [ -z "$dir" ] && { echo "You're gonna have to do this one manually" >&2; return 1; }
    tar xf "$1"   || { echo "Failed to extract $1" >&2; return 1; }
    cd "$dir"     || { echo "Failed to enter $dir" >&2; return 1; }

}


# Helper function for mounting
mount_if_needed() {

    local mount_target="${!#}"
    if mountpoint -q "$mount_target"; then
        echo "Skipping $mount_target as it's already mounted"
    else
        mount "$@" || return 1
    fi

}


# Convenience function for chrooting into LFS
lfschroot() {

    if [ $EUID -ne 0 ]; then
        echo "Run this as root" >&2
        return 1
    fi

    if [ -z "$LFS" ]; then
        echo "\$LFS is unset" >&2
        return 1
    fi

    if [ -z "$LFS_PART" ]; then
        echo "\$LFS_PART is unset" >&2
        return 1
    fi

    if [ -z "$EFI_PART" ]; then
        echo "\$EFI_PART is unset" >&2
        echo "Skipping ESP" >&2
    fi

    mount_if_needed -v PARTUUID="$LFS_PART" "$LFS"
    mkdir -pv "$LFS/"{dev,proc,sys,run}

    if [ -n "$EFI_PART" ]; then
        mkdir -pv "$LFS/efi"
        mount_if_needed -v PARTUUID="$EFI_PART" "$LFS/efi"
    fi

    mount_if_needed -v --bind /dev  "$LFS/dev"
    mount_if_needed -vt devpts devpts -o gid=5,mode=0620 "$LFS/dev/pts"
    mount_if_needed -vt proc proc   "$LFS/proc"
    mount_if_needed -vt sysfs sysfs "$LFS/sys"
    mount_if_needed -vt tmpfs tmpfs "$LFS/run"

    if [ -h $LFS/dev/shm ]; then
        install -vdm 1777 "$LFS$(realpath /dev/shm)"
    else
        mount_if_needed -vt tmpfs -o nosuid,nodev tmpfs "$LFS/dev/shm"
    fi

    local PFX="\[\e[37;1m\](lfs)\[\e[0m\]"
    chroot "$LFS" /usr/bin/env -i   \
        HOME="/root"                \
        TERM="xterm-256color"       \
        PATH="/usr/bin:/usr/sbin"   \
        MAKEFLAGS="${MAKEFLAGS}"    \
        TESTSUITEFLAGS="$MAKEFLAGS" \
        PS1="$PFX $PS1"             \
        /usr/bin/bash --login

    umount "$LFS/dev/shm" || true
    umount "$LFS/dev/pts"
    umount "$LFS/"{sys,proc,run,dev}

    if [ -n "$EFI_PART" ]; then
        umount "$LFS/efi"
    fi

    umount -R "$LFS"

    echo "Exited LFS chroot"

}


# Convenience function for recursively stripping files
rsu() {

    # This should only be run outside of chroot lest strip or something it links
    # to be affected. For this reason, a safety check is included.

    if ! lsblk | grep "$LFS" &>/dev/null; then
        echo "Couldn't find '$LFS' in lslbk output!"
        return 1
    fi

    find "${1:-.}" -type f -executable -exec file {} + |
        grep 'not stripped' |
        cut -d: -f1         |
        xargs strip --strip-unneeded

}


# Helper function to check whether configure contains an option
c_c() {

    if grep -F -- "${1%=*}" "${CP:?}/configure" &>/dev/null; then
        echo "$1"
    fi

}


# Convenience function for calling ./configure
cfg() {

    if [ -f ./configure ]; then
        CP=.
    elif [ -f ../configure ]; then
        CP=..
    else
        die "Couldn't find configure"
    fi

    # Generate configure options based on what configure supports
    local _default_cfg_opts=(
        "$(c_c --mandir=/usr/share/man)"
        "$(c_c --sbindir=/usr/bin)"
        "$(c_c --bindir=/usr/bin)"
        "$(c_c --sysconfdir=/etc)"
        "$(c_c --disable-static)"
        "$(c_c --enable-shared)"
        "$(c_c --disable-rpath)"
        "$(c_c --disable-nls)"
        --prefix=/usr
    )

    echo "Using default config options: ${_default_cfg_opts[*]}"

    "${CP:?}/configure" "${_default_cfg_opts[@]}" "${_cfg[@]}"

}


export -f xt cfg rsu
