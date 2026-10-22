# Activitat 2.2 — Comprovació de la integritat amb funcions hash

> **Nota:** Els valors exactes dels hashes depenen del contingut del fitxer. Les respostes següents expliquen el resultat esperat. Cal incloure al lliurament els valors obtinguts al propi ordinador.

## 1. Preparació

S’ha creat el directori de treball i el fitxer `informe.txt` amb aquest contingut inicial:

```text
Informe de manteniment
Data: 21 d’octubre
Estat: revisió completada
```

Les ordres són:

```bash
mkdir -p ~/seguretat/activitat3.2
cd ~/seguretat/activitat3.2
cat > informe.txt <<'FITXER'
Informe de manteniment
Data: 21 d’octubre
Estat: revisió completada
FITXER
cat informe.txt
```

## 2. Exercici 1 — Calcular el hash SHA-256

Per calcular el resum i desar-lo:

```bash
sha256sum informe.txt
sha256sum informe.txt > informe.txt.sha256
cat informe.txt.sha256
```

La primera ordre mostra una cadena hexadecimal de 64 caràcters seguida del nom del fitxer. Aquesta cadena és el resum SHA-256 del contingut actual d’`informe.txt`.

Per verificar-lo:

```bash
sha256sum --check informe.txt.sha256
```

El resultat esperat és semblant a:

```text
informe.txt: OK
```

Això indica que el contingut actual del fitxer produeix el mateix resum que es va desar a `informe.txt.sha256`.

## 3. Exercici 2 — Detectar una modificació

Després d’afegir una línia:

```bash
echo 'Modificació afegida després de calcular el hash.' >> informe.txt
sha256sum --check informe.txt.sha256
```

La verificació indicarà que el fitxer no coincideix amb el resum anterior. Segons la versió de les eines, la sortida serà semblant a:

```text
informe.txt: FAILED
sha256sum: WARNING: 1 computed checksum did NOT match
```

El nou resum calculat amb `sha256sum informe.txt` serà diferent de l’original perquè el contingut ha canviat. Una modificació petita —fins i tot un sol caràcter— normalment produeix un resum completament diferent.

La funció hash no indica quina part del fitxer ha canviat ni qui l’ha modificat. Només permet comparar el resum calculat amb un resum de referència.

## 4. Exercici 3 — Comparar algorismes

Les ordres són:

```bash
sha256sum informe.txt
sha512sum informe.txt
sha1sum informe.txt
```

Els tres resultats seran diferents. També tenen longituds diferents:

| Algorisme | Longitud del resum hexadecimal | Valoració general |
|---|---:|---|
| SHA-1 | 40 caràcters | Obsolet per a usos que requereixen seguretat contra col·lisions |
| SHA-256 | 64 caràcters | Recomanable per a comprovacions d’integritat habituals |
| SHA-512 | 128 caràcters | Algorisme robust; genera un resum més llarg |

Per a una comprovació actual d’integritat, es pot recomanar SHA-256 o SHA-512. MD5 i SHA-1 no són adequats quan cal resistència a col·lisions: s’han trobat maneres de construir fitxers diferents amb el mateix resum en determinades condicions. SHA-1 tampoc no és un bon valor de referència per a noves aplicacions de seguretat.

## 5. Exercici 4 — Comprovar una còpia

Després de copiar el fitxer:

```bash
cp informe.txt copia.txt
sha256sum informe.txt copia.txt
```

Els dos resums coincideixen perquè els dos fitxers contenen exactament les mateixes dades. Després de modificar un caràcter de `copia.txt`, el seu resum canviarà i deixarà de coincidir amb el de `informe.txt`.

Comparar visualment dos fitxers pot ser difícil si són llargs o si el canvi és petit. Comparar-ne els hashes és ràpid i permet detectar que el contingut no és idèntic, encara que no mostra on és la diferència.

## 6. Exercici 5 — Anàlisi d’un cas real

1. La persona ha comprovat que el fitxer descarregat té el mateix contingut que el fitxer associat al hash de referència.
2. No pot assegurar només amb això que el fitxer sigui segur o que no contingui programari maliciós. Un fitxer maliciós també pot tenir un hash calculat correctament.
3. Si l’atacant modifica el fitxer i també el hash publicat al mateix lloc, la verificació pot donar un resultat correcte per al fitxer modificat. El hash només és útil com a referència si obtenim el valor de manera fiable.
4. Una signatura digital del fabricant pot aportar una garantia més sòlida sobre l’autoria i permetre detectar modificacions, sempre que s’hagi verificat correctament la clau pública del fabricant.

## 7. Qüestions finals

1. **Una funció hash** calcula un resum de longitud fixa a partir de dades de longitud variable. Un canvi en les dades sol produir un resum diferent.
2. El hash no està dissenyat per desxifrar-se. És una funció unidireccional: no permet recuperar directament el fitxer original.
3. No. El hash no amaga el contingut. Qualsevol persona que tingui el fitxer el pot llegir si no està xifrat.
4. Diferències:
   - **Calcular el hash** produeix un resum que es pot comparar amb un valor de referència per detectar canvis.
   - **Xifrar** transforma el contingut perquè només qui disposi de la clau adequada el pugui llegir.
   - **Signar digitalment** permet comprovar que una signatura correspon a una clau privada i que les dades signades no han canviat. Per vincular la clau amb una persona o organització, cal verificar la clau pública corresponent.
5. El lliurament ha d’incloure les ordres, les sortides rellevants, les respostes i una conclusió sobre la utilitat i les limitacions dels hashes.

## 8. Conclusió possible

Les funcions hash permeten detectar si un fitxer és diferent d’un valor de referència i són útils per comprovar descàrregues, còpies i transferències. Tanmateix, un hash no xifra el fitxer, no n’acredita per si sol l’origen i no demostra que el fitxer sigui segur. Per confiar en el valor de referència, cal obtenir-lo d’una font fiable o verificar una signatura digital vàlida.
