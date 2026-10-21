# Unitat Didàctica 3:Apunts GPG

**Assignatura:** Seguretat Informàtica  
**Curs:** 2n de SMR (Sistemes Microinformàtics i Xarxes)  

---

## 1. Introducció a GPG i la Criptografia

GnuPG (GPG) és una eina de codi obert basada en l'estàndard OpenPGP que permet xifrar i signar dades. En el món laboral i de la gestió de sistemes, GPG s'utilitza per a:

* **Confidencialitat:** Garantir que només el destinatari autoritzat pugui llegir la informació.
* **Integritat:** Assegurar que el document no ha estat modificat durant el transport.
* **Autenticitat i No-repudi:** Demostrar l'autoria d'un document o missatge.

GPG permet treballar tant amb **criptografia simètrica** (una única clau compartida) com amb **criptografia asimètrica** (un parell de claus: pública i privada).

---

## 2. Xifrat de Clau Simètrica

En la criptografia simètrica, la mateixa clau (contrasenya) s'utilitza tant per xifrar com per desxifrar la informació.

### 2.1. Preparació de l'entorn de treball
Primer, creem un directori de proves i un fitxer de text pla:

```bash
mkdir ~/cripto
cd ~/cripto
echo "Això és un document privat d'enginyeria de xarxes." > document.txt
cat document.txt
```

### 2.2. Xifrat simètric binari
Per xifrar el fitxer utilitzant un algorisme simètric (per defecte AES-128 o AES-256 segons la versió):

```bash
gpg -c document.txt
```

El sistema demanarà una contrasenya segura (mínim 8 caràcters). Això generarà el fitxer `document.txt.gpg`. Si intentem llegir-lo directament amb `cat`, veurem caràcters binaris no llegibles.

### 2.3. Xifrat simètric amb codificació ASCII (--armor)
Si necessitem enviar el fitxer xifrat mitjançant correu electrònic en text pla o incloure'l en un document, utilitzem l'opció `-a` o `--armor`:

```bash
gpg -ca document.txt
```

Això generarà el fitxer `document.txt.asc`, el contingut del qual està codificat en Base64 entre capçaleres PGP:

```text
-----BEGIN PGP MESSAGE-----

jA0ECQMC...
-----END PGP MESSAGE-----
```

### 2.4. Desxifrat simètric
Per desxifrar el fitxer utilitzem el paràmetre `-d`:

```bash
gpg -d document.txt.asc > document_desxifrat.txt
```

*Nota: Si fem la prova en el mateix equip on hem xifrat, pot ser que l'agent de GPG (`gpg-agent`) tingui la clau en memòria i no la torni a demanar immediatament.*

---

## 3. Xifrat de Clau Asimètrica

En la criptografia asimètrica disposem de dues claus relacionades matemàticament:
* **Clau pública:** Es comparteix amb tothom. S'utilitza per **xifrar** informació adreçada a nosaltres o per **verificar** la nostra signatura.
* **Clau privada:** És secreta i protegida per contrasenya. S'utilitza per **desxifrar** el que ens envien o per **signar** documents.

### 3.1. Generació del parell de claus
Per crear el nostre parell de claus executem:

```bash
gpg --full-generate-key
```

Procés de configuració recomanat:
1. **Tipus de clau:** (1) RSA and RSA (per defecte).
2. **Mida de la clau:** 3072 o 4096 bits.
3. **Caducitat:** Triar si la clau caduca o no (p. ex., `0` per no caducar).
4. **Dades personals:** Nom, cognoms i correu electrònic (aquest correu s'utilitza com a identificador o *UID*).
5. **Contrasenya (Passphrase):** Clau de pas que protegirà la clau privada.

### 3.2. Llistat de claus al sistema
Per veure les claus públiques emmagatzemades al nostre anell de claus (*keyring*):

```bash
gpg -k
# O bé:
gpg --list-keys
```

Per veure les claus privades:

```bash
gpg -K
# O bé:
gpg --list-secret-keys
```

### 3.3. Xifrar per a un destinatari (Clau Pública)
Per xifrar un document per a un altre usuari, necessitem tenir la seva clau pública al nostre anell i executar:

```bash
gpg --armor --encrypt --recipient alumne2@iesdarder.com document.txt
```

Això generarà `document.txt.asc`. Únicament la persona que tingui la clau privada corresponent a `alumne2@iesdarder.com` podrà desxifrar-lo.

### 3.4. Desxifrar amb la Clau Privada
El destinatari utilitzarà la seva clau privada per desxifrar el fitxer:

```bash
gpg -d document.txt.asc > document_rebut.txt
```

---

## 4. Gestió de Claus i Anell de Claus (*Keyring*)

### 4.1. Exportar la clau pública
Perquè altres usuaris ens puguin enviar fitxers xifrats, hem d'exportar la nostra clau pública:

```bash
gpg --armor --output la_meva_clau_publica.asc --export el_teu_correu@iesdarder.com
```

El fitxer `la_meva_clau_publica.asc` és el que s'envia per correu o es penja en un servidor de claus (*keyserver*).

### 4.2. Importar la clau pública d'un tercer
Quan un company o client ens envia la seva clau pública, l'hem d'afegir al nostre anell de claus:

```bash
gpg --import clau_company.asc
```

### 4.3. Esborrar claus del repositori
Si necessitem eliminar una clau:

1. **Esborrar la clau privada:**
   ```bash
   gpg --delete-secret-key el_teu_correu@iesdarder.com
   ```
2. **Esborrar la clau pública:**
   ```bash
   gpg --delete-key el_teu_correu@iesdarder.com
   ```
   *(Nota: No es pot eliminar una clau pública si abans no s'ha esborrat la clau privada associada).*

---

## 5. Còpies de Seguretat i Restauració

La clau privada és crítica. Si es perd, serà impossible desxifrar els documents rebuts.

### 5.1. Exportació de seguretat de les claus
Per realitzar una còpia de seguretat completa de la clau privada:

```bash
gpg --output backup_privada.gpg --armor --export-secret-keys --export-options export-backup el_teu_correu@iesdarder.com
```

Per exportar la base de dades de confiança (*trustdb*):

```bash
gpg --export-ownertrust > trustdb_backup.txt
```

### 5.2. Restauració de la còpia
En un equip nou o després d'un formatatge:

```bash
gpg --import la_meva_clau_publica.asc
gpg --import backup_privada.gpg
gpg --import-ownertrust trustdb_backup.txt
```

---

## 6. Xarxa de Confiança (*Web of Trust*)

Quan importem la clau pública d'un company i xifrem un fitxer per a ell, GPG sol mostrar un avís:
`ADVERTÈNCIA: no s'ha comprobat que aquesta clau pertanyi realment a l'usuari.`

Per indicar a GPG que hem verificat la identitat del nostre company (per exemple, comprovant la petjada digital o *fingerprint* en persona):

```bash
gpg --sign-key company@iesdarder.com
```

Amb aquesta signatura confirmem que confiem que aquesta clau pertany realment a aquesta persona i l'avís d'advertència desapareixerà en futures operacions.

---

## 7. Signatura Digital de Documents

La signatura digital garanteix l'**autenticitat** del remitent i la **integritat** del document (que no ha estat alterat). Es realitza xifrant un resum de hash del document amb la **clau privada** de l'emissor.

### 7.1. Signatura en text pla (--clearsign)
Permet mantenir el text original llegible i afegeix el bloc de signatura al final del fitxer. És ideal per a correus o comunicats oficials.

```bash
gpg --clearsign comunicat.txt
```

Genera el fitxer `comunicat.txt.asc` amb l'estructura:

```text
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Aquest és el text original del comunicat.
-----BEGIN PGP SIGNATURE-----

iQGzBAEBCgAdFiEE...
-----END PGP SIGNATURE-----
```

### 7.2. Signatura binària / empaquetada (-s)
Empaqueta el contingut del fitxer i la signatura en un únic fitxer binari xifrat/codificat:

```bash
gpg --armor -o document_signat.asc -s document.txt
```

### 7.3. Signatura separada (--detach-sign)
Crea un fitxer de signatura independent (`.sig` o `.asc`) sense modificar el fitxer original. Molt utilitzat per signar imatges ISO o programari descarregable.

```bash
gpg --armor --detach-sign document.txt
```

Genera el fitxer `document.txt.asc` que només conté la signatura. Per verificar-ho, el destinatari necessitarà tenir tant el fitxer original com el fitxer de signatura.

### 7.4. Verificació de la signatura
El destinatari utilitza la clau pública de l'emissor per comprovar la signatura:

```bash
gpg --verify document.txt.asc
```

I si vol extreure el contingut d'un fitxer signat empaquetat:

```bash
gpg -o document_original.txt -d document_signat.asc
```

---

## 8. Operació Combinada: Xifrat + Signatura

En entorns de producció no n'hi ha prou amb xifrar (només confidencialitat) o només signar (només autenticitat). Se solen combinar ambdós processos en un sol pas:

```bash
gpg --armor --encrypt --sign --recipient company@iesdarder.com document_confidencial.txt
```

El receptor, en executar `gpg -d`, realitzarà les dues operacions alhora:
1. Desxifrarà el fitxer amb la seva clau privada.
2. Comprovarà la signatura amb la clau pública del remitent, confirmant qui ho ha enviat.

---

## 9. Revocació de Claus (Cicle de Vida)

Si la clau privada queda compromesa (robatori de l'equip, filtració de contrasenya) o l'usuari canvia de departament, la clau s'ha de revocar.

### 9.1. Generar el certificat de revocació
Es recomana generador-lo just després de crear la clau:

```bash
gpg --output revocacio.asc --gen-revoke el_teu_correu@iesdarder.com
```

### 9.2. Aplicar la revocació
Si la clau ha estat compromesa, s'importa el certificat de revocació al propi anell i es publica:

```bash
gpg --import revocacio.asc
```

A partir d'aquest moment, qualsevol intent de xifrar informació amb aquesta clau pública serà rebutjat pel sistema indicant que la clau està revocada.

---

## 10. Taula de Referència Ràpida de Comandes

| Operació | Comanda GPG |
| :--- | :--- |
| **Xifrat simètric (ASCII)** | `gpg -ca fitxer.txt` |
| **Generar parell de claus** | `gpg --full-generate-key` |
| **Llistar claus públiques / privades** | `gpg -k` / `gpg -K` |
| **Exportar clau pública** | `gpg --armor --export correu@domini.com > publica.asc` |
| **Importar qualsevol clau/certificat** | `gpg --import fitxer.asc` |
| **Xifrar asimètric** | `gpg -ea -r destinatari@domini.com fitxer.txt` |
| **Desxifrar (Simètric o Asimètric)** | `gpg -d fitxer_xifrat.asc > fitxer.txt` |
| **Signar en text pla** | `gpg --clearsign fitxer.txt` |
| **Signar separat** | `gpg --armor --detach-sign fitxer.txt` |
| **Verificar signatura** | `gpg --verify fitxer.asc` |
| **Xifrar + Signar simultani** | `gpg -eas -r destinatari@domini.com fitxer.txt` |
| **Signar clau d'un tercer (Confiança)**| `gpg --sign-key usuari@domini.com` |