## Activitat 1.1 — Desplegament d'una web estàtica amb GitHub Pages

**Objectiu**

En aquesta pràctica publicarem una aplicació web estàtica a Internet utilitzant **GitHub Pages**.

Fins ara hem desenvolupat aplicacions web que visualitzam en el nostre ordinador. Però perquè una aplicació sigui accessible des d'Internet, l'hem de **desplegar**.

GitHub Pages permet publicar directament una web formada per **HTML, CSS i JavaScript** a partir d'un repositori GitHub, sense necessitat d'instal·lar ni administrar un servidor web.

En acabar la pràctica haureu de tenir:

- Una web estàtica emmagatzemada en un repositori GitHub.
- La web publicada i accessible mitjançant una URL pública.
- Un petit canvi posterior publicat mitjançant `git push`.

### Desenvolupament

**1. Crear la web**

Creau una carpeta anomenada:

```text
activitat.1.1.github-page
```

Dins la carpeta creau, com a mínim:

```text
activitat.1.1.github-page/
├── index.html
└── css/
    └── style.css
```

La pàgina ha de mostrar com a mínim el vostre **nom**, el text **«Desplegament d'Aplicacions Web»** i algun element al qual apliqueu CSS.

No importa especialment el disseny. **L'objectiu de la pràctica és el desplegament, no el desenvolupament de la web.**

**2. Crear el repositori Git**

Inicialitzau el repositori i realitzau el primer commit:

```bash
git init
git add .
git commit -m "Primera versió de la web"
```

Creau un repositori nou a GitHub i connectau-lo amb el repositori local:

```bash
git remote add origin URL_DEL_REPOSITORI
git branch -M main
git push -u origin main
```

**3. Publicar amb GitHub Pages**

Al repositori de GitHub entrau a:

**Settings → Pages**

Configurau GitHub Pages perquè publiqui el contingut de la branca `main`.

```
- Source: Deploy from a branch
- Branch: main
- Folder: /(root)
```

Prem **Save**.  un GitHub iniciarà un missatge semblant a Your site is live at... 
Després d'uns instants, GitHub proporcionarà un URL semblant a:

```text
https://usuari.github.io/practica-github-pages/
```

Accediu-hi des del navegador i comprovau que la vostra web és accessible públicament.

**4. Actualitzar la web**

Ara modificau el vostre `index.html`. Per exemple, afegiu:

```html
<p>Aquesta web està desplegada amb GitHub Pages.</p>
```

Publicau el canvi:

```bash
git add .
git commit -m "Actualització de la web"
git push
```

Esperau uns moments i actualitzau la URL pública.

**5. Comprovació**

En acabar, heu de poder demostrar:

```text
Modificació del codi
        ↓
      commit
        ↓
       push
        ↓
     GitHub
        ↓
 GitHub Pages
        ↓
   Web pública
```

### Entrega

Entregau:

- URL del repositori GitHub.
- URL pública de GitHub Pages.
- Captura de pantalla de la web funcionant.

