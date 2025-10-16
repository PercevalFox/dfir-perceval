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
