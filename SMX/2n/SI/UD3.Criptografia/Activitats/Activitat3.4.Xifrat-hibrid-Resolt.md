# Activitat 3.4 — Xifratge híbrid de missatges amb GPG i `nc`

**Cicle formatiu:** 2n de SMX (Sistemes Microinformàtics i Xarxes)  
**Mòdul:** Seguretat informàtica  
**Tema:** Criptografia simètrica, asimètrica i sistema híbrid  
**Eines:** Linux, GnuPG (`gpg`) i Netcat (`nc`)

---

# Part I. Enunciat

## 1. Objectius

En aquesta activitat, per parelles:

- establireu una connexió de text entre dos ordinadors amb `nc`;
- creareu una parella de claus pública i privada per a cada alumne;
- intercanviareu claus públiques i comprovareu les petjades digitals;
- fareu arribar una clau simètrica mitjançant xifrat asimètric;
- xifraràs i desxifraràs missatges amb la clau simètrica compartida;
- descriuràs per què el procediment és un exemple de sistema híbrid.

## 2. Escenari i rols

Treballareu per parelles. Cada parella utilitzarà dos ordinadors connectats a la mateixa xarxa local:

- **Ordinador A:** espera la connexió i inicia l’intercanvi.
- **Ordinador B:** inicia la connexió i crea la clau simètrica de la conversa.

Tots dos alumnes generaran les seves pròpies claus GPG. En aquesta primera conversa, B crearà una clau simètrica i la farà arribar a A protegida amb la clau pública d’A. Després tots dos utilitzaran aquesta clau per xifrar i desxifrar els missatges.

## 3. Normes i precaucions

- Feu l’activitat només entre ordinadors autoritzats dins la xarxa del centre.
- No utilitzeu claus, contrasenyes ni dades personals reals.
- La connexió de `nc` no xifra ni autentica per si mateixa la comunicació. En aquesta pràctica, la clau simètrica i els missatges xifrats es transportaran per aquest canal.
- Abans de confiar en una clau pública, compareu-ne la petjada amb el propietari per un canal independent, com ara presencialment.
- No compartiu la clau privada ni la frase de pas de les claus GPG.
- La clau simètrica de la pràctica quedarà guardada en un fitxer de text per facilitar-ne l’ús amb les comandes. És una simplificació didàctica; no és una pràctica recomanable per protegir informació real.

## 4. Preparació de la connexió

1. Esbrineu l’adreça IP local de l’ordinador A:

   ```bash
   hostname -I
   ```

2. A l’ordinador A, poseu `nc` en mode escolta al port TCP 5000:

   ```bash
   nc -l 5000
   ```

   Segons la versió de `nc`, pot ser necessari:

   ```bash
   nc -l -p 5000
   ```

3. A l’ordinador B, connecteu-vos a l’adreça IP d’A:

   ```bash
   nc IP_DE_A 5000
   ```

4. Comproveu que podeu escriure text a cada terminal i que apareix a l’altre. Esborreu el text de prova i manteniu la connexió oberta.

## 5. Crear les claus GPG

Cada alumne crea la seva parella de claus:

```bash
gpg --full-generate-key
```

Trieu RSA i RSA, una mida de 3072 bits, caducitat d’un any i un nom i correu ficticis d’aula. Protegiu la clau privada amb una frase de pas. Anoteu l’adreça de correu o identificador triat.

Comproveu que la clau apareix al vostre anell:

```bash
gpg --list-keys
```

## 6. Intercanviar les claus públiques

1. A exporta la seva clau pública en format ASCII:

   ```bash
   gpg --armor --export usuariA@aula.local > clau-publica-A.asc
   ```

2. A envia el contingut de `clau-publica-A.asc` a B a través de la connexió de `nc`. B desa el bloc rebut com a `clau-publica-A.asc`.
3. B importa la clau pública d’A:

   ```bash
   gpg --import clau-publica-A.asc
   ```

4. B consulta la petjada i la compara amb A presencialment:

   ```bash
   gpg --fingerprint usuariA@aula.local
   ```

5. B exporta la seva pròpia clau pública, l’envia a A pel canal de `nc` i A la desa com a `clau-publica-B.asc`.
6. A importa la clau i comprova la petjada amb B:

   ```bash
   gpg --import clau-publica-B.asc
   gpg --fingerprint usuariB@aula.local
   ```

No signeu automàticament la clau de l’altre alumne. La comprovació de la petjada serveix per verificar que la clau rebuda és la que el company vol compartir.

## 7. B crea i envia la clau simètrica a A

1. B crea una cadena de text aleatòria que farà de clau simètrica. Creeu-la en un fitxer amb una sola línia:

   ```bash
   umask 077
   tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32 > clausimetrica.txt
   printf '\n' >> clausimetrica.txt
   ```

2. B xifra aquest fitxer per a A amb la clau pública d’A:

   ```bash
   gpg --armor --encrypt --recipient usuariA@aula.local \\
     --output clausimetrica-xifrada.asc clausimetrica.txt
   ```

3. B envia el contingut de `clausimetrica-xifrada.asc` a A per `nc`. A desa el bloc complet com a `clausimetrica-xifrada.asc`.
4. A desxifra el fitxer amb la seva clau privada:

   ```bash
   gpg --output clausimetrica-rebuda.txt --decrypt clausimetrica-xifrada.asc
   ```

5. A i B comproven que tenen la mateixa clau simètrica. No l’envieu en text pla per `nc`.

## 8. Intercanviar missatges xifrats amb la clau simètrica

### B envia un missatge a A

1. B crea el missatge:

   ```bash
   printf 'Hola, com estàs?\n' > missatge.txt
   ```

2. B el xifra amb la clau simètrica que ha creat:

   ```bash
   gpg --batch --pinentry-mode loopback \\
     --passphrase-file clausimetrica.txt \\
     --armor --symmetric \\
     --output missatge-B-a-A.asc missatge.txt
   ```

3. B envia el contingut de `missatge-B-a-A.asc` per `nc`. A el desa com a `missatge-rebut.asc`.
4. A el desxifra amb la clau simètrica rebuda:

   ```bash
   gpg --batch --pinentry-mode loopback \\
     --passphrase-file clausimetrica-rebuda.txt \\
     --output missatge-desencriptat.txt \\
     --decrypt missatge-rebut.asc
   ```

5. A mostra el missatge:

   ```bash
   cat missatge-desencriptat.txt
   ```

### A respon a B

Repetiu el mateix procediment amb un missatge nou. A l’ha de xifrar amb `clausimetrica-rebuda.txt`, enviar el fitxer xifrat a B, i B l’ha de desxifrar amb `clausimetrica.txt`.

## 9. Qüestions

1. Quina clau ha fet servir B per xifrar `clausimetrica.txt`? Quina clau necessita A per desxifrar-la?
2. Quina clau xifra els missatges de la conversa?
3. En quin pas s’utilitza criptografia asimètrica? I en quin pas, criptografia simètrica?
4. Per què diem que és un sistema híbrid?
5. Quin avantatge aporta xifrar la clau simètrica amb la clau pública d’A, en comptes d’enviar-la directament en text pla?
6. Què podria passar si la clau pública d’A no s’hagués verificat i pertanyés a una altra persona?
7. Què protegeix el xifrat dels missatges i què no protegeix aquesta pràctica (per exemple, identitat del remitent o integritat/autenticitat del missatge)?
8. Quines limitacions té desar la clau simètrica en un fitxer de text?

## 10. Lliurament

Lliura un document amb:

- els identificadors GPG triats pels dos alumnes;
- les petjades digitals intercanviades i la manera com s’han verificat;
- una captura o transcripció de la connexió `nc` i dels passos d’intercanvi;
- un missatge enviat en cada direcció i la sortida desxifrada;
- les respostes a les qüestions;
- una conclusió que expliqui el paper de la clau pública, la clau privada i la clau simètrica.

No lliuris cap clau privada, frase de pas ni fitxer que contingui la clau simètrica.

---

# Part II. Resolució pas a pas

## 1. Preparar la connexió entre A i B

A comprova la seva adreça IP:

```bash
hostname -I
```

A escolta al port 5000:

```bash
nc -l 5000
```

Si aquesta sintaxi no funciona amb la versió instal·lada:

```bash
nc -l -p 5000
```

B inicia la connexió substituint `IP_DE_A` per l’adreça real d’A:

```bash
nc IP_DE_A 5000
```

Quan la connexió s’ha establert, el text escrit a cada terminal apareix a l’altre. La connexió és bidireccional, però no xifrada.

Per a aquesta resolució, suposem que els identificadors són `usuariA@aula.local` i `usuariB@aula.local`. Cal substituir-los pels triats a classe.

## 2. Crear les parelles de claus

A i B, cadascú al seu ordinador, executen:

```bash
gpg --full-generate-key
```

Trien RSA i RSA, 3072 bits, una caducitat d’un any i una frase de pas per protegir la clau privada. Després comproven la clau pública:

```bash
gpg --list-keys
```

Les claus privades no s’envien a l’altre ordinador.

## 3. A exporta i envia la clau pública

A exporta la clau pública:

```bash
gpg --armor --export usuariA@aula.local > clau-publica-A.asc
```

El fitxer conté un bloc de text delimitat per capçaleres similars a:

```text
-----BEGIN PGP PUBLIC KEY BLOCK-----
...
-----END PGP PUBLIC KEY BLOCK-----
```

A envia el contingut del bloc a B per la connexió oberta de `nc`. B desa el bloc complet al fitxer `clau-publica-A.asc`, incloent les capçaleres i el final.

B importa la clau:

```bash
gpg --import clau-publica-A.asc
```

B mostra la petjada:

```bash
gpg --fingerprint usuariA@aula.local
```

B compara tota la petjada amb A presencialment. Si coincideix, sap que ha rebut la clau que A volia compartir.

## 4. B envia la seva clau pública a A

B exporta la seva clau:

```bash
gpg --armor --export usuariB@aula.local > clau-publica-B.asc
```

B envia el bloc per `nc`. A el desa com a `clau-publica-B.asc` i l’importa:

```bash
gpg --import clau-publica-B.asc
```

A consulta i verifica la petjada amb B:

```bash
gpg --fingerprint usuariB@aula.local
```

A partir d’ara, A té la clau pública de B i B té la clau pública d’A. Cap dels dos ha compartit la seva clau privada.

## 5. B crea la clau simètrica de la conversa

B crea una cadena aleatòria de 32 caràcters alfanumèrics i limita els permisos del fitxer perquè només el seu usuari el pugui llegir:

```bash
umask 077
tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32 > clausimetrica.txt
printf '\n' >> clausimetrica.txt
```

B pot comprovar que el fitxer no és buit:

```bash
wc -c clausimetrica.txt
```

No ha d’enviar aquest fitxer en text pla.

## 6. B xifra la clau simètrica per a A

B xifra el fitxer amb la clau pública d’A:

```bash
gpg --armor --encrypt --recipient usuariA@aula.local \
  --output clausimetrica-xifrada.asc clausimetrica.txt
```

GPG utilitza la clau pública d’A per protegir la clau simètrica. El fitxer resultant és text ASCII, però el seu contingut està xifrat. B envia el bloc complet de `clausimetrica-xifrada.asc` a A per `nc`.

A desa el bloc rebut com a `clausimetrica-xifrada.asc` i el desxifra:

```bash
gpg --output clausimetrica-rebuda.txt --decrypt clausimetrica-xifrada.asc
```

A introdueix la frase de pas de la seva clau privada quan GPG la demana. GPG crea `clausimetrica-rebuda.txt`, que conté la clau simètrica. B conserva `clausimetrica.txt`.

Per verificar que els dos fitxers contenen exactament la mateixa cadena, A pot comunicar a B, presencialment, el resultat d’una comparació local o poden comparar-ne els hashes SHA-256 en veu alta:

```bash
sha256sum clausimetrica.txt
```

A executa la mateixa ordre sobre `clausimetrica-rebuda.txt`. Els hashes han de coincidir. No cal enviar la cadena simètrica per fer aquesta comprovació.

## 7. B xifra un missatge amb la clau simètrica

B crea el missatge:

```bash
printf 'Hola, com estàs?\n' > missatge.txt
```

B el xifra en mode simètric llegint la contrasenya del fitxer:

```bash
gpg --batch --pinentry-mode loopback \
  --passphrase-file clausimetrica.txt \
  --armor --symmetric \
  --output missatge-B-a-A.asc missatge.txt
```

El fitxer `missatge-B-a-A.asc` conté el missatge xifrat en format ASCII. B envia el bloc per `nc`. A el desa íntegrament com a `missatge-rebut.asc`.

## 8. A desxifra el missatge

A empra la còpia rebuda de la clau simètrica:

```bash
gpg --batch --pinentry-mode loopback \
  --passphrase-file clausimetrica-rebuda.txt \
  --output missatge-desencriptat.txt \
  --decrypt missatge-rebut.asc
```

A mostra el resultat:

```bash
cat missatge-desencriptat.txt
```

La sortida esperada és:

```text
Hola, com estàs?
```

## 9. A respon a B

A crea una resposta:

```bash
printf 'Hola! Tot bé, gràcies.\n' > resposta.txt
```

A la xifra amb la clau simètrica rebuda:

```bash
gpg --batch --pinentry-mode loopback \
  --passphrase-file clausimetrica-rebuda.txt \
  --armor --symmetric \
  --output resposta-A-a-B.asc resposta.txt
```

A envia el bloc xifrat per `nc`. B el desa com a `resposta-rebuda.asc` i el desxifra amb la clau original:

```bash
gpg --batch --pinentry-mode loopback \
  --passphrase-file clausimetrica.txt \
  --output resposta-desencriptada.txt \
  --decrypt resposta-rebuda.asc
cat resposta-desencriptada.txt
```

La sortida esperada és:

```text
Hola! Tot bé, gràcies.
```

## 10. Respostes a les qüestions

1. B ha xifrat `clausimetrica.txt` amb la **clau pública d’A**. A el desxifra amb la seva **clau privada**.
2. Els missatges es xifren amb la **clau simètrica compartida** que B ha creat i A ha rebut xifrada.
3. La criptografia asimètrica s’empra per protegir la clau simètrica durant l’enviament. La criptografia simètrica s’empra per xifrar i desxifrar els missatges de la conversa.
4. És híbrid perquè combina criptografia asimètrica per distribuir/protegir la clau de sessió i criptografia simètrica per protegir el contingut dels missatges.
5. La clau simètrica no viatja llegible pel canal. Només qui disposa de la clau privada corresponent a la clau pública d’A pot recuperar-la.
6. B podria xifrar la clau per a un tercer. A no la podria desxifrar; o, en un atac més elaborat, els missatges podrien acabar en mans d’un intermediari. Verificar la petjada redueix aquest risc.
7. El xifrat simètric oculta el contingut a qui no coneix la clau. Aquest flux no autentica criptogràficament l’autor de cada missatge: qualsevol dels dos que conegui la clau compartida pot crear un missatge que l’altre pugui desxifrar. Per autenticar l’emissor caldria afegir una signatura digital i verificar-la amb la seva clau pública.
8. Un fitxer de text pot ser llegit per qualsevol persona amb accés al compte o a una còpia del fitxer. Per això s’han usat permisos restrictius amb `umask 077`, però en un sistema real caldria protegir millor la clau, evitar-ne còpies innecessàries i esborrar-la de manera adequada.

## 11. Conclusió possible

B ha fet servir la clau pública d’A per enviar-li de manera protegida una clau simètrica. A l’ha recuperada amb la seva clau privada. Després tots dos han utilitzat la mateixa clau simètrica per xifrar i desxifrar missatges. Així, l’asimètric resol l’intercanvi de la clau i el simètric protegeix de manera eficient el contingut. La pràctica és didàctica: `nc` no autentica la connexió, els missatges no estan signats i la clau simètrica es desa en un fitxer accessible a l’usuari.
