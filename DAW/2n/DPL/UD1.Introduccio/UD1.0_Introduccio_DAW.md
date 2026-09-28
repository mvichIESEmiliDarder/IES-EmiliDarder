# UD1.0 — Introducció al Desplegament d'Aplicacions Web

**2n CFGS Desenvolupament d’Aplicacions Web**

## Presentació

Hola!

Soc **Martí Vich**, professor del mòdul **Desplegament d’Aplicacions Web**, i et guiaré i ajudaré durant aquest curs perquè puguis assolir amb èxit els coneixements necessaris d’aquest mòdul.

**Contacte:** mvich@iesemilidarder.com

---

## 1. Introducció

Per desplegar una aplicació web necessitarem una **infraestructura** que ens permeti allotjar-la i fer-la accessible als usuaris a través d'Internet.

### Quines opcions tenim?

- **Hosting compartit** — simple i econòmic.
- **VPS (Virtual Private Server)** — tenim més control.
- **Cloud computing** — serveis sota demanda.
- **Hosting estàtic** — HTML/CSS/JS + CDN.

### Què gestionam nosaltres?

Com més control volem, més infraestructura hem de gestionar.

De **menys administració** a **més administració**:

1. Hosting compartit
2. PaaS
3. VPS / IaaS
4. Servidor dedicat
5. On-premise

---

## 2. Hosting compartit

### Què és?

Les aplicacions web comparteixen els recursos del servidor —CPU, RAM, espai de disc, etc.— amb altres llocs web allotjats al mateix servidor físic.

### Avantatges

- Més econòmic.
- Fàcil de gestionar.
- Ideal per a principiants o projectes petits.

### Desavantatges

- Possibles problemes de rendiment.
- Poc control sobre la configuració del servidor i sobre el que hi podem instal·lar.

**Exemples:** Hostinger · Arsys · IONOS

---

## 3. VPS (Virtual Private Server)

### Què és?

El servidor físic es divideix en diverses màquines virtuals (**VPS**). Cada VPS disposa dels seus propis recursos.

### Avantatges

- Més control sobre la configuració del servidor i el que s'hi pot instal·lar.
- Millor rendiment que el hosting compartit.

### Desavantatges

- El cost és més gran que el del hosting compartit.
- Requereix coneixements tècnics bàsics sobre com gestionar un servidor.

**Exemples:** DigitalOcean · OVHcloud · Hetzner

---

## 4. Servidor dedicat

### Què és?

En un servidor dedicat disposem d’un **servidor físic complet** per a la nostra organització.

### Avantatges

- Millor rendiment, ja que no compartim els recursos.
- Ideal per a aplicacions grans i amb molt de trànsit.

### Desavantatges

- És una opció més cara.
- Requereix administració avançada.
- Ens hem d'encarregar del manteniment i la seguretat.

**Exemples:** Clouding.io · OVHcloud · Hetzner

---

## 5. Cloud Computing

El núvol ofereix diferents nivells d'abstracció: podem llogar infraestructura, plataformes o serveis molt més gestionats.

| Model | Què ofereix | Idea principal |
|---|---|---|
| **IaaS** | Infraestructura | Més control |
| **PaaS** | Plataforma | Gestió simplificada |
| **FaaS** | Funcions | Execució puntual |
| **CaaS** | Contenidors | Alta portabilitat |
| **KaaS** | Orquestradors | Alta escalabilitat |

---

## 6. Cloud Computing: IaaS

### Què és?

**Infrastructure as a Service (IaaS)** proporciona recursos d'infraestructura:

- Servidors virtuals.
- Xarxes.
- Emmagatzematge.

Nosaltres ens encarregam de gestionar el **sistema operatiu**, la instal·lació d'aplicacions i la resta de configuració del servidor.

### Avantatges

- Més flexibilitat i control.
- Facilita l'escalabilitat, ja que podem modificar la infraestructura segons la demanda.

### Desavantatges

- Requereix coneixements tècnics avançats.
- El cost depèn dels recursos que es facin servir.

**Exemples:** AWS · Microsoft Azure · Google Cloud · Oracle Cloud Infrastructure

---

## 7. Cloud Computing: PaaS

### Què és?

La **Plataforma com a Servei (PaaS)** gestiona tota la infraestructura.

El desenvolupador només s'ha de preocupar del **codi de l'aplicació**.

### Avantatges

- És fàcil d’utilitzar.
- Ideal per a programadors.
- Permet l'autoescalat en funció de la demanda.

### Desavantatges

- Menys control.
- El cost depèn dels recursos que es facin servir.
- Pot ser més car que altres opcions.

**Exemples:** Heroku · Google App Engine · Render

---

## 8. Cloud Computing: FaaS

### Què és?

Executam **funcions independents sota demanda**, normalment activades per esdeveniments o peticions HTTP.

### Avantatges

- Pagament per ús.
- Escalat automàtic.
- Molt útil per a càrregues intermitents.

### Desavantatges

- Menys control sobre l'entorn.
- Límits de temps o d'execució segons la plataforma.
- No és ideal per a tots els processos.

**Exemples:** AWS Lambda · Google Cloud Run functions · Azure Functions

### Exemple d'un cas concret

1. L'usuari puja una imatge.
2. L'esdeveniment activa la funció.
3. La funció escala la imatge.
4. Es guarda la miniatura resultant.

> No hi ha cap procés permanent esperant: la funció s'executa quan passa l'esdeveniment.

---

## 9. Cloud Computing: CaaS

### Què és?

Les tecnologies de contenidors permeten **empaquetar aplicacions i les seves dependències** per garantir que es puguin executar de la mateixa manera en qualsevol entorn.

### Avantatges

- Faciliten la portabilitat de les aplicacions.
- Són ideals per a arquitectures basades en microserveis.

### Desavantatges

- Requereixen coneixements tècnics avançats.

**Exemples:** AWS Elastic Container Service (ECS) · Azure Container Apps · Google Kubernetes Engine (GKE)

---

## 10. Cloud Computing: KaaS

### Què és?

La tecnologia d'orquestració de contenidors permet **gestionar contenidors a gran escala**.

### Avantatges

- Facilita la gestió d’aplicacions distribuïdes i el seu escalat.

### Desavantatges

- Requereix coneixements tècnics avançats.

**Exemples:** AWS · Azure · Google Cloud, mitjançant serveis gestionats d'orquestració de contenidors.

---

## 11. Contenidors, CaaS i KaaS

És important diferenciar les **tecnologies** dels **serveis cloud** que les ofereixen.

- **Contenidor:** empaqueta l'aplicació i les seves dependències.
- **Docker:** crea i executa contenidors.
- **CaaS:** executa els contenidors al núvol.
- **Kubernetes:** orquestra els contenidors.
- **KaaS:** ofereix Kubernetes gestionat al núvol.

> **Idea clau:** Docker no és CaaS i Kubernetes no és KaaS. Són tecnologies que els serveis cloud poden oferir de forma gestionada.

---

## 12. Hosting estàtic amb CDN

### Què és?

Per desplegar aplicacions web estàtiques —**HTML, CSS i JavaScript**— podem utilitzar una **CDN (Content Delivery Network)** per distribuir el contingut en servidors repartits per tot el món.

### Avantatges

- Molt eficient per a llocs web estàtics.
- Hi ha proveïdors gratuïts o molt econòmics.
- Millora la velocitat de càrrega.

### Desavantatges

- Està limitat al contingut de llocs web estàtics.

**Exemples:** GitHub Pages · Cloudflare Pages · Netlify

---

## 13. Què hem de triar?

L'opció adequada depèn del tipus de projecte:

| Projecte | Possibles opcions |
|---|---|
| Portfolio HTML/CSS/JS | Hosting estàtic |
| Aplicació Laravel petita | Hosting / VPS / PaaS |
| API amb control total del servidor | VPS / IaaS |
| Microserveis en contenidors | CaaS / KaaS |

La resposta depèn de diversos factors:

- Control.
- Cost.
- Escalabilitat.
- Complexitat.
- Responsabilitat operativa.

---

## Idea final

> **Desplegar no és simplement «pujar una web».**
>
> És decidir quina part de la infraestructura gestionam nosaltres i quina delegam a un proveïdor.
