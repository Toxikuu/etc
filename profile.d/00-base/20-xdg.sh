# /etc/profile.d/00-base/20-xdg.sh

# Set up basic XDG variables
export XDG_DATA_DIRS=${XDG_DATA_DIRS:-/usr/share}
export XDG_CONFIG_DIRS=${XDG_CONFIG_DIRS:-/etc/xdg}
export XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-/tmp/xdg-$USER}

# Set up other XDG variables
export XDG_CACHE_DIR=${XDG_CACHE_DIR:-~/.cache}
export XDG_DOCUMENTS_DIR=${XDG_DOCUMENTS_DIR:-~/docs}
export XDG_DOWNLOAD_DIR=${XDG_DOWNLOAD_DIR:-~/dls}
export XDG_MUSIC_DIR=${XDG_MUSIC_DIR:-~/music}
export XDG_PICTURES_DIR=${XDG_PICTURES_DIR:-~/pics}
export XDG_VIDEOS_DIR=${XDG_VIDEOS_DIR:-~/vids}
export XDG_DESKTOP_DIR=${XDG_DESKTOP_DIR:-/dev/null} # ~/Desktop annoys me
