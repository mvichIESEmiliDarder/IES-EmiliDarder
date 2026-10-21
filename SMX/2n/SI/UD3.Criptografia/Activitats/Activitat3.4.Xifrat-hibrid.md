# Activitat 3.4 — Xifratge híbrid de missatges amb GPG i `nc`

**Cicle formatiu:** 2n de SMX (Sistemes Microinformàtics i Xarxes)  
**Mòdul:** Seguretat informàtica  
**Tema:** Criptografia simètrica, asimètrica i sistema híbrid  
**Eines:** Linux, GnuPG (`gpg`) i Netcat (`nc`)

---

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

1. Esbrineu l’adreça IP local de l’ordinador A.

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

- Cada alumne crea la seva parella de claus:

- Trieu RSA i RSA, una mida de 3072 bits, caducitat d’un any i un nom i correu ficticis d’aula. Protegiu la clau privada amb una frase de pas. Anoteu l’adreça de correu o identificador triat.

- Comproveu que la clau apareix al vostre anell.


## 6. Intercanviar les claus públiques

1. A exporta la seva clau pública en format ASCII.
2. A envia el contingut de `clau-publica-A.asc` a B a través de la connexió de `nc`. B desa el bloc rebut com a `clau-publica-A.asc`.
3. B importa la clau pública d’A.
4. B consulta la petjada i la compara amb A presencialment.
5. B exporta la seva pròpia clau pública, l’envia a A pel canal de `nc` i A la desa com a `clau-publica-B.asc`.
6. A importa la clau i comprova la petjada amb B.

## 7. B crea i envia la clau simètrica a A

1. B crea una cadena de text aleatòria que farà de clau simètrica. Creeu-la en un fitxer amb una sola línia.
2. B xifra aquest fitxer per a A amb la clau pública d’A.
3. B envia el contingut de `clausimetrica-xifrada.asc` a A per `nc`. A desa el bloc complet com a `clausimetrica-xifrada.asc`.
4. A desxifra el fitxer amb la seva clau privada.
5. A i B comproven que tenen la mateixa clau simètrica. No l’envieu en text pla per `nc`.

## 8. Intercanviar missatges xifrats amb la clau simètrica

### B envia un missatge a A

1. B crea el missatge.
2. B el xifra amb la clau simètrica que ha creat.
3. B envia el contingut de `missatge-B-a-A.asc` per `nc`. A el desa com a `missatge-rebut.asc`.
4. A el desxifra amb la clau simètrica rebuda.
5. A mostra el missatge.

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
