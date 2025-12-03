Git és un **sistema de control de versions distribuït** que permet fer un seguiment dels canvis en el vostre codi al llarg del temps i col·laborar eficaçment amb altres.

-----

## 🚀 Guió per Aprendre les Comandes Bàsiques de Git

Aquest guió cobreix el flux de treball més comú a Git, des de la creació d'un repositori fins a la sincronització amb un repositori remot (com a GitHub o GitLab).

### I. Configuració Inicial i Creació de Repositori

1.  **Configuració d'Usuari:** Estableix qui ets per als commits.
      * `git config`
2.  **Inicialització:** Converteix una carpeta en un repositori Git.
      * `git init`
3.  **Clonació (Alternativa):** Baixa un projecte existent d'un repositori remot.
      * `git clone`

-----

### II. Flux de Treball Local (Fer Canvis i Guardar)

4.  **Estat:** Mostra l'estat del teu directori de treball.
      * `git status`
5.  **Preparació (Staging):** Afegeix fitxers a l'àrea de preparació.
      * `git add`
6.  **Confirmació (Commit):** Guarda els canvis preparats al historial local.
      * `git commit`
7.  **Historial:** Revisa l'historial de commits.
      * `git log`

-----

### III. Treball Remot (Sincronització)

8.  **Rebre Canvis:** Baixa i fusiona canvis del repositori remot.
      * `git pull`
9.  **Enviar Canvis:** Puja els teus commits locals al repositori remot.
      * `git push`

-----

## 🛠️ Desenvolupament de Comandes amb Exemples

### 1\. `git config` (Configuració)

Permet configurar paràmetres específics d'usuari (nom i correu electrònic) que s'adjuntaran a cada commit.

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git config --global user.name`** | Estableix el teu nom d'usuari globalment. | `git config --global user.name "Nom Usuari"` |
| **`git config --global user.email`** | Estableix el teu correu electrònic globalment. | `git config --global user.email "correu@exemple.com"` |

-----

### 2\. `git init` (Inicialització)

Crea un nou repositori Git buit en el directori actual. Això genera una carpeta oculta anomenada `.git` que conté tota la informació necessària del repositori.

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git init`** | Inicialitza un repositori Git al directori on et trobes. | (Dins de la carpeta `ProjecteNou`) `git init` |

-----

### 3\. `git clone` (Clonació)

S'utilitza per descarregar una còpia completa d'un repositori existent des d'un servidor remot (URL).

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git clone <url_repo>`** | Clona el repositori de la URL a la teva màquina local. | `git clone https://github.com/usuari/repo.git` |

-----

### 4\. `git status` (Estat)

Mostra l'estat dels fitxers del directori de treball, indicant quins han estat modificats, quins estan a l'àrea de preparació (staged) i quins no tenen seguiment (untracked).

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git status`** | Mostra un resum de l'estat dels fitxers. | `git status` |
| **Exemple de Sortida:** | Fitxer nou creat (`nou_fitxer.txt`): es mostra com a *Untracked*. |

-----

### 5\. `git add` (Preparació)

Afegeix canvis al fitxer(s) a l'**àrea de preparació (Staging Area)**, preparant-los per al proper commit.

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git add <fitxer>`** | Afegeix un fitxer específic a l'àrea de preparació. | `git add index.html` |
| **`git add .`** | Afegeix **tots** els canvis (fitxers nous i modificats) al directori actual. | `git add .` |

-----

### 6\. `git commit` (Confirmació)

Guarda els canvis que es troben a l'àrea de preparació a l'historial del repositori local com una **instantània (commit)**. Cada commit ha d'incloure un missatge descriptiu.

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git commit -m "missatge"`** | Crea un commit amb el missatge especificat. | `git commit -m "Feat: Afegida secció de contacte"` |
| **`git commit -am "missatge"`** | Afegeix i confirma directament els canvis en fitxers que Git ja rastreja (evita l'ús previ de `git add` per a fitxers existents). | `git commit -am "Fix: Arreglat error tipogràfic"` |

-----

### 7\. `git log` (Historial)

Mostra l'historial de commits del repositori.

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git log`** | Mostra l'historial complet amb detalls. | `git log` |
| **`git log --oneline`** | Mostra un historial concís (un commit per línia). | `git log --oneline` |

-----

### 8\. `git pull` (Rebre Canvis)

Descarrega (fetch) el contingut del repositori remot i, automàticament, el fusiona (merge) amb la branca local actual. És la manera més ràpida de sincronitzar el teu treball local amb les darreres actualitzacions remotes.

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git pull origin <branca>`** | Baixa i fusiona els canvis de la branca remota. | `git pull origin main` |

-----

### 9\. `git push` (Enviar Canvis)

Puja els commits locals (que encara no estan al repositori remot) a la branca remota.

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git push origin <branca>`** | Envia els commits locals a la branca remota. | `git push origin main` |
| **`git push -u origin <branca>`** | (Primer `push`) Estableix la branca remota com a **upstream** per als futurs `push` i `pull`. | `git push -u origin main` |

-----

## 💡 Flux de Treball Bàsic Complet

1.  **Crea i Inicialitza:**
    ```bash
    mkdir nou_projecte
    cd nou_projecte
    git init
    ```
2.  **Crea i Modifica fitxers** (p. ex., crea `index.html`).
3.  **Verifica l'Estat:**
    ```bash
    git status
    # Mostra index.html com a "Untracked"
    ```
4.  **Prepara els Canvis:**
    ```bash
    git add .
    ```
5.  **Confirma els Canvis:**
    ```bash
    git commit -m "Initial commit: Estructura HTML bàsica"
    ```
6.  **Enllaça al Remot i Puja (si és el primer cop):**
    ```bash
    # (Afegeix l'adreça del repositori remot, p. ex., creat a GitHub)
    git remote add origin <URL_del_repositori>

    # Puja els canvis i estableix l'upstream
    git push -u origin main
    ```
