# Unitat 1: Administració de Servidors d'Aplicacions Web

## Diapositiva 1: Introducció i Definició
* **Què és un Servidor d'Aplicacions?**: És un marc mixt de programari que permet tant la creació d'aplicacions web com l'entorn de servidor per executar-les.
* **Complexitat**: Sovint és una pila complexa d'elements computacionals que executen tasques específiques per alimentar programari basat en el núvol.
* **Versatilitat**: Pot contenir un servidor web integrat (servidor d'aplicacions web) o treballar amb diversos servidors simultàniament.
* **Gestió**: Inclou interfícies gràfiques (GUI) per a la seva administració, processament de transaccions, missatgeria i realització de tasques de seguretat.

---

## Diapositiva 2: El Servidor d'Aplicacions com a Intermediari
* **Arquitectura de Nivells**: Se situa físicament o virtualment entre el **servidor web** (front-end) i el **servidor de bases de dades** (back-end).
* **El "Treball Pesat"**: Quan un usuari sol·licita accés, el servidor d'aplicacions gestiona la càrrega en el back-end per emmagatzemar i processar sol·licituds dinàmiques.
* **Middleware**: Actua com el sistema operatiu que suporta el desenvolupament i l'entrega de l'aplicació, ja sigui d'escriptori, mòbil o web.
* **Connectivitat**: Utilitza diversos protocols i interfícies de programació d'aplicacions (API) per connectar un món de dispositius.

---

## Diapositiva 3: Terminologia i Conceptes Clau
* **Servidor Web**: Responsable d'emmagatzemar, processar i lliurar dades d'E/S de pàgines web.
* **Client Web**: Punt final (navegador, app) que intenta accedir als recursos.
* **HTTPS**: Protocol de comunicació segur entre servidor i client.
* **JSON**: Llenguatge essencial per a l'intercanvi de dades entre servidors web i d'aplicacions.
* **Lògica de Negoci**: Regles que defineixen com s'emmagatzemen les dades i com es transfereixen els recursos de l'aplicació.

---

## Diapositiva 4: Per què els necessitem? Seguretat i Eficiència
* **Optimització del trànsit**: Els servidors web són lleugers per a dades estàtiques; les peticions dinàmiques requereixen l'ajuda d'un servidor d'aplicacions d'alta potència.
* **Redundància**: Facilita la preservació i duplicació de l'arquitectura de l'aplicació a través de la xarxa.
* **Capa de Seguretat Addicional**: 
    * Actua com a barrera entre les comunicacions web i la base de dades.
    * Dificulta els atacs d'**Injecció SQL** en processar la lògica de negoci de forma aïllada.
    * Permet l'ús de **proxies inversos** i VPNs per xifrar i anonimitzar la comunicació.

---

## Diapositiva 5: L'Ecosistema PHP i la Pila LAMP
Dins dels servidors d'aplicacions, l'entorn PHP és fonamental pel seu pes en la web moderna:
* **Pila LAMP**: Combinació clàssica de Linux, Apache, MySQL i PHP.
* **L'enfocament Laravel**: 
    * Framework PHP líder per a aplicacions elegants i escalables.
    * Proporciona una estructura robusta per a la lògica de negoci i el maneig de dades.
* **Alternativa d'Alt Rendiment**: **NGINX + PHP-FPM**, que permet una gestió més eficient de les peticions PHP que l'Apache tradicional.
* **Altres Frameworks**: Symfony (per a entorns corporatius) o CodeIgniter.

---

## Diapositiva 6: Altres Tecnologies i el Model Java
* **El Model de Servlets (Java)**:
    * Un **servlet** és un programa Java que construeix pàgines dinàmiques basades en dades de l'usuari o bases de dades.
    * Més eficient que els antics CGI (obre un fil per petició en comptes d'un procés sencer).
* **Servidors Java Populars**:
    * **Apache Tomcat**: Especialitzat en servlets.
    * **JBoss EAP / GlassFish**: Per a aplicacions empresarials complexes.
* **Altres entorns:**
    * **Microsoft IIS**: Actua com a servidor d'aplicacions en l'ecosistema .NET.
    * **NGINX i Node.js**: Solucions modernes per gestionar aplicacions dinàmiques mitjançant JavaScript.    
* **Evolució**: El mercat creix cap al núvol, dispositius IoT i el suport per al teletreball (polítiques BYOD).

---

## Diapositiva 7: Servidor d'Aplicacions vs. Servidor Web
| Característica | Servidor d'Aplicacions | Servidor Web |
| :--- | :--- | :--- |
| **Dissenyat per a** | Peticions HTTP i lògica de negoci | Peticions HTTP |
| **Contingut** | Lògica de negoci complexa | Contingut estàtic |
| **Recursos** | Utilització pesada | Utilització lleugera |
| **Suport** | Transaccions, EJB, APIs complexes | Servlets, JSP, JSON |

---

## Diapositiva 8: El Desenvolupador Full-Stack i el Desplegament
* **Rol Integral**: Gestiona des de la interfície d'usuari (Frontend) fins a la lògica i seguretat del servidor (Backend).
* **Habilitats de Servidor**:
    * Configuració d'APIs i gestió de sessions segures.
    * Optimització de consultes a bases de dades (SQL i NoSQL).
* **DevOps**: Coneixement de **Docker** per a la contenització i desplegament en núvols com AWS, Azure o Google Cloud.
* **Conclusió**: El servidor d'aplicacions és el "millor amic" del servidor web; junts garanteixen una experiència d'usuari estable, escalable i segura.