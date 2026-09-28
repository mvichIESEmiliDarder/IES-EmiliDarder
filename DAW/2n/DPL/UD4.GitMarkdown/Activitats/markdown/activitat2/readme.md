# Cheese Shop

Aquesta és una aplicació desenvolupada amb **React** que simula una botiga online de formatges. L'aplicació permet visualitzar un catàleg de productes de forma dinàmica, gestionar la càrrega incremental de dades i aplicar filtres complexos segons les característiques tècniques dels productes.

## Especificació del Model de Dades

L'aplicació consumeix les dades d'un fitxer JSON local. Cada objecte "formatge" segueix una estructura jeràrquica per agrupar propietats relacionades, especialment pel que fa a característiques i preus (sense incloure el preu calculat amb descompte, que es gestiona per codi).

**Exemple d'estructura JSON:**

```json
{
  "id": 1,
  "name": "Formatge Maó-Menorca",
  "image": "mao.jpg",
  "Characteristics": {
    "Pairing": "Vi blanc",
    "Age": "6 mesos",
    "FatContent": "27%"
  },
  "Price": {
    "Original": 15.50,
    "Discount": 10
  }
}

```

## Llistat de Funcionalitats

A continuació es detallen els requeriments implementats i la seva ponderació en l'avaluació:

| Tasca | Puntuació | Descripció |
| --- | --- | --- |
| **Components React** | 1 | Descomposició de la UI en components JSX reutilitzables. |
| **Model de Dades JSON** | 1 | Creació del JSON amb objectes niats (*Characteristics* i *Price*). |
| **Càrrega Dinàmica** | 2 | Ús d'Axios/Fetch, `useEffect` i `useImmer` per pintar les targetes. |
| **React-icons** | 1 | Implementació d'estrelles i mitges estrelles per a la valoració. |
| **Paginació/Càrrega** | 1 | Botons *Load More* (4 en 4) i *Show Less* (tornar a 8). |
| **Eliminació** | 1 | Funció per suprimir productes i refrescar la llista. |
| **Filtres de Preu** | 1 | Filtrat combinat per preu mínim i màxim (sobre preu net). |
| **Filtre Fat Content** | 1 | Filtratge per intensitat de greix. |
| **Combinació Filtres** | 1 | Funcionament simultani de tots els selectors. |

## Guia de Filtres

L'aplicació permet un filtrat precís mitjançant el botó **Filter**:

* **Filtres de Preu:** Es calcula sobre el preu real de venda (Preu original - Descompte). Es pot filtrar només per mínim, només per màxim o ambdós intervals.
* **Filtre de Greix (Fat Content):** 
    * *Low:* < 26%
    * *Medium:* Entre 26% i 29% (ambdós inclosos).
    * *High:* > 29%


## Instruccions de Lliurament

Per a l'entrega de la pràctica, cal seguir estrictament aquests punts:

1. **Format del fitxer:** El projecte s'ha de comprimir en un fitxer **ZIP**.
2. **Nom del fitxer:** El nom ha de seguir el patró `PR2-<llinatge1>-<nom>.zip`.
3. **Contingut:** S'ha d'excloure obligatòriament la carpeta `node_modules`.


---