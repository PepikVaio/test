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

    copy
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
    echo -n "Zadejte název souboru pro novou sleepscreen:"
    read file_New
    

    if [ -e "$folder_Backup/$file_Backup" ]; then
        echo "Soubor $file_Backup nalezen ve složce $folder_Backup"
    else
        echo "Soubor $file_Backup nenalezen ve složce $folder_Backup"

        mkdir -p "$folder_Backup"
        cp "$folder_Original/$file_Original" "$folder_Backup/$file_Backup"
        echo "Soubor $file_Original zálohován do $folder_Backup s názvem $file_Backup"
        
        cp "$file_New" "$folder_Original/$file_Original"
        echo "Nový sleepscreen nahrán"
    fi
}

copy() {
    # Original
    folder_Original="/usr/share/remarkable"
    file_Original="suspended.png"

    # Backup
    folder_Backup="/home/root/.local/share/Wajsar_Josef/Screen_Backup"
    file_Backup="suspended_backup.png"

    # New
    #echo -n "Vyber soubor ze svého iPhone:"
    #read file_New

    echo "test01"
    file_New="https://www.icloud.com/attachment/?u=https%3A%2F%2Fcvws.icloud-content.com%2FB%2FAUyT7c-bMz9n4-HDKAisnd5LNbinAXeE6AnvDMzQozso6Ni5btQIYGOe%2F%24%7Bf%7D%3Fo%3DArKlc12SB5VEogkABNx16T3CtvdqxBBEhCF9rmk91dpU%26v%3D1%26x%3D3%26a%3DCAogaxiiuq0VtwJt6WvAb1_GXTmZUTIUCz9hPb1o_W_NrCUSaxD4yvGL1TEY-Nrs394xIgEAUgRLNbinWgQIYGOeaiXeCY1RCzisdXNZWJlSBHyvNayyR7OEebG3F51u6CUqjony7HE0ciVKA2PMys4nLh15B4rNQy0braoJSj3vNOQCMgmqXodQflJ3l8vq%26e%3D1709061123%26fl%3D%26r%3D9ECE8CC2-BBC3-4340-9014-6CD623F01E04-1%26k%3D%24%7Buk%7D%26ckc%3Dcom.apple.clouddocs%26ckz%3Dcom.apple.CloudDocs%26p%3D105%26s%3DVuzg9BVezvzsY5ung8qeuwCP7fc&uk=ZzYURIh9ENZvNT2spuVQDg&f=Test.png&sz=433874"

    # Přesunutí souboru na reMarkable
    wget -O "$folder_Backup/$file_Backup" "$file_New"

}

copy2(){
    # Heslo pro připojení k reMarkable
    remarkable_Password="Wcx9c0w6xU"

    # Zadejte cestu k souboru na mobilu
    echo -n "Zadejte cestu k souboru pro nový sleepscreen na mobilu:"
    read file_New

    # Přenos souboru z mobilu na reMarkable
    sshpass -p "$remarkable_Password" scp "$file_New" root@10.0.1.14:/home/root/.local/share/
}

copy3() {
    # Heslo pro připojení k reMarkable
    remarkable_Password="YourPasswordHere"

    # Zadejte cestu k souboru na mobilu
    echo -n "Zadejte cestu k souboru:"
    read file_New

    # Přenos souboru z mobilu na reMarkable pomocí expect
    expect -c "
        spawn scp $file_New root@10.0.1.14:/home/root/.local/share/
        expect {
            \"*assword:\" {
                send \"$remarkable_Password\n\"
                interact
            }
            eof {
                exit
            }
        }
    "
}


copy4() {
    # Adresa IP nebo název hostitele reMarkable
    remarkable_IP="10.0.1.14"
    remarkable_User="root"

    # Cílová cesta a název souboru na reMarkable
    remote_path="/usr/share/remarkable/"
    remote_file="novy_soubor.png"

    # Nový soubor na lokálním zařízení
    echo -n "Zadejte cestu:"
    read local_file

    # Kopírování souboru na reMarkable
    scp "$local_file" "$remarkable_User@$remarkable_IP:$remote_path$remote_file"

    echo "Soubor byl úspěšně zkopírován na reMarkable a provedena synchronizace."
}



upgrade_wget
