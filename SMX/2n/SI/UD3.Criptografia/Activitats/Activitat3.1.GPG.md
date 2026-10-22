# # Activitat 3.1. Criptografia amb GPG en Linux

**Cicle Formatiu:** 2n de SMR (Sistemes Microinformàtics i Xarxes)  
**Mòdul:** Seguretat Informàtica  
**Tema:** Criptografia simètrica, asimètrica, signatura digital i gestió de claus  
**Eina:** `gpg` (GNU Privacy Guard) en Linux  

---

### Objectiu de la pràctica
L'objectiu d'aquesta pràctica és aprendre a utilitzar l'eina `gpg` en entorn Linux per aplicar tècniques de xifrat simètric, xifrat asimètric, gestió de claus i signatura digital.

**Instrucció general:** Redacta un informe detallat explicant cadascun dels passos realitzats i adjunta les **captures de pantalla corresponents** a cada exercici.

---

### Preparació prèvia: Configuració de l'entorn

**Pas 0:** Genera el teu parell de claus (pública i privada) en la teva màquina Linux utilitzant la comanda `gpg --full-generate-key`. 
* Posa una mida de clau adequada (mínim 3072 bits).
* Assigna el teu nom, correu electrònic i una contrasenya (*passphrase*) segura.
* Adjunta una captura del procés de generació de la clau.

---

### Exercici 1: Criptografia Simètrica

Utilitza `gpg` per encriptar un fitxer de text utilitzant una clau simètrica i envia'l al teu company mitjançant correu electrònic.

* **1.1.** Xifra el fitxer de text amb la comanda corresponent. Mostra la comanda utilitzada i el fitxer resultat generat.
* **1.2.** Com li has passat la clau al teu company? Justifica el mètode utilitzat.
* **1.3.** Mostra la comanda i el procés mitjançant el qual el teu company ha aconseguit desxifrar el fitxer.

---

### Exercici 2: Gestió d'Anell de Claus i Confiança (Ampliador)

Abans de poder utilitzar la criptografia asimètrica, cal gestionar les claus públiques dels usuaris.

* **2.1.** Exporta la teva clau pública a un fitxer de text en format ASCII (`.asc`).
* **2.2.** Importa la clau pública del teu company al teu anell de claus local.
* **2.3.** Llista les claus públiques del teu anell per comprovar que s'ha afegit correctament.
* **2.4.** Signa la clau pública del teu company amb la teva pròpia clau privada (*Web of Trust*) per tal d'establir confidencialitat i evitar avisos de "clau no verificada".

---

### Exercici 3: Criptografia Asimètrica

Utilitza `gpg` per encriptar un fitxer de text amb la clau pública del teu company i envia'l mitjançant correu electrònic.

* **3.1.** Què t'ha d'enviar primerament el teu company per poder-li enviar la informació xifrada?
* **3.2.** Mostra quines comandes i passos has realitzat per encriptar el fitxer fent servir la seva clau pública.
* **3.3.** Mostra com el teu company aconsegueix desxifrar el fitxer fent servir la seva clau privada.

---

### Exercici 4: Signatura Digital Separada (*Detached Signature*)

Utilitza `gpg` per signar un fitxer de text per tal de garantir la seva autenticitat i la seva integritat.

* **4.1.** Crea un fitxer de text i genera una signatura digital separada (aquest procés crea el hash i el xifra amb la teva clau privada).
* **4.2.** Envia el fitxer de text original i el fitxer de signatura generat al teu company.
* **4.3.** Mostra com el teu company comprova i valida que el fitxer enviat és teu i no ha estat alterat des de la seva signatura.

---

### Exercici 5: Signatura en Text Pla (*Clear-Sign*)

En molts casos és necessari signar un document sense xifrar el seu contingut, mantenint el text llegible directament.

* **5.1.** Utilitza l'opció `--clearsign` de `gpg` per signar un document de text.
* **5.2.** Mostra l'estructura interna del fitxer resultat (on es veu el text pla juntament amb el bloc de signatura).
* **5.3.** Mostra com el teu company comprova la validesa d'aquesta signatura.

---

### Exercici 6: Xifrat i Signatura Simultanis (Confidencialitat + Autenticitat)

A la pràctica real és habitual protegir tant la confidencialitat com l'autenticitat en un sol pas.

* **6.1.** Cifra un fitxer per al teu company utilitzant la seva clau pública i, simultàniament, signa'l amb la teva clau privada.
* **6.2.** Mostra com el teu company, en executar el procés de desxifrat, rep tant el contingut en pla com la confirmació automàtica de la signatura de l'autor.

---

### Exercici 7: Certificat de Revocació

Per completar el cicle de vida de les claus, cal estar preparat en cas de pèrdua o compromís de la clau privada.

* **7.1.** Genera un certificat de revocació per a la teva clau pública.
* **7.2.** Explica en quines circumstàncies s'hauria d'utilitzar i quines conseqüències té importar-lo a un servidor o anell de claus.
