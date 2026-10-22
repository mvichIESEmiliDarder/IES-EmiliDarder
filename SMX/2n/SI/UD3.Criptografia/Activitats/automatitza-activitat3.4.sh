#!/usr/bin/env bash

# Guia interactiva per a l'activitat 3.4 (GPG + Netcat).
# La clau simètrica en text pla només s'utilitza amb finalitats didàctiques.

set -uo pipefail

readonly PORT=5000
readonly WORKDIR="${HOME}/activitat3.4"
readonly PUBKEY="${WORKDIR}/clau-publica.asc"
readonly PUBKEY_IN="${WORKDIR}/clau-rebuda.asc"
readonly SESSION_KEY="${WORKDIR}/clau-sessio.txt"
readonly SESSION_ENC="${WORKDIR}/clau-sessio.gpg"
readonly SESSION_IN="${WORKDIR}/clau-sessio-rebuda.gpg"
readonly SESSION_DECRYPTED="${WORKDIR}/clau-sessio-rebuda.txt"
readonly MESSAGE="${WORKDIR}/missatge.txt"
readonly MESSAGE_ENC="${WORKDIR}/missatge.gpg"
readonly MESSAGE_IN="${WORKDIR}/rebut.gpg"
readonly MESSAGE_DECRYPTED="${WORKDIR}/desxifrat.txt"

mkdir -p "$WORKDIR" || exit 1
chmod 700 "$WORKDIR" || exit 1

pause() {
    printf '\nPrem Retorn per continuar...'
    read -r _
}

need_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf 'No trobo l’ordre «%s». Instal·la-la abans de continuar.\n' "$1" >&2
        return 1
    fi
}

choose_path() {
    local path="$1" answer
    if [[ -e "$path" ]]; then
        printf 'El fitxer ja existeix: %s\n' "$path" >&2
        read -r -p 'El vols substituir? [y/N] ' answer
        case "$answer" in
            y|Y|s|S|sí|Sí|SI|si) rm -f -- "$path" || return 1 ;;
            *) printf 'Acció cancel·lada; no s’ha modificat el fitxer.\n' >&2; return 1 ;;
        esac
    fi
    printf '%s\n' "$path"
}

listen_file() {
    local destination="$1" syntax path
    need_command nc || return 1
    path=$(choose_path "$destination") || return 1

    printf '\nEscoltant al port TCP %s. Ara l’altra persona ha de triar l’opció d’enviar.\n' "$PORT"
    printf 'Mantén aquesta finestra oberta fins que acabi la transferència.\n'
    printf 'Sintaxi de nc: 1) nc -l -p %s (habitual a Linux)  2) nc -l %s\n' "$PORT" "$PORT"
    read -r -p 'Tria 1 o 2 [1]: ' syntax
    case "$syntax" in
        2) nc -l "$PORT" > "$path" ;;
        *) nc -l -p "$PORT" > "$path" ;;
    esac
    local result=$?
    if (( result != 0 )); then
        rm -f -- "$path"
        printf 'La recepció amb nc ha fallat. Comprova la sintaxi i el tallafoc.\n' >&2
        return 1
    fi
    if [[ ! -s "$path" ]]; then
        rm -f -- "$path"
        printf 'No s’ha rebut cap dada.\n' >&2
        return 1
    fi
    chmod 600 "$path"
    printf 'Fitxer rebut: %s\n' "$path"
}

send_file() {
    local source="$1" address
    need_command nc || return 1
    if [[ ! -f "$source" || ! -r "$source" ]]; then
        printf 'No trobo el fitxer preparat: %s\n' "$source" >&2
        return 1
    fi
    read -r -p 'IP o nom de l’ordinador receptor: ' address
    if [[ -z "$address" || "$address" == *[[:space:]]* ]]; then
        printf 'Adreça no vàlida.\n' >&2
        return 1
    fi
    printf 'Enviant %s a %s:%s. Assegura’t que l’altra persona ja està escoltant.\n' \
        "${source##*/}" "$address" "$PORT"
    nc "$address" "$PORT" < "$source"
    local result=$?
    if (( result != 0 )); then
        printf 'La connexió o l’enviament amb nc ha fallat.\n' >&2
        return 1
    fi
    printf 'Enviament acabat.\n'
}

prepare_keys() {
    need_command gpg || return 1
    printf 'Es crearà una parella de claus GPG. No comparteixis la clau privada ni la frase de pas.\n'
    gpg --full-generate-key || return 1
    printf '\nClaus disponibles al teu anell GPG:\n'
    gpg --list-keys
}

send_public_key() {
    local identity path
    need_command gpg || return 1
    read -r -p 'Identificador o correu de la teva clau GPG: ' identity
    [[ -n "$identity" ]] || { printf 'Cal indicar un identificador.\n' >&2; return 1; }
    path=$(choose_path "$PUBKEY") || return 1
    if ! gpg --armor --export "$identity" > "$path"; then
        rm -f -- "$path"
        printf 'No s’ha pogut exportar la clau. Revisa l’identificador.\n' >&2
        return 1
    fi
    if [[ ! -s "$path" ]]; then
        rm -f -- "$path"
        printf 'GPG no ha trobat cap clau pública per a «%s».\n' "$identity" >&2
        return 1
    fi
    chmod 600 "$path"
    send_file "$path"
}

import_public_key() {
    need_command gpg || return 1
    if [[ ! -s "$PUBKEY_IN" ]]; then
        printf 'Primer rep la clau pública de l’altra persona amb l’opció 2.\n' >&2
        return 1
    fi
    gpg --import "$PUBKEY_IN" || return 1
    printf '\nCompara presencialment la petjada completa amb l’altra persona:\n'
    gpg --fingerprint
}

create_send_session_key() {
    local recipient key_path encrypted_path
    need_command gpg || return 1
    need_command tr || return 1
    read -r -p 'Identificador/correu GPG de l’ordinador A (propietari de la clau pública importada): ' recipient
    [[ -n "$recipient" ]] || { printf 'Cal indicar el destinatari.\n' >&2; return 1; }
    key_path=$(choose_path "$SESSION_KEY") || return 1
    encrypted_path=$(choose_path "$SESSION_ENC") || return 1

    # Genera 32 caràcters alfanumèrics. umask limita l’accés al fitxer.
    (umask 077; LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | dd bs=32 count=1 status=none > "$key_path")
    if [[ ! -s "$key_path" ]]; then
        rm -f -- "$key_path" "$encrypted_path"
        printf 'No s’ha pogut generar la clau simètrica.\n' >&2
        return 1
    fi
    chmod 600 "$key_path"
    printf '\nLa clau simètrica només es guarda en aquest ordinador. No l’enviïs en text pla.\n'
    if ! gpg --armor --encrypt --recipient "$recipient" --output "$encrypted_path" "$key_path"; then
        rm -f -- "$encrypted_path"
        return 1
    fi
    chmod 600 "$encrypted_path"
    send_file "$encrypted_path"
}

receive_session_key() {
    need_command gpg || return 1
    listen_file "$SESSION_IN" || return 1
    local output
    output=$(choose_path "$SESSION_DECRYPTED") || return 1
    if ! gpg --output "$output" --decrypt "$SESSION_IN"; then
        rm -f -- "$output"
        return 1
    fi
    chmod 600 "$output"
    printf 'Clau simètrica desxifrada a %s. No la comparteixis en text pla.\n' "$output"
    printf 'Per comparar-la amb B, compareu presencialment els hash SHA-256 sense revelar-ne el contingut:\n'
    sha256sum "$output"
}

send_encrypted_message() {
    local key message_path encrypted_path
    need_command gpg || return 1
    if [[ -s "$SESSION_KEY" ]]; then
        key="$SESSION_KEY"
    elif [[ -s "$SESSION_DECRYPTED" ]]; then
        key="$SESSION_DECRYPTED"
    else
        printf 'No trobo la clau simètrica. Crea-la o rep-la abans d’enviar missatges.\n' >&2
        return 1
    fi
    message_path=$(choose_path "$MESSAGE") || return 1
    encrypted_path=$(choose_path "$MESSAGE_ENC") || return 1
    printf 'Escriu el missatge (una línia):\n> '
    IFS= read -r message || return 1
    (umask 077; printf '%s\n' "$message" > "$message_path")
    chmod 600 "$message_path"
    if ! gpg --batch --pinentry-mode loopback --passphrase-file "$key" \
        --armor --symmetric --output "$encrypted_path" "$message_path"; then
        rm -f -- "$encrypted_path"
        return 1
    fi
    chmod 600 "$encrypted_path"
    send_file "$encrypted_path"
}

receive_encrypted_message() {
    local key output
    need_command gpg || return 1
    if [[ -s "$SESSION_KEY" ]]; then
        key="$SESSION_KEY"
    elif [[ -s "$SESSION_DECRYPTED" ]]; then
        key="$SESSION_DECRYPTED"
    else
        printf 'No trobo la clau simètrica. Rep-la abans de desxifrar missatges.\n' >&2
        return 1
    fi
    listen_file "$MESSAGE_IN" || return 1
    output=$(choose_path "$MESSAGE_DECRYPTED") || return 1
    if ! gpg --batch --pinentry-mode loopback --passphrase-file "$key" \
        --output "$output" --decrypt "$MESSAGE_IN"; then
        rm -f -- "$output"
        return 1
    fi
    chmod 600 "$output"
    printf '\nMissatge desxifrat:\n'
    cat -- "$output"
}

receive_public_key() {
    listen_file "$PUBKEY_IN"
}

send_prepared_file() {
    local selection source
    printf 'Quin fitxer vols enviar?\n'
    printf '  1) Clau pública exportada\n  2) Clau simètrica xifrada\n  3) Missatge xifrat\n'
    read -r -p 'Opció: ' selection
    case "$selection" in
        1) source="$PUBKEY" ;;
        2) source="$SESSION_ENC" ;;
        3) source="$MESSAGE_ENC" ;;
        *) printf 'Opció no vàlida.\n'; return 1 ;;
    esac
    send_file "$source"
}

while true; do
    cat <<'MENU'

=== Activitat 3.4: xifratge híbrid amb GPG i nc ===
Fitxers de pràctica: ~/activitat3.4/   |   Port TCP: 5000
 1. Preparar claus GPG
 2. Escoltar i rebre un fitxer
 3. Connectar i enviar un fitxer preparat
 4. Exportar i enviar la clau pública
 5. Importar la clau pública rebuda i verificar-ne la petjada
 6. Crear i enviar la clau simètrica xifrada per a A
 7. Rebre i desxifrar la clau simètrica
 8. Escriure, xifrar i enviar un missatge
 9. Rebre i desxifrar un missatge
 0. Sortir
MENU
    read -r -p 'Tria una opció: ' option
    case "$option" in
        1) prepare_keys ;;
        2) printf 'Què rebràs? 1) clau pública  2) clau simètrica xifrada  3) missatge xifrat\n'
           read -r -p 'Opció: ' kind
           case "$kind" in
               1) receive_public_key ;;
               2) listen_file "$SESSION_IN" ;;
               3) listen_file "$MESSAGE_IN" ;;
               *) printf 'Opció no vàlida.\n' ;;
           esac ;;
        3) send_prepared_file ;;
        4) send_public_key ;;
        5) import_public_key ;;
        6) create_send_session_key ;;
        7) receive_session_key ;;
        8) send_encrypted_message ;;
        9) receive_encrypted_message ;;
        0) printf 'Fins aviat.\n'; exit 0 ;;
        *) printf 'Opció no vàlida.\n' ;;
    esac
    pause
done
