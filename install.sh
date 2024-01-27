set -e

COLOR_USER='\e[36m'
COLOR_WARNING='\e[33m'
COLOR_SUCCESS='\e[32m'
COLOR_ERROR='\e[31m'
NOCOLOR='\e[0m'

WGET="wget"

download() {
    file_url=$1
    output_file=$2

    echo -e "${COLOR_SUCCESS}Stahování souboru: $output_file${NOCOLOR}"

    $WGET --content-disposition "$file_url"

    # Kontrola úspěšnosti stahování
    if [ $? -eq 0 ]; then
        echo -e "${COLOR_SUCCESS}Soubor byl úspěšně stažen: $output_file${NOCOLOR}"
    else
        echo -e "${COLOR_ERROR}Chyba při stahování souboru: $output_file${NOCOLOR}"
    fi
}

echo ""
echo -e "${COLOR_USER} rM Hacks Installer ${NOCOLOR}"
echo -e "${COLOR_USER}--------------------${NOCOLOR}"
echo ""

if [[ "$1" = "download" && -n "$2" && -n "$3" ]]; then

    file_url=$2
    output_file=$3

    download "$file_url" "$output_file"

elif [[ "$1" = "patch" && -n "$2" || -z "$1" ]]; then

    patch_version_arg=$2
    # Zde pokračuje váš původní kód pro instalaci patche...

else

    echo "usage: install.sh [download <file_url> <output_file> | patch <version> | uninstall]"
    exit 1

fi

# Zbytek skriptu...

exit 0
