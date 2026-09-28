# Llenguatge de marques Markdown

---

## Què és Markdown?

- **Markdown** és un llenguatge de marques lleuger que permet escriure en un format de text pla fàcil d'escriure i llegir, i després convertir-lo en XHTML o HTML
- El llenguatge té moltes similituds amb les convencions ja existents per donar format al text pla en correus electrònics
- És àmpliament utilitzat per a documents a GitHub (`README.md`, etc.)
- Els fitxers de markdown tenen l'extensió de fitxer `.md`

---

## Sintaxi: negreta, cursiva i ratllat

<!-- markdownlint-disable MD049 -->
<!-- markdownlint-disable MD050 -->

```markdown
Emphasis, aka italics, with _underscores_.

Strong emphasis, aka bold, with **asterisks**.

Combined emphasis with **asterisks and _underscores_**.

Strikethrough uses two tildes. ~~Scratch this.~~
```

Emphasis, aka italics, with _underscores_.

Strong emphasis, aka bold, with **asterisks**.

Combined emphasis with **asterisks and _underscores_**.

Strikethrough uses two tildes. ~~Scratch this.~~

<!-- markdownlint-enable MD049 -->
<!-- markdownlint-enable MD050 -->

---

## Sintaxi: capçaleres

```markdown
# H1

## H2

### H3

#### H4
```

<!-- markdownlint-disable MD022 -->
<!-- markdownlint-disable MD025 -->

# H1

## H2

### H3

#### H4

<!-- markdownlint-enable MD022 -->
<!-- markdownlint-enable MD025 -->

---

## Sintaxi: llistes

<!-- markdownlint-disable MD004 -->
<!-- markdownlint-disable MD032 -->

```markdown
1. First ordered list item
2. Another item

- Unordered list can use asterisks

* Or minuses

- Or pluses
```

1. First ordered list item
2. Another item

- Unordered list can use asterisks

* Or minuses

- Or pluses

<!-- markdownlint-enable MD004 -->
<!-- markdownlint-enable MD032 -->

---

## Sintaxi: enllaços i imatges

```markdown
[I'm an inline-style link](https://www.google.com)

![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")
```

[I'm an inline-style link](https://www.google.com)

![alt text](https://github.com/adam-p/markdown-here/raw/master/src/common/images/icon48.png "Logo Title Text 1")

---

## Sintaxi: taules

```markdown
| Tables        |      Are      |  Cool |
| ------------- | :-----------: | ----: |
| col 3 is      | right-aligned | $1600 |
| col 2 is      |   centered    |   $12 |
| zebra stripes |   are neat    |    $1 |
```

| Tables        |      Are      |  Cool |
| ------------- | :-----------: | ----: |
| col 3 is      | right-aligned | $1600 |
| col 2 is      |   centered    |   $12 |
| zebra stripes |   are neat    |    $1 |

---

## Sintaxi: blocs de codi

````markdown
Inline `code` has `back-ticks around` it.

```
No language indicated, so no syntax highlighting.
But let's throw in a <b>tag</b>.
```
````

Inline `code` has `back-ticks around` it.

<!-- markdownlint-disable MD040 -->

```
No language indicated, so no syntax highlighting.
But let's throw in a <b>tag</b>.
```

<!-- markdownlint-enable MD040 -->

---

## 🔗 Enllaços

- [Markdown Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet)
- [Markdown Guide](https://www.markdownguide.org/)
- [Markdown Crash Course (Youtube)](https://www.youtube.com/watch?v=HUBNt18RFbo)