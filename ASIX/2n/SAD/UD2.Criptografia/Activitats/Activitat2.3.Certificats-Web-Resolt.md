# Activitat 2.3 — Gestió i anàlisi de certificats web

**Cicle formatiu:** 2n de ASIX (Administració de Sistemes Informàtics i Xarxes)
**Mòdul:** Seguretat i Alta disponibilitat 
**Tema:** Criptografia, certificats digitals i TLS
**Eina:** Navegador web i, opcionalment, terminal Linux

---

> **Nota:** Els valors exactes depenen del lloc públic triat, de la configuració del Proxmox i de la data de consulta. La resolució indica què s’ha d’observar; cal substituir els exemples pels valors reals vistos a classe. En particular, un avís del navegador no demostra per si sol que el certificat sigui autosignat: també pot estar caducat, tenir un nom incorrecte o no encadenar amb una CA de confiança.

## 1. Part A — Certificat d’una web de confiança

La taula s’ha d’emplenar amb les dades del lloc triat. Un exemple de resultats possibles:

| Dada | Exemple de resultat esperat |
|---|---|
| Adreça del lloc (domini) | El domini HTTPS seleccionat |
| Emès per / Issuer | Una autoritat de certificació pública o un intermedi d’aquesta autoritat |
| Emès a / Subject o Subject Alternative Name | El domini visitat o els dominis que cobreix el certificat |
| Vàlid des de | Data indicada al certificat |
| Vàlid fins a | Data posterior a la data de consulta |
| Estat que indica el navegador | Connexió segura; cadena acceptada pel navegador |
| Hi ha certificats intermedis? | Sovint sí; depèn del lloc i del que mostri el navegador |

La cadena habitual és: certificat del servidor → certificat intermedi → autoritat arrel que el navegador o el sistema ja considera de confiança. El navegador comprova, entre altres coses, que el nom del lloc coincideixi amb el certificat, que aquest sigui vigent i que la cadena sigui vàlida segons les autoritats que confia.

## 2. Part B — Certificat de Proxmox

En una instal·lació de laboratori, Proxmox pot utilitzar inicialment un certificat autosignat o un certificat intern que l’ordinador de l’alumne no reconeix. La taula podria tenir aquest aspecte:

| Dada | Exemple de resultat esperat |
|---|---|
| Adreça del lloc (domini o IP) | L’adreça interna de Proxmox i el port `8006` |
| Emès per / Issuer | Pot coincidir amb el subjecte si és autosignat, o mostrar una CA interna |
| Emès a / Subject o Subject Alternative Name | El nom o la IP configurats al certificat |
| Vàlid des de | Data indicada al certificat |
| Vàlid fins a | Data indicada al certificat |
| Estat que indica el navegador | Avís de confiança, nom incorrecte, caducitat o un altre motiu concret |
| Hi ha certificats intermedis? | Sovint no n’hi ha si el certificat és autosignat; cal comprovar-ho |

Si el subjecte i l’emissor són el mateix, això és un indici habitual que el certificat és autosignat. També es pot veure que la cadena no arriba a una autoritat arrel que el navegador reconegui. Tanmateix, s’ha de llegir el motiu exacte de l’avís: podria ser un certificat emès per una CA interna desconeguda, una discrepància del nom o una data de validesa incorrecta.

L’ordre `openssl s_client` mostra el certificat o els certificats que presenta el servidor i informació de verificació TLS. Un resultat de verificació amb error indica que el client no ha pogut validar la cadena amb les autoritats que té configurades; per si sol no identifica necessàriament la causa exacta.

## 3. Part C — Respostes

1. El certificat de la web pública és el que el navegador accepta i pot encadenar amb una autoritat de certificació que considera de confiança, sempre que el nom i la vigència també siguin correctes.
2. El certificat de Proxmox pot ser autosignat si el camp **Issuer** coincideix amb **Subject** i no hi ha una cadena fins a una autoritat de confiança. Si l’emissor és una CA interna desconeguda, no és estrictament autosignat: el navegador simplement no confia en aquella CA.
3. Sí. La connexió TLS pot estar xifrada, però el navegador pot no saber si s’ha connectat al servidor legítim. El xifrat protegeix les dades en trànsit; la validació del certificat ajuda a autenticar el servidor.
4. En un laboratori, l’administrador controla els equips i pot comunicar la petjada del certificat per un canal fiable. En un servei públic, un certificat autosignat no proporciona per si sol una verificació independent de la identitat del servidor: un atacant podria presentar un altre certificat autosignat i el navegador no tindria una autoritat de confiança que permetés distingir-los.
5. Per a un servei intern, es pot desplegar una CA interna i instal·lar-ne el certificat arrel de manera controlada als equips gestionats, o usar un certificat amb una cadena de confiança ja reconeguda si el nom i l’accés ho permeten. Per a un servei públic, es pot obtenir un certificat d’una CA reconeguda per als dominis propis i mantenir-lo renovat.
6. L’usuari podria estar comunicant-se amb un servidor suplantat. Això pot permetre interceptar o modificar informació, especialment si hi introdueix credencials o dades sensibles.

## 4. Conclusió possible

Un certificat web associa una identitat de servidor amb una clau pública i forma part de l’establiment de TLS. Quan el navegador valida el nom, la vigència i la cadena fins a una autoritat de confiança, pot autenticar millor el servidor. Un certificat autosignat encara pot xifrar la connexió, però el navegador no disposa d’una autoritat externa que confirmi que aquell certificat pertany realment al servidor esperat. Per això cal comprovar l’origen de l’avís i no acceptar excepcions de manera automàtica.
