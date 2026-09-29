# Comandes útils d'Ubuntu

> Guia ràpida de comandes habituals d'Ubuntu i GNU/Linux, pensada per
> consultar-la des de **GitHub** o **Obsidian**.

## Índex

-   [1. Ajuda i informació del
    sistema](#1-ajuda-i-informació-del-sistema)
-   [2. Navegació pel sistema de
    fitxers](#2-navegació-pel-sistema-de-fitxers)
-   [3. Fitxers i directoris](#3-fitxers-i-directoris)
-   [4. Visualitzar i editar fitxers de
    text](#4-visualitzar-i-editar-fitxers-de-text)
-   [5. Cerca de fitxers i contingut](#5-cerca-de-fitxers-i-contingut)
-   [6. Redireccions i canonades](#6-redireccions-i-canonades)
-   [7. Usuaris, grups i permisos](#7-usuaris-grups-i-permisos)
-   [8. Processos i recursos](#8-processos-i-recursos)
-   [9. Serveis amb systemd](#9-serveis-amb-systemd)
-   [10. Xarxa](#10-xarxa)
-   [11. Discs, particions i espai](#11-discs-particions-i-espai)
-   [12. Compressió i arxius](#12-compressió-i-arxius)
-   [13. SSH i còpia remota](#13-ssh-i-còpia-remota)
-   [14. Logs i diagnòstic](#14-logs-i-diagnòstic)
-   [15. Informació de maquinari](#15-informació-de-maquinari)
-   [16. Instal·lació d'aplicacions](#16-installació-daplicacions)
-   [17. APT i paquets DEB](#17-apt-i-paquets-deb)
-   [18. Snap](#18-snap)
-   [19. Flatpak](#19-flatpak)
-   [20. AppImage](#20-appimage)
-   [21. Comparativa dels sistemes
    d'instal·lació](#21-comparativa-dels-sistemes-dinstallació)
-   [22. Comandes especialment útils](#22-comandes-especialment-útils)

------------------------------------------------------------------------

## 1. Ajuda i informació del sistema

### `man` --- Manual d'una comanda

``` bash
man ls
man chmod
```

Prem `q` per sortir del manual.

### `--help` --- Ajuda ràpida

``` bash
ls --help
ip --help
```

### `apropos` --- Cercar comandes per descripció

``` bash
apropos network
apropos partition
```

### Informació bàsica del sistema

``` bash
uname -a
hostname
hostnamectl
lsb_release -a
cat /etc/os-release
```

### Data i hora

``` bash
date
timedatectl
```

### Historial de comandes

``` bash
history
history | grep ssh
```

Netejar la pantalla:

``` bash
clear
```

Dreceres molt útils del terminal:

-   `Ctrl + C`: interromp la comanda actual.
-   `Ctrl + L`: neteja la pantalla.
-   `Ctrl + R`: cerca una comanda anterior.
-   `Tab`: autocompleta noms de fitxers i comandes.
-   `↑` / `↓`: recorre l'historial de comandes.

------------------------------------------------------------------------

## 2. Navegació pel sistema de fitxers

### `pwd` --- Directori actual

``` bash
pwd
```

### `ls` --- Llistar contingut

``` bash
ls
ls -l
ls -la
ls -lh
```

Opcions habituals:

  Opció   Funció
  ------- ------------------------------------
  `-l`    Format detallat
  `-a`    Inclou fitxers ocults
  `-h`    Mides llegibles (`KB`, `MB`, `GB`)
  `-R`    Llistat recursiu

Exemple:

``` bash
ls -lah
```

### `cd` --- Canviar de directori

``` bash
cd /etc
cd ..
cd ~
cd -
```

-   `..` → directori superior.
-   `~` → directori personal.
-   `-` → directori anterior.

### `tree` --- Veure l'arbre de directoris

``` bash
tree
tree -L 2
```

Pot ser necessari instal·lar-lo:

``` bash
sudo apt install tree
```

------------------------------------------------------------------------

## 3. Fitxers i directoris

### Crear

``` bash
touch fitxer.txt
mkdir documents
mkdir -p projecte/css/img
```

### Copiar

``` bash
cp origen.txt copia.txt
cp fitxer.txt /tmp/
cp -r carpeta/ copia_carpeta/
```

### Moure o reanomenar

``` bash
mv fitxer.txt /tmp/
mv antic.txt nou.txt
```

### Eliminar

``` bash
rm fitxer.txt
rm -r carpeta/
rm -rf carpeta/
```

> \[!WARNING\] `rm -rf` elimina recursivament sense demanar confirmació.
> Empra'l amb molta cura, especialment amb `sudo`.

### Enllaços

Enllaç simbòlic:

``` bash
ln -s /ruta/original enllac
```

Veure on apunta:

``` bash
readlink -f enllac
```

### Informació d'un fitxer

``` bash
file document.pdf
stat document.pdf
```

------------------------------------------------------------------------

## 4. Visualitzar i editar fitxers de text

### Mostrar contingut

``` bash
cat fitxer.txt
less fitxer.txt
head fitxer.txt
tail fitxer.txt
```

Primeres 20 línies:

``` bash
head -n 20 fitxer.txt
```

Últimes 20 línies:

``` bash
tail -n 20 fitxer.txt
```

Seguir un fitxer que va creixent, especialment útil per a logs:

``` bash
tail -f /var/log/syslog
```

### Editors de terminal

Editor senzill:

``` bash
nano fitxer.txt
```

Editor avançat:

``` bash
vim fitxer.txt
```

------------------------------------------------------------------------

## 5. Cerca de fitxers i contingut

### `find` --- Cercar fitxers

``` bash
find . -name "*.txt"
find /home -name "document.pdf"
```

Cercar directoris:

``` bash
find . -type d -name "projecte"
```

Cercar fitxers modificats durant les darreres 24 hores:

``` bash
find . -type f -mtime -1
```

### `grep` --- Cercar text

``` bash
grep "error" fitxer.log
grep -i "error" fitxer.log
grep -n "error" fitxer.log
grep -R "password" .
```

Opcions habituals:

  Opció   Funció
  ------- -------------------------------------------
  `-i`    Ignora majúscules/minúscules
  `-n`    Mostra el número de línia
  `-R`    Cerca recursivament
  `-v`    Mostra les línies que **no** coincideixen

Combinar amb altres comandes:

``` bash
ps aux | grep firefox
ip a | grep inet
history | grep ssh
```

### `which` i `whereis`

``` bash
which python3
whereis nginx
```

------------------------------------------------------------------------

## 6. Redireccions i canonades

A Linux és habitual combinar comandes petites.

### `>` --- Escriure la sortida a un fitxer

``` bash
ip a > xarxa.txt
```

Sobreescriu el fitxer si ja existeix.

### `>>` --- Afegir al final

``` bash
date >> registre.txt
```

### `|` --- Canonada (*pipe*)

Passa la sortida d'una comanda a una altra:

``` bash
ip a | grep inet
ps aux | grep nginx
```

### `2>` --- Redirigir errors

``` bash
comanda 2> errors.log
```

Sortida normal i errors al mateix fitxer:

``` bash
comanda > resultat.log 2>&1
```

### `tee` --- Mostrar i guardar simultàniament

``` bash
ip a | tee xarxa.txt
```

Amb permisos d'administrador:

``` bash
echo "text" | sudo tee /etc/exemple.conf
```

------------------------------------------------------------------------

## 7. Usuaris, grups i permisos

### Usuari actual

``` bash
whoami
id
groups
```

### Usuaris connectats

``` bash
who
w
```

### Executar com a administrador

``` bash
sudo comanda
```

Exemple:

``` bash
sudo apt update
```

Obrir una shell de root:

``` bash
sudo -i
```

### Canviar permisos amb `chmod`

``` bash
chmod +x script.sh
chmod 644 fitxer.txt
chmod 755 script.sh
```

Valors:

    Valor Permís
  ------- ------------------
      `4` lectura (`r`)
      `2` escriptura (`w`)
      `1` execució (`x`)

Per exemple, `755` significa:

``` text
propietari: rwx
grup:       r-x
altres:     r-x
```

### Canviar propietari

``` bash
sudo chown usuari fitxer.txt
sudo chown usuari:grup fitxer.txt
sudo chown -R usuari:grup carpeta/
```

### Gestió bàsica d'usuaris

``` bash
sudo adduser alumne
sudo deluser alumne
sudo passwd alumne
```

Afegir un usuari a un grup:

``` bash
sudo usermod -aG grup usuari
```

------------------------------------------------------------------------

## 8. Processos i recursos

### Veure processos

``` bash
ps
ps aux
```

Cercar-ne un:

``` bash
ps aux | grep nginx
```

### Monitoritzar el sistema

``` bash
top
```

Alternativa més còmoda:

``` bash
htop
```

Instal·lació:

``` bash
sudo apt install htop
```

### Finalitzar processos

``` bash
kill PID
kill -9 PID
```

Per nom:

``` bash
pkill firefox
killall firefox
```

> \[!NOTE\] Prova primer `kill PID`. `kill -9` força la finalització i
> s'hauria de reservar per a processos que no responen.

### Memòria RAM

``` bash
free -h
```

### Temps encès i càrrega

``` bash
uptime
```

------------------------------------------------------------------------

## 9. Serveis amb systemd

Molts serveis d'Ubuntu es gestionen amb `systemctl`.

### Estat

``` bash
systemctl status ssh
systemctl status nginx
```

### Iniciar, aturar i reiniciar

``` bash
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
```

### Recarregar configuració

``` bash
sudo systemctl reload nginx
```

### Activar un servei a l'arrencada

``` bash
sudo systemctl enable nginx
```

Activar-lo i iniciar-lo immediatament:

``` bash
sudo systemctl enable --now nginx
```

Desactivar-lo:

``` bash
sudo systemctl disable nginx
```

### Comprovar ràpidament si està actiu

``` bash
systemctl is-active nginx
systemctl is-enabled nginx
```

------------------------------------------------------------------------

## 10. Xarxa

### Interfícies i adreces IP

``` bash
ip a
ip addr
```

Versió curta:

``` bash
ip -br a
```

### Rutes

``` bash
ip route
```

Ruta per defecte:

``` bash
ip route | grep default
```

### Connectivitat

``` bash
ping 8.8.8.8
ping google.com
```

Limitar el nombre de paquets:

``` bash
ping -c 4 google.com
```

### DNS

``` bash
resolvectl status
resolvectl query ubuntu.com
```

### Connexions i ports

``` bash
ss -tuln
ss -tulpn
```

Veure un port concret:

``` bash
sudo ss -tulpn | grep :80
```

### Descarregar fitxers

``` bash
wget https://exemple.com/fitxer.zip
```

Amb `curl`:

``` bash
curl https://exemple.com
curl -O https://exemple.com/fitxer.zip
```

### NetworkManager

Veure connexions:

``` bash
nmcli connection show
```

Veure dispositius:

``` bash
nmcli device status
```

------------------------------------------------------------------------

## 11. Discs, particions i espai

### Espai lliure

``` bash
df -h
```

### Espai ocupat per directoris

``` bash
du -sh carpeta/
du -sh *
```

Ordenar per mida:

``` bash
du -sh * | sort -h
```

### Discs i particions

``` bash
lsblk
lsblk -f
```

### Dispositius i UUID

``` bash
sudo blkid
```

### Muntar i desmuntar

``` bash
sudo mount /dev/sdb1 /mnt
sudo umount /mnt
```

### Fitxer de muntatges permanents

``` bash
cat /etc/fstab
```

> \[!WARNING\] Un error a `/etc/fstab` pot provocar problemes durant
> l'arrencada. Fes-ne una còpia abans de modificar-lo.

------------------------------------------------------------------------

## 12. Compressió i arxius

### TAR

Crear un `.tar`:

``` bash
tar -cvf copia.tar carpeta/
```

Extreure:

``` bash
tar -xvf copia.tar
```

### TAR + Gzip

Comprimir:

``` bash
tar -czvf copia.tar.gz carpeta/
```

Descomprimir:

``` bash
tar -xzvf copia.tar.gz
```

### ZIP

``` bash
zip fitxers.zip fitxer1 fitxer2
zip -r projecte.zip projecte/
```

Descomprimir:

``` bash
unzip projecte.zip
```

------------------------------------------------------------------------

## 13. SSH i còpia remota

### Connectar per SSH

``` bash
ssh usuari@192.168.1.50
```

Amb un port diferent:

``` bash
ssh -p 2222 usuari@servidor
```

### Generar claus

``` bash
ssh-keygen
```

Copiar la clau pública al servidor:

``` bash
ssh-copy-id usuari@servidor
```

### `scp` --- Copiar per SSH

Enviar:

``` bash
scp fitxer.txt usuari@servidor:/tmp/
```

Descarregar:

``` bash
scp usuari@servidor:/tmp/fitxer.txt .
```

Copiar una carpeta:

``` bash
scp -r carpeta/ usuari@servidor:/tmp/
```

### `rsync` --- Sincronitzar

``` bash
rsync -av carpeta/ usuari@servidor:/ruta/
```

Amb progrés:

``` bash
rsync -av --progress carpeta/ usuari@servidor:/ruta/
```

------------------------------------------------------------------------

## 14. Logs i diagnòstic

### `journalctl`

Logs generals:

``` bash
journalctl
```

Errors de l'arrencada actual:

``` bash
journalctl -b -p err
```

Logs d'un servei:

``` bash
journalctl -u nginx
```

Seguir-los en temps real:

``` bash
journalctl -u nginx -f
```

### Missatges del kernel

``` bash
dmesg
```

Amb temps llegible:

``` bash
dmesg -T
```

Últims missatges:

``` bash
dmesg -T | tail
```

------------------------------------------------------------------------

## 15. Informació de maquinari

### CPU

``` bash
lscpu
```

### Memòria

``` bash
free -h
```

### PCI

Útil per veure GPU, targetes de xarxa, controladores, etc.:

``` bash
lspci
```

### USB

``` bash
lsusb
```

### Discs

``` bash
lsblk
```

### Informació detallada

``` bash
sudo lshw
sudo lshw -short
```

Pot ser necessari:

``` bash
sudo apt install lshw
```

------------------------------------------------------------------------

# 16. Instal·lació d'aplicacions

A Ubuntu **no hi ha un únic sistema per instal·lar programes**. Els més
habituals són:

1.  **APT / paquets `.deb`**
2.  **Snap**
3.  **Flatpak**
4.  **AppImage**
5.  Instal·lació manual des del codi font o binaris, en casos més
    específics.

No són exactament equivalents.

------------------------------------------------------------------------

## 17. APT i paquets DEB

### Què és APT?

**APT** (*Advanced Package Tool*) és el gestor de paquets tradicional
d'Ubuntu i Debian.

Normalment instal·la paquets `.deb` des dels repositoris configurats al
sistema i gestiona automàticament les dependències.

### Actualitzar la informació dels repositoris

``` bash
sudo apt update
```

Aquesta comanda **no actualitza els programes**: actualitza la llista de
versions disponibles.

### Actualitzar els paquets instal·lats

``` bash
sudo apt upgrade
```

És habitual executar:

``` bash
sudo apt update
sudo apt upgrade
```

### Instal·lar

``` bash
sudo apt install nginx
sudo apt install git
sudo apt install vlc
```

### Eliminar

``` bash
sudo apt remove nginx
```

Eliminar també la configuració del paquet:

``` bash
sudo apt purge nginx
```

### Eliminar dependències que ja no són necessàries

``` bash
sudo apt autoremove
```

### Cercar

``` bash
apt search nginx
```

### Informació d'un paquet

``` bash
apt show nginx
```

### Veure paquets instal·lats

``` bash
apt list --installed
```

### Instal·lar un `.deb` descarregat

La manera recomanable és:

``` bash
sudo apt install ./programa.deb
```

APT intentarà resoldre també les dependències.

També existeix `dpkg`:

``` bash
sudo dpkg -i programa.deb
```

Però `dpkg` per si sol no resol les dependències de la mateixa manera
que APT.

### Quan convé APT?

APT sol ser la primera opció per:

-   components del sistema;
-   servidors;
-   eines de terminal;
-   biblioteques;
-   programari disponible als repositoris oficials;
-   programari que necessita integrar-se fortament amb el sistema.

------------------------------------------------------------------------

## 18. Snap

### Què és Snap?

**Snap** és un sistema de paquets desenvolupat principalment per
Canonical.

Un paquet Snap inclou bona part de les seves dependències i s'executa
amb mecanismes d'aïllament.

Ubuntu incorpora Snap per defecte en moltes instal·lacions.

### Cercar

``` bash
snap find vlc
```

### Instal·lar

``` bash
sudo snap install vlc
```

### Veure els Snap instal·lats

``` bash
snap list
```

### Actualitzar

``` bash
sudo snap refresh
```

Normalment Snap també gestiona les actualitzacions automàticament.

### Eliminar

``` bash
sudo snap remove vlc
```

### Avantatges

-   Mateix paquet per a diferents versions d'Ubuntu.
-   Dependències incloses.
-   Actualitzacions automàtiques.
-   Cert nivell d'aïllament.
-   Fàcil distribució per als desenvolupadors.

### Inconvenients

-   Pot ocupar més espai.
-   Algunes aplicacions poden arrencar més lentament.
-   La integració amb el sistema pot variar segons l'aplicació.
-   La infraestructura principal de distribució està centralitzada en
    Snap Store.

------------------------------------------------------------------------

## 19. Flatpak

### Què és Flatpak?

**Flatpak** és un sistema de distribució d'aplicacions especialment
orientat a programes d'escriptori.

Les aplicacions funcionen dins d'un entorn relativament aïllat i
comparteixen *runtimes* comuns.

No sempre ve instal·lat per defecte a Ubuntu.

### Instal·lar Flatpak

``` bash
sudo apt install flatpak
```

### Afegir Flathub

**Flathub** és el repositori de Flatpak més utilitzat:

``` bash
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```

### Cercar aplicacions

``` bash
flatpak search vlc
```

### Instal·lar

``` bash
flatpak install flathub org.videolan.VLC
```

### Executar

``` bash
flatpak run org.videolan.VLC
```

Normalment també apareixerà al menú d'aplicacions de l'escriptori.

### Veure aplicacions instal·lades

``` bash
flatpak list
```

### Actualitzar

``` bash
flatpak update
```

### Eliminar

``` bash
flatpak uninstall org.videolan.VLC
```

Eliminar runtimes que ja no s'empren:

``` bash
flatpak uninstall --unused
```

### Avantatges

-   Molt útil per a aplicacions gràfiques.
-   Bona disponibilitat de versions recents.
-   Funciona en moltes distribucions Linux.
-   Aïllament mitjançant *sandbox*.
-   Flathub disposa d'un catàleg molt ampli.

### Inconvenients

-   Pot ocupar més espai que un paquet natiu.
-   Els permisos del *sandbox* poden causar diferències de comportament.
-   No és la millor opció per a components interns del sistema o
    serveis.

------------------------------------------------------------------------

## 20. AppImage

### Què és AppImage?

Una **AppImage** és, habitualment, un únic fitxer executable que conté
una aplicació i les dependències necessàries.

No necessita una instal·lació tradicional.

Per exemple:

``` text
Programa-2.0-x86_64.AppImage
```

### Fer-la executable

``` bash
chmod +x Programa-2.0-x86_64.AppImage
```

### Executar-la

``` bash
./Programa-2.0-x86_64.AppImage
```

També es pot fer executable des de les propietats del fitxer en un
entorn gràfic.

### Avantatges

-   Molt fàcil d'utilitzar.
-   No requereix instal·lació al sistema.
-   Es pot guardar a qualsevol carpeta.
-   És fàcil tenir diverses versions d'una mateixa aplicació.
-   Pot resultar útil com a aplicació portable.

### Inconvenients

-   No hi ha un mecanisme únic d'actualització per a totes les AppImage.
-   La integració amb el menú d'aplicacions depèn de l'aplicació o
    d'eines addicionals.
-   Cada AppImage pot incloure moltes dependències pròpies.
-   Cal descarregar-la d'una font fiable.

Una possible organització és:

``` bash
mkdir -p ~/Applications
mv Programa-2.0-x86_64.AppImage ~/Applications/
```

------------------------------------------------------------------------

## 21. Comparativa dels sistemes d'instal·lació

  ----------------------------------------------------------------------------
  Característica   APT / DEB      Snap           Flatpak        AppImage
  ---------------- -------------- -------------- -------------- --------------
  Integració amb   Excel·lent     Molt bona      Bona           Variable
  Ubuntu                                                        

  Dependències     Compartides    Incloses /     Runtimes       Normalment
                   pel sistema    bases          compartits     incloses
                                  compartides                   

  Aïllament        Baix           Sí             Sí             Limitat per si
                                                                mateix

  Actualització    Sí             Sí             Sí             Depèn de
  centralitzada                                                 l'aplicació

  Versions molt    Depèn del      Habitualment   Habitualment   Habitualment
  recents          repositori                                   

  Ideal per a      **Sí**         En alguns      No habitual    No habitual
  servidors                       casos                         

  Ideal per a      Sí             Sí             **Sí**         Sí
  aplicacions                                                   
  d'escriptori                                                  

  Portable         No             No             No             **Sí**
  ----------------------------------------------------------------------------

### Quin convé emprar?

Com a regla pràctica:

**APT** és una bona primera opció per a paquets del sistema, eines de
terminal i serveis:

``` bash
sudo apt install git
sudo apt install nginx
```

**Flatpak** és especialment interessant per a aplicacions gràfiques quan
es vol una versió recent i ben aïllada.

**Snap** és útil quan el projecte distribueix oficialment el programa en
aquest format o quan Ubuntu ja l'integra així.

**AppImage** és molt pràctic per provar o executar una aplicació
autocontinguda sense fer una instal·lació tradicional.

> \[!TIP\] No hi ha un format universalment «millor». Cal valorar la
> font del paquet, la versió disponible, la integració necessària, les
> actualitzacions i el nivell d'aïllament.

------------------------------------------------------------------------

## 22. Comandes especialment útils

Una petita selecció per tenir a mà:

``` bash
# On som?
pwd

# Veure fitxers, inclosos els ocults
ls -lah

# Espai lliure als discs
df -h

# Mida d'una carpeta
du -sh carpeta/

# Memòria RAM
free -h

# IPs de forma resumida
ip -br a

# Taula de rutes
ip route

# Ports en escolta
sudo ss -tulpn

# Processos
ps aux

# Monitorització
top

# Estat d'un servei
systemctl status nginx

# Logs d'un servei
journalctl -u nginx

# Cercar text
grep -R "text" .

# Cercar fitxers
find . -name "*.conf"

# Actualitzar Ubuntu
sudo apt update && sudo apt upgrade

# Identificar maquinari PCI
lspci

# Discs i sistemes de fitxers
lsblk -f
```

------------------------------------------------------------------------

## Notes importants

### Linux diferencia majúscules i minúscules

Aquests noms són diferents:

``` text
fitxer.txt
Fitxer.txt
FITXER.txt
```

### Els fitxers ocults comencen per `.`

Exemples:

``` text
.bashrc
.ssh/
.config/
```

Per veure'ls:

``` bash
ls -la
```

### Evita emprar `sudo` si no és necessari

`sudo` dona privilegis d'administrador a la comanda. No s'ha d'afegir
automàticament a qualsevol instrucció.

### Abans de copiar una comanda d'Internet

Especialment si conté:

``` bash
sudo
rm -rf
curl ... | bash
wget ... | sh
chmod 777
```

convé entendre què farà abans d'executar-la.

------------------------------------------------------------------------

## Mini-xuleta final

``` bash
pwd                         # Directori actual
ls -lah                     # Llistar fitxers
cd directori                # Entrar a un directori
cd ..                       # Pujar un nivell
cp origen desti             # Copiar
mv origen desti             # Moure / reanomenar
rm fitxer                    # Eliminar fitxer
mkdir carpeta               # Crear directori
cat fitxer                   # Mostrar fitxer
less fitxer                  # Llegir còmodament
grep "text" fitxer           # Cercar text
find . -name "*.txt"         # Cercar fitxers
chmod +x script.sh           # Donar permís d'execució
df -h                        # Espai de disc
free -h                      # Memòria
ip -br a                     # Adreces IP
ip route                     # Rutes
ss -tulpn                    # Ports
ps aux                       # Processos
systemctl status servei      # Estat d'un servei
journalctl -u servei         # Logs d'un servei
sudo apt update              # Actualitzar índex de paquets
sudo apt upgrade             # Actualitzar paquets
sudo apt install paquet      # Instal·lar amb APT
```
