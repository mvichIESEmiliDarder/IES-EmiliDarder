# Manual Académico y Profesional de Git

## 1. Introducción

### 1.1 ¿Qué es Git?

Git es un **sistema de control de versiones distribuido (DVCS)** diseñado para gestionar el historial completo de cambios de un proyecto de forma eficiente, segura y colaborativa. Permite registrar la evolución de archivos a lo largo del tiempo, recuperar versiones anteriores, analizar cambios y coordinar el trabajo simultáneo de múltiples personas.

Git no es solo una herramienta: es una **infraestructura fundamental** del desarrollo de software moderno.

---

### 1.2 Origen: Linus Torvalds y el contexto histórico

Git fue creado en **2005 por Linus Torvalds**, el creador del kernel de Linux. Su desarrollo responde a un problema muy concreto y real:

- El kernel de Linux es uno de los proyectos más grandes y complejos del mundo.
- Hasta 2005, se utilizaba una herramienta propietaria (BitKeeper).
- Al perderse la licencia, fue necesario crear una alternativa **rápida, distribuida y fiable**.

En palabras de Linus Torvalds, Git debía cumplir:

- Altísimo rendimiento.
- Integridad criptográfica.
- Trabajo distribuido sin servidor central obligatorio.
- Soporte para miles de desarrolladores.

Git fue escrito en cuestión de semanas y, desde entonces, se ha convertido en el estándar global.

---

### 1.3 Motivación: ¿por qué Git?

Git resuelve problemas clave del trabajo colaborativo:

- Pérdida de cambios.
- Conflictos entre desarrolladores.
- Falta de trazabilidad.
- Dificultad para experimentar sin riesgo.

Con Git se puede:

- Saber **quién** hizo **qué**, **cuándo** y **por qué**.
- Trabajar en paralelo sin interferencias.
- Volver atrás con seguridad.
- Auditar y revisar código.

---

## 2. Conceptos fundamentales de Git

### 2.1 Repositorio

Un repositorio Git es el contenedor del proyecto y su historial.

- **Repositorio local**: vive en tu máquina.
- **Repositorio remoto**: vive en un servidor (GitHub, GitLab, etc.).

---

### 2.2 Estados de los archivos

En Git, un archivo puede estar en tres estados principales:

1. **Modified** – modificado pero no preparado.
2. **Staged** – preparado para el siguiente commit.
3. **Committed** – guardado en el historial.

---

### 2.3 El área de preparación (staging area)

Git introduce un concepto clave: el **staging area**.

Permite decidir exactamente qué cambios entran en el siguiente commit.

---

### 2.4 Commits

Un commit es una **instantánea completa del proyecto** en un momento concreto.

Cada commit:

- Tiene un identificador hash (SHA-1 o SHA-256).
- Apunta a un commit anterior (excepto el inicial).
- Incluye autor, fecha y mensaje.

---

## 3. Instalación y configuración inicial

### 3.1 Instalación

```bash
git --version
```

### 3.2 Configuración básica

```bash
git config --global user.name "Nombre Apellido"
git config --global user.email "correo@ejemplo.com"
```

Configuración recomendada:

```bash
git config --global init.defaultBranch main
git config --global core.editor nano
```

---

## 4. Flujo básico de trabajo con Git

```text
Modificar → add → commit → push
```

---

## 5. Comandos fundamentales de Git

### 5.1 `git init`

Inicializa un repositorio Git.

```bash
git init
```

Crea el directorio oculto `.git`.

---

### 5.2 `git status`

Muestra el estado del repositorio.

```bash
git status
```

Es el comando más usado y seguro.

---

### 5.3 `git add`

Añade cambios al staging area.

```bash
git add archivo.txt
git add .
```

Permite commits selectivos.

---

### 5.4 `git commit`

Guarda los cambios preparados.

```bash
git commit -m "Mensaje descriptivo"
```

**Buenas prácticas del mensaje:**
- Imperativo
- Breve
- Significativo

---

### 5.5 `git log`

Muestra el historial de commits.

```bash
git log --oneline --graph
```

---

### 5.6 `git diff`

Muestra diferencias entre estados.

```bash
git diff
git diff --staged
```

---

### 5.7 `git reset`

Deshace cambios de forma controlada.

```bash
git reset archivo.txt
git reset --hard HEAD
```

⚠️ `--hard` elimina cambios locales.

---

### 5.8 `git checkout` y `git switch`

Cambiar ramas o restaurar archivos.

```bash
git checkout rama
git switch rama
```

---

## 6. Ramas (branches)

### 6.1 ¿Qué es una rama?

Una rama es un **puntero móvil** a un commit.

Permite desarrollar funcionalidades sin afectar a la rama principal.

---

### 6.2 Gestión de ramas

```bash
git branch
git branch nueva-rama
git switch nueva-rama
```

---

### 6.3 `git merge`

Fusiona ramas.

```bash
git merge nueva-rama
```

Puede producir conflictos.

---

## 7. Repositorios remotos

### 7.1 `git remote`

```bash
git remote -v
```

---

### 7.2 `git clone`

```bash
git clone https://servidor/repositorio.git
```

---

### 7.3 `git push`

```bash
git push origin main
```

---

### 7.4 `git pull` y `git fetch`

```bash
git pull
git fetch
```

`pull = fetch + merge`

---

## 8. Resolución de conflictos

Los conflictos ocurren cuando Git no puede decidir cómo fusionar cambios.

Proceso:

1. Identificar conflicto.
2. Editar archivo.
3. `git add`
4. `git commit`

---

## 9. Buenas prácticas profesionales

- Commits pequeños y frecuentes.
- Mensajes claros.
- Usar ramas para cada tarea.
- No hacer push de código roto.

---

## 10. Git en el mundo real: casos de uso

### 10.1 GitHub

- Hosting de repositorios.
- Pull Requests.
- Revisión de código.

**Beneficios:**
- Colaboración global.
- Transparencia.
- Automatización.

---

### 10.2 GitLab

- Integración continua (CI/CD).
- DevOps completo.

---

### 10.3 Proyectos open source

Ejemplos:
- Linux
- Python
- Kubernetes

**Por qué Git:**
- Escalabilidad.
- Auditoría completa.
- Desarrollo distribuido.

---

## 11. Git en educación y empresa

Git se usa para:

- Evaluar progreso.
- Trabajo en grupo.
- Control de entregas.

Empresas lo usan para:

- Seguridad.
- Trazabilidad.
- Calidad.

---

## 12. Conclusión

Git no es solo una herramienta técnica: es un **sistema de pensamiento** sobre cómo trabajar en equipo, gestionar el cambio y mantener la calidad.

Dominar Git es imprescindible para cualquier profesional técnico.

---

**Fin del manual**

