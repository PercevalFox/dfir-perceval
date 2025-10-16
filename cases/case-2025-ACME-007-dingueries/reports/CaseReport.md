# Case Report
_Généré le: 2025-10-16T23:05:41Z (UTC)_

## Résumé exécutif
- **Période** : 2025-10-14/2025-10-15 (UTC)
- **Verdict** : Probable activité malveillante — à confirmer
- **Risque global** : 61 (MOYEN)
- **Types analysés** : endpoint, network, siem, mobile
- **Prochaines actions (flash)** : voir Recommandations ci-dessous

## Table d'IoC (extrait)
| Type | Valeur | Source | Timestamp indicatif |
|------|--------|--------|----------------------|
| Domaine | api.megaupload.com | network | (voir fichier) |
| Domaine | exfil-top.xyz | network | (voir fichier) |
| Domaine | pastebin.com | network | (voir fichier) |
| Domaine | shady.ru | network | (voir fichier) |
| Domaine | updates.microsoft.com | network | (voir fichier) |
| IP | 10.0.5.23 | network | (voir fichier) |
| IP | 104.18.1.1 | network | (voir fichier) |
| IP | 13.107.246.45 | network | (voir fichier) |
| IP | 198.51.100.42 | network | (voir fichier) |
| IP | 203.0.113.99 | network | (voir fichier) |
| IP | 23.45.67.89 | network | (voir fichier) |
| Compte | svc-backup | endpoint/siem | (voir fichier) |
| Port | 3389 | siem/network | (voir fichier) |
| Port | 445 | siem/network | (voir fichier) |
| Commande | bcdedit | endpoint | (timeline) |
| Commande | bitsadmin | endpoint | (timeline) |
| Commande | certutil -urlcache | endpoint | (timeline) |
| Commande | powershell -enc | endpoint | (timeline) |
| Commande | rclone | endpoint | (timeline) |
| Commande | rundll32 | endpoint | (timeline) |
| Commande | ssh | endpoint | (timeline) |
| Commande | vssadmin | endpoint | (timeline) |

## Cohérence temporelle
- Horodatages **UTC** ; aligner SIEM / endpoint / réseau. Attention aux décalages locaux.

## Intégrité & traçabilité
- Hash non fourni (à générer sur archives d'inputs)

## Recommandations priorisées
### Immédiat (0–24h)
- Isoler l'hôte, geler preuves, réinit secrets
- Bloquer domaines/IP observés (proxy/DNS/EDR)
- Vérifier persistance (services, tâches planifiées)

### Sous 7 jours
- Durcir journaux (Sécurité/PowerShell), GPO
- Revue comptes/groupes, renforcer MFA

### Sous 30 jours
- Surveiller IoC 30j (SIEM)
- Playbooks & leçons apprises

## Gaps / Manques
(Rien de bloquant détecté)

## NETWORK

# Network Forensics Report (Auto)
_Généré le: 2025-10-16T23:05:40Z (UTC)_

- Case: `cases/case-2025-ACME-007-dingueries`
- Type: **network**
- Dossier d'entrée: `cases/case-2025-ACME-007-dingueries/inputs/network`
- Fichiers détectés: **2**
- **Risque (Détection Lite)**: HAUT (50/100)

## Findings (heuristiques)

- TLD potentiellement risqués vus (.top/.xyz/.ru/...)
- Marqueurs d'outils/plateformes d'exfil potentiels
- Activité nocturne détectée (à vérifier avec contexte)

## Aperçu des fichiers
- domains.txt
- flows.csv

## Next steps suggérés
- Extraire domaines/IP → enrichir SIEM, vérifier exfil.

## ENDPOINT

# Endpoint Forensics Report (Auto)
_Généré le: 2025-10-16T23:05:41Z (UTC)_

- Case: `cases/case-2025-ACME-007-dingueries`
- Type: **endpoint**
- Dossier d'entrée: `cases/case-2025-ACME-007-dingueries/inputs/endpoint`
- Fichiers détectés: **2**
- **Risque (Détection Lite)**: HAUT (90/100)

## Findings (heuristiques)

- Process suspects (4688/CommandLine : powershell -enc / certutil / bitsadmin / rundll32)
- Effacement de journaux détecté (1102)
- Comptes/Groupes modifiés (4720/4728/4732)
- Usage archives/outil transferts/anti-sauvegarde dans timeline

## Aperçu des fichiers
- events.txt
- timeline.csv

## Next steps suggérés
- Isoler l'hôte, gel des preuves, collecte RAM (si possible).
- Rechercher persistance (services, tâches planifiées), exfil.

## SIEM

# SIEM Forensics Report (Auto)
_Généré le: 2025-10-16T23:05:41Z (UTC)_

- Case: `cases/case-2025-ACME-007-dingueries`
- Type: **siem**
- Dossier d'entrée: `cases/case-2025-ACME-007-dingueries/inputs/siem`
- Fichiers détectés: **2**
- **Risque (Détection Lite)**: HAUT (45/100)

## Findings (heuristiques)

- Rafales d'échecs d'authent (4625) dans exports SIEM
- Authent NTLM/Type 3 notable (vérifier exposition)
- Activité RDP/SMB à surveiller

## Next steps suggérés
- Élargir périmètre (latéralisation), corréler comptes/hosts.

## MOBILE

# Mobile Forensics Report (Auto)
_Généré le: 2025-10-16T23:05:41Z (UTC)_

- Case: `cases/case-2025-ACME-007-dingueries`
- Type: **mobile**
- Dossier d'entrée: `cases/case-2025-ACME-007-dingueries/inputs/mobile`
- Fichiers détectés: **1**
- **Risque (Détection Lite)**: MOYEN (20/100)

## Findings (heuristiques)

- Messageries détectées (vérifier canaux et pièces jointes)
- Transferts/exports mentionnés dans les artefacts

## Next steps suggérés
- Vérifier la période, les contacts et pièces jointes associées aux événements pertinents.

