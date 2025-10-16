# Support de cours — Digital Forensics (enquête administrative)  
_par Perceval_ • Version écran partage (2 jours)

---

## 1) Pourquoi on est là 
Comprendre **ce qui s’est passé**, **comment** on l’a vu dans les traces, et **quoi faire maintenant** — en mode **administratif**, simple, traçable, RGPD.

---

## 2) Plan de la formation (fil rouge)
- **Jour 1** : bases & vocabulaire → lecture d’artefacts → premiers rapports auto  
- **Jour 2** : corrélation multi-sources → rapport final → remédiation & gouvernance

---

## 3) Vocabulaire clé 
- **Case** : dossier d’enquête (un répertoire avec ses sous-dossiers).
- **Artefacts** : fichiers de traces (journaux Windows, exports SIEM, listes domaines/IP…).
- **Inputs** : endroit où l’on dépose les artefacts (par type).
- **Rapport auto** : résumé généré (markdown) avec findings, score, next steps.
- **IoC (Indicateurs de Compromission)** : domaines/IP/comptes/ports/commandes suspects.
- **Timeline** : suite d’événements dans l’ordre du temps (UTC).
- **Endpoint** : poste/serveur (Windows).
- **SIEM** : plateforme qui centralise les logs (ex : Sentinel, Splunk).
- **RGPD** : règles de minimisation, traçabilité, rétention des données.
- **UTC** : heure universelle (référence unique pour tout aligner).

---

## 4) Cadre & règles (administratif, pas pénal)
- **Base légale & périmètre** documentés (ordre de mission interne).
- **Minimisation** : on ne prend que ce qui est nécessaire.
- **Traçabilité** : actions horodatées (UTC), journal de ce qu’on fait.
- **Intégrité** : empreintes (hash) des archives d’inputs quand c’est possible.
- **Rétention** : durée et accès restreints, définis à l’avance.

---

## 5) La carte du dépôt (comment on s’oriente)
```
engine/                      actions d’analyse automatiques (composites)
cases/<ID_CASE>/             dossier d’enquête
  inputs/
    network/                 artefacts réseau (domains.txt, flows.csv, …)
    endpoint/                artefacts endpoint (events.txt, timeline.csv, …)
    siem/                    exports SIEM (auth.csv, …)
    mobile/                  exports logiques (ciblés)
  outputs/per_type/...       rapports unitaires (auto)
  reports/CaseReport.md      rapport du case (auto, enrichi)
reports/SuperReport.md       vue globale multi-cas (auto)
remediation/prereqs.yml      prérequis plan de remédiation (auto si ≥2 cases)
```

---

## 6) Ce que sort l’analyse (Détection “Lite”, lisible de suite)
### Endpoint (Windows)
- **Signaux** : `powershell -enc`, `certutil -urlcache`, `bitsadmin`, `rundll32`,  
  EventID **1102** (effacement journaux), **4720/4728** (comptes/groupes),  
  timeline avec `7z`, `rclone`, `vssadmin`, `bcdedit`, `ssh`.
- **Interprétation** : probables préparations/exécution d’outils → vérifier persistance/exfil.

### Network (Réseau)
- **Signaux** : TLD exotiques (.xyz/.ru/.top), plateformes exfil (mega, pastebin),  
  activité **nocturne** (00–04 UTC), pics de flux sortants.
- **Interprétation** : destinations douteuses / horaires inhabituels → enrichir SIEM.

### SIEM (Exports)
- **Signaux** : rafales **4625** (échecs), **NTLM/Type 3**, ports **3389/445** notables.
- **Interprétation** : brute-force / mouvements latéraux → corréler comptes & hôtes.

### Mobile (Exports logiques ciblés)
- **Signaux** : mentions d’**upload/export**, messageries (Signal/Telegram), liens cloud.
- **Interprétation** : coordination/transport d’artefacts → recouper avec le reste.

> Chaque rapport unitaire affiche : **Findings**, **Score (0–100)**, **Niveau** (Négl./Faible/Moyen/Haut), **Next steps**.  
> Le **CaseReport** assemble tout et ajoute : **Résumé exécutif**, **Table d’IoC**, **Score global**, **Reco**, **Gaps**.

---

## 7) Lire un **CaseReport** (structure stable)
1. **Résumé exécutif (5 lignes)**  
   Période (**UTC**), verdict (ex. “probable exfil”), **risque global** (ex. 72/100 “Haut”), types analysés, **3 actions flash**.
2. **Table d’IoC (extrait)**  
   Domaines/IP/comptes/ports/commandes + source + timestamp indicatif.
3. **Cohérence temporelle**  
   Tout en **UTC**, rappeler l’alignement réseau/endpoint/SIEM.
4. **Intégrité**  
   Hashes fournis ? Sinon “à générer”.
5. **Recommandations**  
   **0–24h** (containment), **7j** (durcissement, revues), **30j** (surveillance, lessons learned).
6. **Gaps / Manques**  
   Ce qu’il manque pour conclure mieux (proxy, RAM, timeline…).
7. **Détail par type**  
   Reprise des rapports unitaires (Findings + Next steps).

---

## 8) Exemples concrets d’IoC (à repérer vite)
- **Domaine** : `exfil-top.xyz` (network/domains)  
- **IP** : `203.0.113.99` (network/flows)  
- **Compte** : `svc-backup` (endpoint/siem)  
- **Port** : `3389` (siem/auth)  
- **Commande** : `powershell -enc ...` (endpoint/events)

---

## 9) Comment on “raconte” une timeline (schéma mental)
- **Avant** : connexions suspectes la nuit (réseau), échecs d’auth (SIEM)  
- **Pendant** : création d’archives + transferts (`7z` → `rclone`) (endpoint)  
- **Après** : effacement des journaux (**1102**), élévation de droits (**4728**)  
→ **Hypothèse** : exfil + persistance → **Actions** immédiates demandées.

---

## 10) Recommandations (prêtes à insérer dans le rapport)
### Immédiat (0–24h)
- Isoler hôtes affectés, geler les preuves.
- Bloquer domaines/IP observés (proxy/DNS/EDR).
- Réinitialiser secrets exposés, renforcer MFA.
- Vérifier la persistance (services, tâches planifiées, Run keys).

### Sous 7 jours
- Durcir journaux (Sécurité + PowerShell), GPO de durcissement.
- Revue comptes récents et groupes (créations/ajouts).
- Réduire/examiner NTLM et accès RDP/SMB exposés.

### Sous 30 jours
- Surveiller IoC dans le SIEM pendant 30 jours (requêtes planifiées).
- Mettre à jour playbooks/règles et former les équipes.
- “Lessons learned” et communication interne.

---

## 11) Qualité & gouvernance (checklist de fond)
- **UTC partout**, périmètre écrit, journal d’actions à jour.
- **Minimisation** et **pseudonymisation** si partage externe.
- **Hashes** calculés sur les archives d’inputs (intégrité).
- **Reco** avec **responsable** + **délai** (actionnables).
- **Rétention** et accès restreints validés.

---

## 12) Pièges courants & parades
- **Heures locales mélangées** → tout remettre en **UTC**.  
- **Exports SIEM énormes** → **fenêtrer** (dates précises, pas tout l’index).  
- **Dossiers vides** → pas de rapport pour le type → déposer un minimum.  
- **Faux positifs** → confirmer avec **au moins 2 sources** (ex : endpoint + réseau).

---

## 13) Petit glossaire 
- **Containment** : actions pour **contenir** l’incident (isoler, bloquer, geler).
- **Exfiltration** : **sortie** de données vers l’extérieur (cloud, FTP, etc.).
- **Latéralisation** : déplacement de l’attaquant **d’une machine à l’autre**.
- **Persistance** : mécanismes pour **rester** après redémarrage (services, tâches…).
- **Heuristique** : règle simple qui **signale** un comportement **suspect** (pas une preuve).
- **Hash** : empreinte unique d’un fichier (ex. **SHA-256**), pour vérifier l’intégrité.

---

## 14) Modèles à insérer (copier/coller)

### 14.1 Résumé exécutif (5 lignes)
- **Période** : `<YYYY-MM-DD/YYYY-MM-DD>` (**UTC**)  
- **Verdict** : `<ex : Activité malveillante probable (HAUT)>`  
- **Risque global** : `<score>/<niveau>`  
- **Types analysés** : `<endpoint, network, siem, mobile>`  
- **Actions flash** : `<isoler hôtes / bloquer IoC / réinit secrets>`

### 14.2 Table d’IoC (modèle)
| Type     | Valeur            | Source           | Timestamp |
|----------|-------------------|------------------|-----------|
| Domaine  | example.xyz       | network/domains  | 01:02Z    |
| IP       | 203.0.113.99      | network/flows    | 01:03Z    |
| Compte   | svc-backup        | endpoint/siem    | 01:30Z    |
| Port     | 3389              | siem/auth        | 01:16Z    |
| Commande | powershell -enc … | endpoint/events  | 01:00Z    |

---

## 15) À retenir 
1. **UTC partout** (cohérence).  
2. **Minimisation** & **traçabilité** (RGPD, journal).  
3. **3–5 IoC** bien listés valent mieux que 50 flous.  
4. **Recommandations** concrètes, datées, avec **responsables**.  
5. Le rapport **raconte une histoire** : début → milieu → fin → **actions**.

---

### Fin
> Lire le CaseReport, identifier les signaux importants, décider — calmement, proprement, **avec gouvernance**.
