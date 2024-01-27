# Příkaz v shell skriptu, který říká shellu, aby okamžitě ukončil své vykonávání, pokud některý z příkazů vrátí nenulový návratový kód (exit status).
# Není-li set -e nastaveno, shell bude pokračovat ve vykonávání příkazů i po chybách, což může vést k nekonzistentním nebo neočekávaným výsledkům.
set -e

# COLOR_USER může být použito pro zvýraznění uživatelského vstupu.
COLOR_USER='\e[36m'
# COLOR_WARNING pro zvýraznění varování.
COLOR_WARNING='\e[33m'
# COLOR_SUCCESS pro zvýraznění úspěšné operace.
COLOR_SUCCESS='\e[32m'
# COLOR_ERROR pro zvýraznění chybového výstupu.
COLOR_ERROR='\e[31m'
# NOCOLOR pro návrat k normální barvě textu.
NOCOLOR='\e[0m'

# APP_BINARY obsahuje cestu k binárnímu souboru xochitl. Pravděpodobně se jedná o hlavní aplikaci na zařízení Remarkable.
APP_BINARY="/usr/bin/xochitl"
# CACHE_DIR je cesta k adresáři, který slouží jako mezipaměť pro různé soubory související s xochitl. Zdá se, že se zde uchovávají některé dočasné soubory.
CACHE_DIR="/home/root/.cache/remarkable/xochitl/qmlcache/"
# PATCH_URL obsahuje URL, ze které je možné stahovat patche, které budou aplikovány na xochitl.
PATCH_URL="https://raw.githubusercontent.com/mb1986/rm-hacks/main/patches/"
# ZONEINFO_DIR obsahuje cestu k adresáři, kde jsou ukládány informace o časových zónách.
ZONEINFO_DIR="/usr/share/zoneinfo/"

# Tato řádka vytváří proměnnou WGET a přiřazuje jí hodnotu "wget".
# Tímto způsobem je vytvořena proměnná, která obsahuje název příkazu (v tomto případě "wget").
# Tuto proměnnou můžete poté použít v kódu skriptu, aby byl váš skript flexibilnější a lépe spravovatelný.
WGET="wget"

# Pro stahování souborů v reMarkable.
# reMarkable má staré wget, které nepodporuje SSL, toto chybu opraví.
upgrade_wget() {
    wget_path=/home/root/.local/share/test/wget
    wget_remote=http://toltec-dev.org/thirdparty/bin/wget-v1.21.1-1
    wget_checksum=c258140f059d16d24503c62c1fdf747ca843fe4ba8fcd464a6e6bda8c3bbb6b5

    if [ -f "$wget_path" ] && ! sha256sum -c <(echo "$wget_checksum  $wget_path") > /dev/null 2>&1; then
        rm "$wget_path"
    fi

    if ! [ -f "$wget_path" ]; then
        echo -e "Fetching secure wget..."
        # Download and compare to hash
        mkdir -p "$(dirname "$wget_path")"
        if ! "$WGET" -q "$wget_remote" --output-document "$wget_path"; then
            echo -e "${COLOR_ERROR}Error: Could not fetch wget, make sure you have a stable Wi-Fi connection${NOCOLOR}"
            exit 1
        fi
    fi

    if ! sha256sum -c <(echo "$wget_checksum  $wget_path") > /dev/null 2>&1; then
        echo -e "${COLOR_ERROR}Error: Invalid checksum for the local wget binary${NOCOLOR}"
        exit 1
    fi

    chmod 755 "$wget_path"
    WGET="$wget_path"
}

upgrade_wget
