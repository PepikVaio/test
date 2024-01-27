set -e

COLOR_USER='\e[36m'
COLOR_WARNING='\e[33m'
COLOR_SUCCESS='\e[32m'
COLOR_ERROR='\e[31m'
NOCOLOR='\e[0m'

APP_BINARY="/usr/bin/xochitl"
CACHE_DIR="/home/root/.cache/remarkable/xochitl/qmlcache/"
PATCH_URL="https://raw.githubusercontent.com/mb1986/rm-hacks/main/patches/"
ZONEINFO_DIR="/usr/share/zoneinfo/"

WGET="wget"


dir_is_empty(){
    [ -d "$1" ] && [ -z "$(ls -A "$1")" ]
}



upgrade_wget () {
    wget_path=/home/root/.local/share/rm-hacks/wget
    wget_remote=http://toltec-dev.org/thirdparty/bin/wget-v1.21.1-1
    wget_checksum=c258140f059d16d24503c62c1fdf747ca843fe4ba8fcd464a6e6bda8c3bbb6b5

    if [ -f "$wget_path" ] && ! sha256sum -c <(echo "$wget_checksum  $wget_path") > /dev/null 2>&1; then
        rm "$wget_path"
    fi

    if ! [ -f "$wget_path" ]; then
        echo "Fetching secure wget..."
        # Download and compare to hash
        mkdir -p "$(dirname "$wget_path")"
        if ! wget -q "$wget_remote" --output-document "$wget_path"; then
            echo "${COLOR_ERROR}Error: Could not fetch wget, make sure you have a stable Wi-Fi connection${NOCOLOR}"
            exit 1
        fi
    fi

    if ! sha256sum -c <(echo "$wget_checksum  $wget_path") > /dev/null 2>&1; then
        echo "${COLOR_ERROR}Error: Invalid checksum for the local wget binary${NOCOLOR}"
        exit 1
    fi

    chmod 755 "$wget_path"
    WGET="$wget_path"
}


