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

# Tato řádka vytváří proměnnou WGET a přiřazuje jí hodnotu "wget".
# Tímto způsobem je vytvořena proměnná, která obsahuje název příkazu (v tomto případě "wget").
# Tuto proměnnou můžete poté použít v kódu skriptu, aby byl váš skript flexibilnější a lépe spravovatelný.
WGET="wget"

# Pro stahování souborů v reMarkable.
# reMarkable má staré wget, které nepodporuje STL, toto chybu opraví.
upgrade_wget() {
    wget_path=/home/root/.local/share/Wajsar_Josef/wget
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

suspended() {
    # Original
    folder_Original="/usr/share/remarkable"
    file_Original="suspended.png"
    # Backup
    folder_Backup="/home/root/.local/share/Wajsar_Josef/Screen_Backup"
    file_Backup="suspended_backup.png"
    # New

    if [ -e "$folder_Backup/$file_Backup" ]; then
        echo "Soubor $file_Backup nalezen ve složce $folder_Backup"
    else
        echo "Soubor $file_Backup nenalezen ve složce $folder_Backup"

        mkdir -p "$folder_Backup"
        cp "$folder_Original/$file_Original" "$folder_Backup/$file_Backup"
        echo "Soubor $file_Original zálohován do $folder_Backup s názvem $file_Backup"
        
        echo -n "Zadejte název souboru pro novou sleepscreen: "
        read file_New

        cp "$file_New" "$folder_Original/$file_Original"

        
    fi
}




suspended

