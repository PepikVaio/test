set -e

COLOR_USER='\e[36m'
COLOR_WARNING='\e[33m'
COLOR_SUCCESS='\e[32m'
COLOR_ERROR='\e[31m'
NOCOLOR='\e[0m'

WGET="wget"

upgrade_wget() {
    wget_path=/home/root/.local/share/test/wget
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

download() {
    file_url="https://raw.githubusercontent.com/PepikVaio/reMarkable_re-Planner/main/Template/(en)%20re-Planner%202024%20(Lite).pdf"
    output_file="test.pdf"

    echo "Stahování souboru: $output_file"

    $WGET "$file_url"

    if [ $? -eq 0 ]; then
        echo "Soubor byl úspěšně stažen: $output_file"
    else
        echo "Chyba při stahování souboru: $output_file"
    fi
}
