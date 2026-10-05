# Activitat 1.3 — Desplegament d'una aplicació web en un VPS amb Apache

## Objectiu

En aquesta activitat desplegarem una aplicació web en un **servidor Linux (VPS)** utilitzant **Apache** com a servidor web.

A diferència de les activitats anteriors, ara serem nosaltres els encarregats d'administrar el servidor: ens hi connectarem remotament, instal·larem Apache i publicarem la nostra aplicació.

Durant l'activitat provarem **tres formes diferents de desplegar una aplicació**:

1. Transferència de fitxers mitjançant **SFTP amb FileZilla**.
2. Edició directa del servidor mitjançant **Remote SSH amb Visual Studio Code**.
3. Desplegament mitjançant **Git i GitHub**.

El professor proporcionarà a cada alumne:

- l'adreça IP del servidor;
- un nom d'usuari;
- una contrasenya.

Al final de l'activitat haurem experimentat tres maneres diferents de modificar el contingut que Apache publica:

```text
                  ┌── SFTP / FileZilla ──────┐
                  │                           │
Ordinador local ──┼── VS Code + SSH ─────────┼──► VPS ──► Apache ──► Web
                  │                           │
                  └── GitHub ──► Git ─────────┘
```

---

# 1. Connectar-se al servidor

El servidor que utilitzarem no té entorn gràfic. Hi accedirem remotament mitjançant **SSH**.

El professor proporcionarà les dades de connexió:

```text
IP: IP_DEL_SERVIDOR
Usuari: USUARI
Contrasenya: CONTRASENYA
```

Obre un terminal i connecta't:

```bash
ssh USUARI@IP_DEL_SERVIDOR
```

La primera vegada que ens connectem pot aparèixer un missatge semblant a:

```text
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```

Accepta la connexió escrivint:

```text
yes
```

Introdueix la contrasenya proporcionada pel professor.

> Quan escrivim una contrasenya al terminal Linux **no apareix cap caràcter en pantalla**. És normal.

Si la connexió s'ha realitzat correctament, el *prompt* del terminal canviarà i estarem executant les comandes **dins del servidor remot**.

Podem consultar informació del sistema amb:

```bash
cat /etc/os-release
```

I consultar les seves adreces IP amb:

```bash
ip a
```

A partir d'aquest moment és important distingir entre:

```text
Ordinador local
```

i:

```text
Servidor VPS
```

Les comandes que executem després d'entrar per SSH s'estan executant **al servidor**, no al nostre ordinador.

---

# 2. Instal·lar Apache

Primer actualitza la informació dels repositoris:

```bash
sudo apt update
```

Instal·la Apache:

```bash
sudo apt install apache2
```

Podem comprovar l'estat del servei amb:

```bash
systemctl status apache2
```

Hauríem de veure:

```text
active (running)
```

Prem:

```text
q
```

per sortir de la pantalla d'estat.

També podem comprovar que Apache està escoltant al **port 80**:

```bash
sudo ss -ltnp | grep :80
```

El port 80 és el port utilitzat habitualment pel protocol HTTP.

---

# 3. Comprovar Apache

Obre un navegador al teu ordinador i accedeix a:

```text
http://IP_DEL_SERVIDOR
```

Hauria d'aparèixer la pàgina per defecte d'Apache.

Això significa que el servidor està acceptant peticions HTTP:

```text
Navegador
    │
    │ HTTP :80
    ▼
Servidor VPS
    │
    ▼
  Apache
    │
    ▼
Pàgina web
```

---

# 4. Localitzar la web d'Apache

Torna al terminal on tenim oberta la connexió SSH.

Per defecte, Apache utilitza el directori:

```text
/var/www/html
```

Podem consultar-ne el contingut:

```bash
ls -la /var/www/html
```

Hi trobarem el fitxer que correspon a la pàgina que acabem de veure al navegador.

Apache, per tant, està servint els fitxers que es troben dins de:

```text
/var/www/html
```

Podem eliminar la pàgina inicial d'Apache:

```bash
sudo rm /var/www/html/index.html
```

---

# 5. Preparar el directori per als desplegaments

El directori `/var/www/html` pertany inicialment a l'usuari `root`.

Ho podem comprovar amb:

```bash
ls -ld /var/www/html
```

Per poder treballar durant aquesta pràctica amb FileZilla, VS Code i Git sense haver d'utilitzar `sudo` constantment, assignarem el directori al nostre usuari.

Executa:

```bash
sudo chown -R $USER:$USER /var/www/html
```

Comprova el resultat:

```bash
ls -ld /var/www/html
```

Ara el nostre usuari podrà crear, modificar i eliminar fitxers dins d'aquest directori.

> Aquesta configuració simplifica l'entorn de pràctiques. En un servidor de producció real s'haurien de definir amb més cura els usuaris, grups i permisos del directori web.

---

# PART 1 — DESPLEGAMENT MITJANÇANT SFTP

# 6. Preparar l'aplicació en local

Torna al teu **ordinador local**.

Crea una carpeta per a la pràctica:

```bash
mkdir DPL_Act1.3.Apache
cd DPL_Act1.3.Apache
```

Copia dins aquesta carpeta els fitxers de l'aplicació proporcionats pel professor.

Comprova el contingut:

```bash
ls -la
```

Hi haurà d'haver, com a mínim, un fitxer:

```text
index.html
```

i els fitxers CSS, JavaScript, imatges o altres recursos que utilitzi l'aplicació.

---

# 7. Connectar FileZilla al servidor

Obre **FileZilla** al teu ordinador.

Crea una nova connexió utilitzant:

```text
Protocol: SFTP - SSH File Transfer Protocol
Servidor: IP_DEL_SERVIDOR
Port: 22
Usuari: USUARI
Contrasenya: CONTRASENYA
```

Utilitzarem **SFTP**, no FTP tradicional.

SFTP permet transferir fitxers utilitzant una connexió SSH xifrada.

```text
Ordinador local
      │
      │ SFTP :22
      ▼
     VPS
```

Les mateixes credencials que utilitzam per entrar mitjançant SSH ens permeten accedir als fitxers mitjançant SFTP.

---

# 8. Copiar l'aplicació amb FileZilla

A FileZilla veurem dues zones principals:

```text
Ordinador local        Servidor remot
────────────────       ───────────────
fitxers locals         fitxers del VPS
```

A la part corresponent al servidor, navega fins a:

```text
/var/www/html
```

A la part local, localitza:

```text
DPL_Act1.3.Apache
```

Selecciona **el contingut de la carpeta** i transfereix-lo a:

```text
/var/www/html
```

En acabar, al servidor hauríem de tenir:

```text
/var/www/html/
├── index.html
├── ...
└── ...
```

---

# 9. Comprovar el desplegament per SFTP

Obre al navegador:

```text
http://IP_DEL_SERVIDOR
```

Ara hauria d'aparèixer la nostra aplicació.

El procés que acabem de realitzar és:

```text
Ordinador local
      │
      │ SFTP
      ▼
/var/www/html
      │
      ▼
    Apache
      │
      ▼
  Navegador
```

Modifica ara algun text de l'aplicació **al teu ordinador** i torna a pujar el fitxer modificat mitjançant FileZilla.

Actualitza el navegador i comprova que el canvi apareix.

Aquest és un sistema de desplegament senzill: **copiam directament els fitxers modificats al servidor**.

---

# PART 2 — DESPLEGAMENT MITJANÇANT REMOTE SSH

# 10. Instal·lar Remote SSH a Visual Studio Code

Ara provarem una manera diferent de treballar.

Obre **Visual Studio Code** al teu ordinador.

Accedeix a l'apartat d'extensions i cerca:

```text
Remote - SSH
```

Instal·la l'extensió corresponent.

Aquesta extensió permet que Visual Studio Code es connecti mitjançant SSH a un altre ordinador i treballi directament amb els seus fitxers.

---

# 11. Connectar VS Code al servidor

Obre la paleta de comandes de Visual Studio Code:

```text
Ctrl + Shift + P
```

Cerca:

```text
Remote-SSH: Connect to Host...
```

Selecciona:

```text
Add New SSH Host...
```

Introdueix:

```bash
ssh USUARI@IP_DEL_SERVIDOR
```

Selecciona el fitxer de configuració SSH que proposa Visual Studio Code.

Torna a executar:

```text
Remote-SSH: Connect to Host...
```

i selecciona el servidor que acabes d'afegir.

Introdueix la contrasenya quan sigui necessari.

Visual Studio Code obrirà una nova finestra connectada al VPS.

---

# 12. Obrir l'aplicació remota

A la finestra remota de Visual Studio Code selecciona:

```text
File → Open Folder
```

i obre:

```text
/var/www/html
```

Ara Visual Studio Code mostrarà els fitxers que realment es troben **al servidor**.

Això és important:

```text
VS Code
   │
   │ SSH
   ▼
Servidor VPS
   │
   ▼
/var/www/html
```

No estam editant una còpia local.

**Estam editant directament els fitxers del servidor.**

---

# 13. Modificar la web mitjançant Remote SSH

Obre:

```text
index.html
```

Modifica algun element visible de la pàgina.

Per exemple:

- un títol;
- un text;
- un color;
- una imatge.

Guarda el fitxer:

```text
Ctrl + S
```

Ara actualitza el navegador:

```text
http://IP_DEL_SERVIDOR
```

El canvi apareixerà immediatament.

No hem necessitat:

```text
FileZilla
git push
git pull
```

perquè estàvem modificant **directament el fitxer del servidor**.

El procés és:

```text
Visual Studio Code
        │
        │ SSH
        ▼
       VPS
        │
        ▼
 /var/www/html
        │
        ▼
      Apache
        │
        ▼
    Navegador
```

Aquest sistema és molt còmode per administrar servidors, revisar configuracions o fer modificacions puntuals.

---

# PART 3 — DESPLEGAMENT MITJANÇANT GIT I GITHUB

# 14. Tornar al projecte local

Ara utilitzarem un tercer sistema de desplegament.

Torna al projecte del teu **ordinador local**:

```bash
cd DPL_Act1.3.Apache
```

A partir d'ara utilitzarem Git per controlar les versions de l'aplicació i GitHub com a repositori remot.

---

# 15. Crear el repositori Git

Inicialitza el repositori:

```bash
git init
git branch -M main
git add .
git commit -m "Primera versió de l'aplicació"
```

Crea a GitHub un repositori públic, per exemple:

```text
DPL_Act1.3.Apache
```

No hi afegeixis README, `.gitignore` ni llicència des de GitHub.

Associa el repositori local amb GitHub:

```bash
git remote add origin URL_DEL_REPOSITORI
git push -u origin main
```

Entra a GitHub i comprova que tots els fitxers de l'aplicació s'han publicat correctament.

Ara tenim:

```text
Aplicació local
      │
      │ git push
      ▼
    GitHub
```

---

# 16. Preparar el servidor

Connecta't al VPS:

```bash
ssh USUARI@IP_DEL_SERVIDOR
```

Comprova si Git està instal·lat:

```bash
git --version
```

Si no està instal·lat:

```bash
sudo apt install git
```

Com que `/var/www/html` conté els fitxers que havíem desplegat amb els sistemes anteriors, els eliminarem abans de clonar el repositori:

```bash
rm -rf /var/www/html
```

Ara clonarem el repositori indicant que el directori de destinació ha de ser `/var/www/html`:

```bash
git clone URL_DEL_REPOSITORI /var/www/html
```

Comprova el resultat:

```bash
ls -la /var/www/html
```

Ara també apareixerà:

```text
.git
```

Això ens indica que `/var/www/html` és ara un **repositori Git**.

---

# 17. Comprovar el desplegament

Obre novament al navegador:

```text
http://IP_DEL_SERVIDOR
```

Hauria d'aparèixer la nostra aplicació web.

Ara el desplegament s'ha realitzat de manera diferent:

```text
Ordinador local
      │
      │ git push
      ▼
    GitHub
      │
      │ git clone
      ▼
     VPS
      │
      ▼
/var/www/html
      │
      ▼
    Apache
      │
      ▼
  Navegador
```

---

# 18. Modificar l'aplicació

Ara farem una modificació per comprovar com podem actualitzar una aplicació que ja està desplegada.

Torna al projecte del teu **ordinador local**:

```bash
cd DPL_Act1.3.Apache
```

Modifica algun element visible de l'aplicació.

Comprova els canvis:

```bash
git status
```

Afegeix-los al repositori:

```bash
git add .
git commit -m "Modifica la pàgina principal"
git push
```

Comprova a GitHub que apareix la nova versió.

Ara tenim:

```text
Ordinador local
      │
      │ git push
      ▼
    GitHub
```

Però si obrim:

```text
http://IP_DEL_SERVIDOR
```

**la web del servidor encara no s'ha actualitzat.**

GitHub i el nostre VPS no estan sincronitzats automàticament.

---

# 19. Actualitzar l'aplicació al servidor

Connecta't al VPS:

```bash
ssh USUARI@IP_DEL_SERVIDOR
```

Accedeix al directori de l'aplicació:

```bash
cd /var/www/html
```

Comprova l'estat del repositori:

```bash
git status
```

Ara descarrega els darrers canvis publicats a GitHub:

```bash
git pull
```

Git descarregarà els canvis i actualitzarà els fitxers del servidor.

Actualitza el navegador:

```text
http://IP_DEL_SERVIDOR
```

Ara haurien d'aparèixer els canvis.

El procés complet d'actualització ha estat:

```text
Modificar codi
     │
     ▼
 git commit
     │
     ▼
  git push
     │
     ▼
   GitHub
     │
     ▼
  git pull
     │
     ▼
    VPS
     │
     ▼
   Apache
```

---

# 20. Comparació dels tres sistemes

Durant aquesta activitat hem desplegat la mateixa aplicació utilitzant tres sistemes diferents.

| Sistema | Funcionament | Avantatge principal |
|---|---|---|
| **SFTP / FileZilla** | Copiam fitxers de local al servidor | Senzill i visual |
| **VS Code Remote SSH** | Editam directament els fitxers del servidor | Còmode per administrar i modificar |
| **Git + GitHub** | Local → GitHub → servidor | Control de versions i traçabilitat |

Amb **SFTP**:

```text
Local ── SFTP ──► VPS
```

Amb **Remote SSH**:

```text
VS Code ── SSH ──► VPS
                    ▲
                    │
                 edició
                 directa
```

Amb **GitHub**:

```text
Local ── git push ──► GitHub ── git pull ──► VPS
```

Els tres sistemes poden acabar modificant els mateixos fitxers:

```text
/var/www/html
```

però el procés utilitzat per arribar-hi és diferent.

---

# Resultat final

En acabar l'activitat haurem après a:

- connectar-nos remotament a un servidor mitjançant SSH;
- instal·lar i comprovar Apache;
- identificar el port utilitzat pel servei HTTP;
- identificar `/var/www/html` com a directori de publicació;
- entendre els permisos necessaris per modificar els fitxers d'una web;
- transferir una aplicació mitjançant SFTP;
- utilitzar FileZilla per gestionar fitxers remots;
- connectar Visual Studio Code a un servidor mitjançant Remote SSH;
- editar directament una aplicació ubicada en un servidor;
- utilitzar Git per controlar les versions d'una aplicació;
- publicar el projecte a GitHub;
- desplegar-lo amb `git clone`;
- actualitzar-lo posteriorment amb `git pull`;
- comparar diferents estratègies de desplegament.

Conceptualment hem passat per tres formes de desplegament:

```text
1. CÒPIA DIRECTA

Local ── SFTP ──► VPS ──► Apache


2. EDICIÓ REMOTA

VS Code ── SSH ──► VPS ──► Apache


3. CONTROL DE VERSIONS

Local ──► GitHub ──► VPS ──► Apache
          Git          Git
```

Aquests tres sistemes ens permeten veure l'evolució des d'un **desplegament manual de fitxers** fins a un desplegament basat en **control de versions**, que servirà de base per entendre posteriorment sistemes de desplegament més automatitzats.