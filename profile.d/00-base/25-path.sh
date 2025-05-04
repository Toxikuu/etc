# /etc/profile.d/00-base/25-path.sh

# A default path (/usr/bin) was already set in 00-base/00-base.sh. This script
# defines some helper functions and extra paths.

pathremove() {
    local IFS=':'
    local NEWPATH
    local DIR
    local PATHVARIABLE=${2:-PATH}
    for DIR in ${!PATHVARIABLE} ; do
        if [ "$DIR" != "$1" ] ; then
            NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
        fi
    done
    export "$PATHVARIABLE"="$NEWPATH"
}

pathprepend() {
    pathremove "$1" "$2"
    local PATHVARIABLE=${2:-PATH}
    export "$PATHVARIABLE"="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend() {
    pathremove "$1" "$2"
    local PATHVARIABLE=${2:-PATH}
    export "$PATHVARIABLE"="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

export -f pathremove pathprepend pathappend

if [ $EUID -eq 0 ]; then
    pathappend /usr/sbin
fi
