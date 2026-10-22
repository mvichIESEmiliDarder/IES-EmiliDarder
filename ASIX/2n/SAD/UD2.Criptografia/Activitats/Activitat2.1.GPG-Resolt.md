# Activitat 2.1. Criptografia Simètrica i Asimètrica amb GPG en Linux

**Cicle Formatiu:** 2n de ASIX (Administració de Sistemes Informàtics i Xarxes)  
**Mòdul:** Seguretat i Alta disponibilitat 
**Tema:** Criptografia simètrica, asimètrica, signatura digital i gestió de claus  
**Eina:** `gpg` (GNU Privacy Guard) en entorn Linux  

---

## 1. Introducció i Configuració Inicial

Per poder realitzar la pràctica de criptografia asimètrica i signatura digital, primer hem de generar un parell de claus (pública i privada) en el nostre sistema.

### Pas 0: Generació del parell de claus
Executem la comanda següent al terminal:
```bash
gpg --full-generate-key
```
* Seleccionem el tipus de clau (opció per defecte: `RSA y RSA`).
* Triem una mida de clau adequada (mínim `3072` o `4096` bits).
* Introduïm el nom, correu electrònic i una contrasenya robusta (*passphrase*) per protegir la clau privada.

---

## 2. Criptografia Simètrica (`gpg`)

### Exercici 1: Xifrat i desxifrat simètric
En aquest apartat xifrarem un fitxer de text utilitzant una única clau secreta compartida.

1. **Creació del fitxer de text:**
   ```bash
   echo "Aquest és un missatge secret simètric." > fitxer_simetric.txt
   ```

2. **Xifrat del fitxer:**
   ```bash
   gpg --symmetric --armor fitxer_simetric.txt
   ```
   *(Ens demanarà una contrasenya secreta. Es generarà el fitxer `fitxer_simetric.txt.asc`).*

3. **Enviament al company:**
   * S'envia el fitxer `fitxer_simetric.txt.asc` mitjançant correu electrònic.

#### Qüestions i resolució:
1. **Com li has passat la clau al teu company?**
   * **Resposta:** La clau simètrica s'ha de transmetre mitjançant un **canal segur fora de banda** (*out-of-band*), com per exemple en mà, per trucada telefònica o aplicació de missatgeria xifrada d'extrem a extrem (Signal/WhatsApp). Mai s'ha d'enviar per la mateixa via (correu electrònic) que el fitxer xifrat.

2. **Com el teu company aconsegueix desxifrar el fitxer?**
   * El company executa la comanda:
     ```bash
     gpg --output desxifrat.txt --decrypt fitxer_simetric.txt.asc
     ```
   * S'introdueix la contrasenya compartida prèviament per descodificar el contingut.

---

## 3. Gestió i Intercanvi de Claus Públiques (Ampliador)

Abans de poder xifrar de manera asimètrica o verificar signatures, hem d'exportar i intercanviar les nostres claus públiques.

1. **Exportar la nostra clau pública:**
   ```bash
   gpg --armor --export elteucorreu@exemple.com > meva_clau_publica.asc
   ```

2. **Importar la clau pública del company:**
   ```bash
   gpg --import clau_publica_company.asc
   ```

3. **Verificar el nostre anell de claus (*keyring*):**
   ```bash
   gpg --list-keys
   ```

4. **Signar la clau del company (Establir confiança / Web of Trust):**
   Per evitar avisos de seguretat de "clau no verificada":
   ```bash
   gpg --sign-key correu_company@exemple.com
   ```

---

## 4. Criptografia Asimètrica (`gpg`)

### Exercici 2: Xifrat asimètric amb la clau pública del company

1. **Què t'ha d'enviar primerament el teu company?**
   * **Resposta:** El company t'ha d'enviar prèviament la seva **clau pública** (per exemple, el fitxer `clau_publica_company.asc`).

2. **Què has fet per encriptar amb la clau pública?**
   * Creem el fitxer de text:
     ```bash
     echo "Hola, aquest missatge només el pots llegir tu." > missatge_privat.txt
     ```
   * Encriptem el fitxer fent servir la clau pública del recipient:
     ```bash
     gpg --encrypt --armor --recipient correu_company@exemple.com missatge_privat.txt
     ```
   * Això genera el fitxer xifrat `missatge_privat.txt.asc`, el qual s'envia per correu electrònic.

3. **Com el teu company aconsegueix desxifrar el fitxer?**
   * El company utilitza la seva pròpia **clau privada** (introduint la seva *passphrase*):
     ```bash
     gpg --output missatge_rebut.txt --decrypt missatge_privat.txt.asc
     ```

---

## 5. Signatura Digital i Integritat

### Exercici 3: Signatura d'un fitxer de text (Firma separada / Detached Signature)

En aquest exercici demostrarem l'autenticitat i no-repudi utilitzant hash i la nostra clau privada.

1. **Crear el fitxer original:**
   ```bash
   echo "Aquest és un document oficial que s'ha de signar." > document.txt
   ```

2. **Crear el hash i signar-lo (Signatura separada):**
   * GPG calcula automàticament el hash internament i el xifra amb la teva clau privada:
     ```bash
     gpg --output document.txt.sig --detach-sig document.txt
     ```

3. **Enviar els fitxers al company:**
   * S'envien **dos fitxers**: `document.txt` (text pla) i `document.txt.sig` (fitxer de signatura).

4. **Comprovar l'autenticitat i la integritat:**
   * El company descarrega tots dos fitxers i executa:
     ```bash
     gpg --verify document.txt.sig document.txt
     ```
   * **Resultat:** GPG mostrarà un missatge indicant `Good signature from...` confirmant que:
     * El fitxer procedeix realment de l'emissor (autenticitat).
     * El contingut no ha estat modificat des de la signatura (integritat).

---

## 6. Ampliació Pràctica (Nivell SMR)

### Exercici 4: Signatura en Text Pla (*Clear-Sign*)
Permet signar un document de manera que el text continuï sent llegible directament sense eines especials, però incloent el bloc de signatura digital.

1. **Generar la signatura en text pla:**
   ```bash
   gpg --clearsign comunicat.txt
   ```
   * Genera el fitxer `comunicat.txt.asc`.

2. **Verificació:**
   ```bash
   gpg --verify comunicat.txt.asc
   ```

---

### Exercici 5: Xifrat i Signatura Simultanis (Confidencialitat + Autenticitat)
En un entorn real, sovint volem que un missatge sigui secret **i a la vegada** garantir qui l'ha escrit.

1. **Xifrar per al recipient i signar amb la nostra clau privada alhora:**
   ```bash
   gpg --encrypt --sign --armor --recipient correu_company@exemple.com --output complet.gpg missatge.txt
   ```

2. **Desxifrat i verificació per part del company:**
   ```bash
   gpg --decrypt complet.gpg
   ```
   * GPG desxifrarà el missatge i, al mateix temps, validarà la firma digital i mostrarà l'autor.

---

### Exercici 6: Gestió del Cicle de Vida – Certificat de Revocació
Si la nostra clau privada es veu compromesa o la perdem, hem de poder revocar-la.

1. **Generar el certificat de revocació:**
   ```bash
   gpg --gen-revoke elteucorreu@exemple.com > revocacio.asc
   ```
2. **Aplicar la revocació en cas d'incident:**
   ```bash
   gpg --import revocacio.asc
   ```
   * Un cop importat, qualsevol intent de xifrar informació cap a aquesta clau mostrarà un avís indicant que la clau ha estat revocada.

---

## 7. Resum de Comandes Utilitzades

| Operació | Comanda GPG |
| :--- | :--- |
| **Generar claus** | `gpg --full-generate-key` |
| **Xifrat Simètric** | `gpg --symmetric --armor fitxer.txt` |
| **Exportar Clau Pública** | `gpg --armor --export correu@exemple.com > clau.asc` |
| **Importar Clau** | `gpg --import clau.asc` |
| **Xifrat Asimètric** | `gpg --encrypt --armor --recipient correu@exemple.com fitxer.txt` |
| **Desxifrar Fitxer** | `gpg --decrypt fitxer.asc` |
| **Signatura Separada** | `gpg --detach-sig fitxer.txt` |
| **Signatura Clear-sign** | `gpg --clearsign fitxer.txt` |
| **Xifrar i Signar** | `gpg --encrypt --sign --recipient correu@exemple.com fitxer.txt` |
| **Verificar Signatura** | `gpg --verify fitxer.sig fitxer.txt` |