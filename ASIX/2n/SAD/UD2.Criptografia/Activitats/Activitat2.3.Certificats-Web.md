# Activitat 2.3 — Gestió i anàlisi de certificats web

**Cicle formatiu:** 2n de ASIX (Administració de Sistemes Informàtics i Xarxes)
**Mòdul:** Seguretat i Alta disponibilitat Tema:** Criptografia, certificats digitals i TLS 
**Eina:** Navegador web i, opcionalment, terminal Linux

---

# Part I. Enunciat

## 1. Objectius

En aquesta activitat aprendràs a:

- consultar un certificat HTTPS des del navegador;
- identificar el domini, l’emissor i el període de validesa d’un certificat;
- observar la diferència entre un certificat emès per una autoritat de certificació i un certificat autosignat;
- entendre per què un navegador confia en alguns certificats i en altres mostra un avís;
- distingir entre xifrar la connexió i verificar la identitat del servidor.

## 2. Normes de seguretat

- Fes l’activitat només amb les webs indicades pel professorat.
- Per al certificat autosignat, utilitza el Proxmox del laboratori o un altre servei intern autoritzat.
- No introdueixis contrasenyes ni altres dades personals a la pàgina de Proxmox si el navegador mostra un avís que encara no has analitzat.
- No acceptis excepcions de certificat en webs desconegudes.
- No instal·lis ni importis certificats al sistema o al navegador durant aquesta pràctica.

## 3. Part A — Inspeccionar un certificat web de confiança

1. Obre al navegador una web HTTPS indicada pel professorat, per exemple la web oficial d’un fabricant o d’una administració pública.
2. Obre la informació de seguretat de la pàgina. Segons el navegador, es pot fer clic a la icona situada a l’esquerra de l’adreça i després a **Connexió segura**, **Certificat** o una opció equivalent.
3. Consulta el certificat del lloc i completa aquesta taula:

   | Dada | Valor observat |
   |---|---|
   | Adreça del lloc (domini) | |
   | Emès per / Issuer | |
   | Emès a / Subject o Subject Alternative Name | |
   | Vàlid des de | |
   | Vàlid fins a | |
   | Estat que indica el navegador | |
   | Hi ha certificats intermedis? | |

4. Si el navegador permet veure la cadena de certificats, identifica:
   - el certificat del lloc web;
   - el certificat intermedi, si n’hi ha;
   - l’autoritat arrel de confiança, si es mostra.

## 4. Part B — Inspeccionar el certificat de Proxmox del laboratori

1. Accedeix a la URL interna de Proxmox indicada pel professorat. Normalment és una adreça HTTPS amb el port `8006`.
2. Abans de continuar, observa l’avís del navegador. No l’ignorïs encara.
3. Anota el text principal de l’avís i el motiu que indica el navegador (per exemple, emissor desconegut, certificat autosignat, nom que no coincideix o certificat caducat).
4. Obre les opcions avançades del navegador només per consultar els detalls del certificat. No acceptis l’excepció ni continuïs si no és necessari per veure la informació.
5. Si el navegador no permet veure el certificat des de la pantalla d’avís, el professor pot mostrar-lo des de la configuració del navegador o executar aquesta ordre en una màquina Linux amb accés al laboratori:

   ```bash
   openssl s_client -connect proxmox.aula.local:8006 \\
     -servername proxmox.aula.local -showcerts </dev/null
   ```

   Substitueix `proxmox.aula.local` pel nom o l’adreça indicada pel professorat. Si s’utilitza una adreça IP, el paràmetre `-servername` es pot ometre o substituir pel nom DNS del servei si n’hi ha.

6. Completa la mateixa taula que a la Part A. Si una dada no apareix o no es pot consultar, escriu «no disponible» i explica-ho.

## 5. Part C — Comparació

Compara els dos certificats i respon:

1. Quin certificat ha estat emès per una autoritat de certificació reconeguda pel navegador?
2. Quin certificat sembla autosignat o no encadena amb una autoritat de confiança del navegador? Quina dada t’ho indica?
3. El certificat de Proxmox pot xifrar la connexió encara que el navegador no hi confiï? Explica la diferència entre xifrar la connexió i autenticar el servidor.
4. Per què un certificat autosignat pot ser acceptable en un laboratori intern però no és suficient, per si sol, per demostrar que un servidor públic és qui diu ser?
5. Què hauria de fer un administrador per evitar l’avís als usuaris d’una xarxa controlada? Esmenta una opció adequada per a un servei intern i una per a un servei públic.
6. Què pot passar si un usuari ignora qualsevol avís de certificat sense comprovar-ne la causa?

## 6. Lliurament

Lliura un document que contingui:

- les dues taules emplenades;
- una captura de cada finestra de detalls del certificat, si el professorat ho autoritza i no hi apareixen dades sensibles;
- les respostes de la Part C;
- una conclusió breu explicant la diferència entre un certificat de confiança i un autosignat.

