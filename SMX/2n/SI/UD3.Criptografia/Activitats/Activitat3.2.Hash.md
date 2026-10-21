# Activitat 3.2 — Comprovació de la integritat amb funcions hash

**Cicle formatiu:** 2n de SMX (Sistemes Microinformàtics i Xarxes)  
**Mòdul:** Seguretat informàtica  
**Tema:** Criptografia  
**Eina:** Linux (`sha256sum`, `sha512sum` i `sha1sum`)

---

# Part I. Enunciat

## 1. Objectius

En aquesta activitat aprendràs a:

- calcular el resum hash d’un fitxer;
- comprovar si un fitxer s’ha modificat;
- comparar els resultats de diferents algorismes hash;
- entendre què pot demostrar un hash i quines són les seves limitacions;
- diferenciar hash, xifrat i signatura digital.

## 2. Preparació

Obre un terminal i crea un directori de treball:

```bash
mkdir -p ~/seguretat/activitat3.2
cd ~/seguretat/activitat3.2
```

Crea un fitxer de text que simularà un document descarregat:

```bash
cat > informe.txt <<'FITXER'
Informe de manteniment
Data: 21 d’octubre
Estat: revisió completada
FITXER
```

Mostra’n el contingut:

```bash
cat informe.txt
```

## 3. Exercici 1 — Calcular el hash SHA-256

1. Calcula el resum SHA-256 del fitxer:

   ```bash
   sha256sum informe.txt
   ```

2. Desa el resultat en un fitxer de comprovació:

   ```bash
   sha256sum informe.txt > informe.txt.sha256
   cat informe.txt.sha256
   ```

3. Verifica que el fitxer coincideix amb el resum desat:

   ```bash
   sha256sum --check informe.txt.sha256
   ```

4. Anota el resultat que mostra el sistema i explica què significa.

## 4. Exercici 2 — Detectar una modificació

1. Afegeix una línia al document:

   ```bash
   echo 'Modificació afegida després de calcular el hash.' >> informe.txt
   ```

2. Torna a verificar el fitxer contra el resum original:

   ```bash
   sha256sum --check informe.txt.sha256
   ```

3. Calcula el nou hash:

   ```bash
   sha256sum informe.txt
   ```

4. Compara el resultat amb el resum original. Explica què ha canviat i per què.

## 5. Exercici 3 — Comparar algorismes

Calcula per al fitxer modificat els resums SHA-256, SHA-512 i SHA-1:

```bash
sha256sum informe.txt
sha512sum informe.txt
sha1sum informe.txt
```

Respon:

1. Els tres resultats són iguals o diferents?
2. Tenen tots la mateixa longitud?
3. Quin algorisme recomanaries per a una comprovació d’integritat actual? Justifica la resposta.
4. Per què no és recomanable confiar en MD5 o SHA-1 per a usos de seguretat?

## 6. Exercici 4 — Comprovar una còpia

1. Crea una còpia del fitxer:

   ```bash
   cp informe.txt copia.txt
   ```

2. Calcula el hash dels dos fitxers:

   ```bash
   sha256sum informe.txt copia.txt
   ```

3. Comprova que els resums coincideixen.
4. Modifica un caràcter de `copia.txt` amb un editor de text i torna a calcular els dos hashes.
5. Explica si el canvi és fàcil de detectar comparant visualment els fitxers i comparant els hashes.

## 7. Exercici 5 — Anàlisi d’un cas real

Una pàgina web ofereix un fitxer per descarregar i, a la mateixa pàgina, publica el seu hash SHA-256. Una persona descarrega el fitxer i comprova que el hash coincideix.

Respon amb frases completes:

1. Què ha comprovat aquesta persona?
2. Pot assegurar que el fitxer és segur i que no conté programari maliciós? Per què?
3. Si un atacant pogués modificar tant el fitxer com el hash publicat a la pàgina, la comprovació continuaria sent fiable? Explica-ho.
4. Quina mesura criptogràfica podria aportar una garantia més sòlida sobre l’autoria del fitxer publicat?

## 8. Qüestions finals

1. Què és una funció hash?
2. El hash es pot desxifrar per recuperar el fitxer original?
3. El hash, per si sol, manté confidencial el contingut del fitxer?
4. Explica la diferència entre:
   - calcular el hash d’un fitxer;
   - xifrar un fitxer;
   - signar digitalment un fitxer.
5. Quines evidències has d’incloure en el lliurament?

## 9. Lliurament

Lliura un document amb:

- les ordres executades i les sortides principals;
- les respostes als exercicis i a les qüestions finals;
- una conclusió breu sobre quan és útil comprovar el hash d’un fitxer i quines limitacions té.

