# Activitat 1.3 — Desplegament d'una aplicació web en un VPS amb Apache

## Objectiu

En aquesta activitat desplegarem una aplicació web en un **servidor Linux (VPS)** utilitzant **Apache** com a servidor web.

A diferència de l'activitat anterior amb Render, ara serem nosaltres els encarregats de preparar el servidor: ens hi connectarem remotament, instal·larem Apache i desplegarem l'aplicació.

El professor proporcionarà a cada alumne:

- l'adreça IP del servidor;
- un nom d'usuari;
- una contrasenya.

El flux serà:

```text
Aplicació local
        │
        │ git push
        ▼
      GitHub
        │
        │ git clone / git pull
        ▼
       VPS
        │
        ▼
      Apache
        │
        ▼
 Aplicació pública
```

En aquest cas **no utilitzarem una plataforma PaaS** que gestioni el servidor per nosaltres.

Nosaltres serem els encarregats d'instal·lar i gestionar el servidor web.

---

## 1. Connectar-se al servidor

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

## 2. Instal·lar Apache

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

---

## 3. Comprovar Apache

Ara Apache ja està executant-se al nostre servidor.

Obre un navegador al teu ordinador i accedeix a:

```text
http://IP_DEL_SERVIDOR
```

Hauria d'aparèixer la pàgina per defecte d'Apache.

Això significa que:

```text
Navegador
    │
    │ HTTP
    ▼
Servidor VPS
    │
    ▼
  Apache
    │
    ▼
Pàgina web
```

Apache està escoltant les peticions web i retornant el contingut corresponent.

---

## 4. Localitzar la web d'Apache

Torna al terminal on tenim oberta la connexió SSH.

Per defecte, Apache utilitza el directori:

```text
/var/www/html
```

Podem consultar el seu contingut:

```bash
ls -la /var/www/html
```

Hi trobarem el fitxer que correspon a la pàgina que acabem de veure al navegador.

Podem comprovar-ho amb:

```bash
ls /var/www/html
```

Apache, per tant, està servint els fitxers que es troben dins de:

```text
/var/www/html
```

---

## 5. Preparar l'aplicació en local

Ara torna al terminal del teu **ordinador local**.

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

Abans de continuar, obre l'aplicació i comprova que els fitxers HTML, CSS, imatges i altres recursos funcionen correctament.

---

## 6. Crear el repositori Git

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

## 7. Clonar l'aplicació al servidor

Torna a connectar-te al VPS mitjançant SSH si ja havies tancat la connexió:

```bash
ssh USUARI@IP_DEL_SERVIDOR
```

Per poder descarregar el projecte des de GitHub necessitarem tenir Git instal·lat al servidor.

Comprova si està instal·lat:

```bash
git --version
```

Si no està instal·lat:

```bash
sudo apt install git
```

Ara anirem al directori on Apache publica les pàgines:

```bash
cd /var/www
```

Elimina la web que Apache instal·la per defecte:

```bash
sudo rm -rf /var/www/html
```

Clona el teu repositori i indica que volem guardar-lo com a `html`:

```bash
sudo git clone URL_DEL_REPOSITORI html
```

Comprova el resultat:

```bash
ls -la /var/www/html
```

Ara dins aquest directori haurien d'aparèixer els fitxers de la nostra aplicació.

---

## 8. Comprovar el desplegament

Obre novament al navegador:

```text
http://IP_DEL_SERVIDOR
```

Ara ja no hauria d'aparèixer la pàgina per defecte d'Apache.

Hauria d'aparèixer **la nostra aplicació web**.

El flux complet que acabem de realitzar és:

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

En aquest cas Apache està llegint els fitxers de:

```text
/var/www/html
```

i els envia al navegador quan rep una petició HTTP.

---

## 9. Modificar l'aplicació

Ara farem una modificació per comprovar com podem actualitzar una aplicació que ja està desplegada.

Torna al projecte del teu **ordinador local**:

```bash
cd DPL_Act1.3.Apache
```

Modifica algun element visible de l'aplicació.

Per exemple:

- un títol;
- un text;
- un color;
- una imatge;
- o qualsevol altre element fàcilment identificable.

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

A diferència de Render, GitHub i el nostre VPS no estan sincronitzats automàticament.

---

## 10. Actualitzar l'aplicació al servidor

Connecta't novament al VPS:

```bash
ssh USUARI@IP_DEL_SERVIDOR
```

Accedeix al directori de l'aplicació:

```bash
cd /var/www/html
```

Podem comprovar que aquest directori és un repositori Git:

```bash
git status
```

Ara descarrega els darrers canvis publicats a GitHub:

```bash
sudo git pull
```

Git descarregarà els canvis i actualitzarà els fitxers del servidor.

---

## 11. Comprovar la nova versió

Torna al navegador i actualitza:

```text
http://IP_DEL_SERVIDOR
```

Ara haurien d'aparèixer els canvis que hem realitzat.

El procés d'actualització ha estat:

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

Apache no necessita que tornem a copiar manualment tots els fitxers.

Git s'encarrega de descarregar únicament els canvis del repositori i actualitzar la còpia que tenim al servidor.

---

# Resultat final

En acabar l'activitat disposarem de:

```text
Ordinador local
      │
      │ git push
      ▼
    GitHub
      │
      │ git pull
      ▼
     VPS
      │
      ▼
    Apache
      │
      ▼
Aplicació web
```
