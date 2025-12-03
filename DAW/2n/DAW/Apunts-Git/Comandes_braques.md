El treball amb branques (branches) és la característica més potent de Git, ja que ens permet aïllar noves funcionalitats o correccions d'errors del codi principal sense afectar-lo.

-----

## 🌿 Guió per Aprendre les Comandes de Branques (Branches)

Aquest guió cobreix el flux de treball típic per desenvolupar una nova característica de forma aïllada i després integrar-la al codi principal (`main` o `master`).

### I. Creació i Canvi de Branques

1.  **Llistat:** Revisa les branques existents.
      * `git branch`
2.  **Creació:** Crea una nova branca.
      * `git branch <nom_branca>`
3.  **Canvi (Switching):** Canvia a una altra branca (per treballar-hi).
      * `git checkout <nom_branca>` (o la sintaxi moderna `git switch`)
4.  **Creació Ràpida:** Crea i canvia a la nova branca en un sol pas.
      * `git checkout -b <nom_branca>` (o `git switch -c`)

-----

### II. Integració de Canvis (Merge)

5.  **Fusió (Merge):** Combina els canvis d'una branca a una altra.
      * `git merge <branca_a_fusionar>`
6.  **Estat del Remot:** Configura el seguiment de la branca remota.
      * `git push -u origin <branca>` (ja cobert, però crucial per a branques)

-----

### III. Neteja

7.  **Esborrar:** Elimina una branca local després d'haver-la fusionat.
      * `git branch -d <nom_branca>`

-----

## 🛠️ Desenvolupament de Comandes amb Exemples

### 1\. `git branch` (Llistat i Creació)

S'utilitza per llistar, crear o esborrar branques locals.

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git branch`** | Llista totes les branques locals. La branca actual es marca amb un asterisc (`*`). | `git branch` |
| **`git branch <nom>`** | Crea una nova branca amb el nom especificat, sense canviar a ella. | `git branch funcionalitat-login` |

-----

### 2\. `git checkout` / `git switch` (Canvi de Branca)

Permet moure's entre diferents branques del repositori.

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git checkout <nom>`** | **Canvia** al cap de la branca especificada. | `git checkout funcionalitat-login` |
| **`git checkout -b <nom>`** | **Crea** la nova branca i **canvia** a ella immediatament (combinació de `branch` i `checkout`). | `git checkout -b nova-interficie` |
| **`git switch <nom>`** | (Sintaxi moderna recomanada per canviar de branca). | `git switch nova-interficie` |
| **`git switch -c <nom>`** | (Sintaxi moderna recomanada per crear i canviar). | `git switch -c bugfix-css` |

-----

### 3\. `git merge` (Fusió de Branques)

Aplica els canvis confirmats d'una branca a la branca actual. **Sempre s'ha d'estar a la branca de destinació abans d'executar el `merge`**.

> **Escenari:** Vull portar el codi de la branca **`feature-login`** al codi **`main`**.

| Passa | Comanda | Descripció |
| :--- | :--- | :--- |
| **1.** | `git switch main` | Canvia a la branca que rebrà els canvis. |
| **2.** | `git merge feature-login` | Introdueix tots els commits de `feature-login` a `main`. |

> **Nota:** Si Git pot combinar els canvis automàticament, es produeix un "Fast-forward". Si hi ha canvis conflictius, Git pararà i demanarà resoldre els **conflictes de fusió (merge conflicts)** manualment.

-----

### 4\. `git branch -d` (Esborrar Branca)

Elimina una branca local. Normalment s'esborren les branques de característica (feature branches) un cop els seus canvis han estat fusionats a `main`.

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git branch -d <nom>`** | Esborra la branca. Només funciona si els canvis ja estan fusionats. | `git branch -d funcionalitat-login` |
| **`git branch -D <nom>`** | Esborra la branca **forçant** l'esborrament, fins i tot si té canvis no fusionats. Utilitzar amb cura. | `git branch -D branca-perillosa` |

-----

### 5\. `git push origin -d` (Esborrar Branca Remota)

És important esborrar la branca també al servidor remot (p. ex., GitHub) per neteja.

| Comanda | Descripció | Exemple |
| :--- | :--- | :--- |
| **`git push origin --delete <nom>`** | Esborra la branca al repositori remot. | `git push origin --delete funcionalitat-login` |

-----

## 🔄 Flux de Treball Sequencial de Branques

Així és com es treballa habitualment amb branques:

1.  **Ens asseguram d'estar a `main`:**
    ```bash
    git switch main
    git pull origin main # Actualitza el codi principal
    ```
2.  **Cream i Canviam a la Branca de Feature:**
    ```bash
    git switch -c nova-funcio
    ```
3.  **Desenvolupam i fes Commits:**
    ```bash
    # (Fes canvis als fitxers)
    git add .
    git commit -m "Feat: Afegit component d'usuari"
    ```
4.  **Pujam la Branca al Remot:**
    ```bash
    git push -u origin nova-funcio
    ```
5.  **Fusionam al Codi Principal (després de crear un Pull Request):**
    ```bash
    git switch main
    git pull origin main # Sempre actualitzar abans de fusionar
    git merge nova-funcio
    git push origin main # Puja el nou commit de merge
    ```
6.  **Netejam:**
    ```bash
    git branch -d nova-funcio
    git push origin --delete nova-funcio
    ```
