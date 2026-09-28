
# Guia Tècnica: Configuració de Claus SSH per a Gitea

## **Introducció**

Clonar repositoris mitjançant HTTPS ens obliga a introduir l'usuari i la contrasenya (o un token) constantment. El protocol **SSH (Secure Shell)** permet establir una connexió segura entre el teu ordinador i el servidor Gitea sense necessitat de teclejar credencials cada vegada, utilitzant un parell de claus criptogràfiques (pública i privada).

## **Objectius**

* Generar un parell de claus SSH segures (algoritme ED25519).
* Configurar la clau pública en el perfil d'usuari de Gitea.
* Verificar la connexió i clonar un repositori mitjançant SSH.

## **Instruccions**

### **1. Generar la clau al teu PC**

Obre una terminal (Git Bash a Windows, o la terminal a Linux/macOS) i executa la següent comanda:

```bash
ssh-keygen -t ed25519 -C "el-teu-correu@exemple.com"

```

* Quan et demani *"Enter file in which to save the key"*, prem **Enter** per deixar la ruta per defecte.
* Quan et demani una *"passphrase"*, pots posar-ne una (més segur) o prémer **Enter** dues vegades per deixar-la buida (més còmode).

### **2. Obtenir la clau pública**

Has de copiar exactament el contingut del fitxer públic que s'ha generat (acaba en `.pub`). Pots veure'l amb:

```bash
cat ~/.ssh/id_ed25519.pub

```

*Copia tot el text que comença per `ssh-ed25519 ...` fins al teu correu.*

### **3. Afegir la clau al Gitea**

1. Inicia sessió al teu **Gitea**.
2. Ves a la teva configuració de perfil (cantó superior dret) -> **Configuració**.
3. Al menú de l'esquerra, selecciona **Claus SSH / GPG**.
4. Prem el botó **Afegeix una clau**.
5. Posa-li un nom (p. ex: "Portàtil Classe") i enganxa el contingut que has copiat al quadre "Contingut".
6. Prem **Afegeix una clau**.

### **4. Provar la connexió**

Torna a la terminal i comprova si el servidor t'identifica:

```bash
ssh -T git@el-teu-servidor-gitea.com

```

*(Hauries de rebre un missatge de benvinguda amb el teu nom d'usuari).*

## **Consells**

* **Privacitat:** La clau privada (`id_ed25519`) **mai** s'ha de compartir ni pujar enlloc. La clau pública (`.pub`) és la que es lliura als servidors.
* **Format de clonació:** A partir d'ara, quan vulguis clonar, assegura't de copiar la URL que comença per `git@...` i no la de `http://...`.
* **Persistència:** Si canvies d'ordinador, hauràs de repetir aquest procés o moure la teva carpeta `.ssh` amb molta precaució.

---

**Activitat de verificació:**
Un cop configurat, clona el repositori de la pràctica anterior utilitzant SSH i puja un fitxer anomenat `SSH_TEST.md`.
