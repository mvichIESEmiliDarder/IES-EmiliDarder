# Activitat 1.2 — Desplegament d'una aplicació web amb Render

## Objectiu

En aquesta activitat desplegarem una aplicació web dinàmica utilitzant **Render** com a plataforma PaaS (*Platform as a Service*).

A diferència de l'activitat anterior amb GitHub Pages, ara el servidor haurà d'**executar codi Python** per generar la resposta.

El flux serà:

```text
Aplicació Flask local
        │
        │ git push
        ▼
      GitHub
        │
        │ desplegament
        ▼
      Render
        │
        ▼
 Aplicació pública
```

No instal·larem ni configurarem Apache, Nginx, certificats HTTPS ni un servidor Linux. **Render s'encarregarà de la infraestructura.**

---

## 1. Crear l'aplicació

Crea una carpeta:

```bash
mkdir DPL_Act1.2.Render
cd DPL_Act1.2.Render
```

Crea el fitxer `app.py`:

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def inici():
    return """
    <h1>Desplegament d'Aplicacions Web</h1>
    <p>La meva primera aplicació desplegada amb Render.</p>
    """

@app.route("/alumne/<nom>")
def alumne(nom):
    return f"""
    <h1>Hola, {nom}!</h1>
    <p>Aquesta pàgina ha estat generada pel servidor.</p>
    """
```

L'aplicació té dues rutes:

```text
/                   → pàgina principal
/alumne/nom         → pàgina generada dinàmicament
```

Per exemple:

```text
/alumne/Marti
```

El servidor executarà Python i generarà una resposta diferent segons el nom indicat.

---

## 2. Crear `requirements.txt`

Render necessita saber quines dependències necessita l'aplicació.

Crea:

```text
requirements.txt
```

amb:

```text
Flask
gunicorn
```

`Flask` és el framework que utilitza l'aplicació.

`gunicorn` serà el servidor que executarà l'aplicació a Render.

L'estructura serà:

```text
DPL_Act1.2.Render/
├── app.py
└── requirements.txt
```

---

## 3. Provar l'aplicació en local

Opcionalment, podem comprovar que funciona abans de desplegar-la.

És recomanable utilitzar un entorn virtual sobretot a Ubuntu:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

Instal·la Flask:

```bash
pip install -r requirements.txt (ubuntu)
py -m pip install -r requirements.txt (windows)
```

Executa:

```bash
flask --app app run
```

Obre:

```text
http://127.0.0.1:5000
```

i prova també:

```text
http://127.0.0.1:5000/alumne/Marti
```

Atura el servidor amb `Ctrl+C`.

---

## 4. Evitar pujar l'entorn virtual

Crea un `.gitignore`:

```text
.venv/
__pycache__/
```

Ara tenim:

```text
DPL_Act1.2.Render/
├── .gitignore
├── app.py
└── requirements.txt
```

---

## 5. Crear el repositori Git

Inicialitza'l:

```bash
git init
git branch -M main
git add .
git commit -m "Primera versió de l'aplicació"
```

Crea a GitHub un repositori públic, per exemple:

```text
DPL_Act1.2.Render
```

No hi afegeixis README, `.gitignore` ni llicència des de GitHub.

Associa'l amb el repositori local:

```bash
git remote add origin URL_DEL_REPOSITORI
git push -u origin main
```

Comprova a GitHub que hi apareixen:

```text
.gitignore
app.py
requirements.txt
```

---

# 6. Desplegar a Render

Entra a [Render](https://render.com/?utm_source=chatgpt.com) i crea un compte.

Selecciona:

**New → Web Service**

Connecta el teu compte de GitHub i selecciona el repositori:

```text
DPL_Act1.2.Render
```

Render detectarà que és una aplicació Python.

Configura el servei amb:

```text
Language: Python
Branch: main
```

Com a **Build Command**:

```bash
pip install -r requirements.txt
```

Com a **Start Command**:

```bash
gunicorn app:app
```

Selecciona la instància gratuïta (*Free*) i crea el servei.

Render començarà el desplegament.

---

## 7. Observar què està fent Render

Durant el desplegament apareixerà el log.

Hi podrem observar passes semblants a:

```text
Cloning repository...
Installing dependencies...
Installing Flask...
Installing gunicorn...
Starting service...
```

Finalment, Render proporcionarà una URL pública semblant a:

```text
https://dpl-act1-2-render.onrender.com
```

Obre-la.

Després prova:

```text
https://dpl-act1-2-render.onrender.com/alumne/Marti
```

**La pàgina no existeix com un fitxer HTML al repositori.**

Ha estat generada pel codi Python executat al servidor.

---

# 8. Modificar i tornar a desplegar

Modifica `app.py`, per exemple:

```python
@app.route("/salutacio")
def salutacio():
    return "<h1>Hola des de Render!</h1>"
```

Ara:

```bash
git add .
git commit -m "Afegeix una nova ruta"
git push
```

Observa què succeeix a Render.

Render detectarà el nou `push`, construirà novament l'aplicació i desplegarà la nova versió.

Comprova:

```text
https://....onrender.com/salutacio
```
