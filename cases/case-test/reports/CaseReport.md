# Case Report
_Généré le: 2025-10-16T10:38:07Z (UTC)_

## Résumé exécutif
- **Période** : 2025-10-10/2025-10-15 (UTC)
- **Verdict** : Probable activité malveillante (exfil/élévation) — à confirmer par corrélation
- **Risque global** : 25 (FAIBLE)
- **Types analysés** : E
- **Prochaines actions (flash)** : voir Recommandations ci-dessous

## Table d'IoC (extrait)
| Type | Valeur | Source | Timestamp indicatif |
|------|--------|--------|----------------------|
| Commande | bcdedit | endpoint | (timeline)

## Cohérence temporelle
- Horodatages **UTC** ; aligner SIEM / endpoint / réseau. Attention aux décalages locaux.

## Intégrité & traçabilité
- Hash non fourni (à générer sur archives d'inputs)

## Recommandations priorisées
### Immédiat (0–24h)
- Continuer analyse standard selon hypothèses

### Sous 7 jours
- Compléter artefacts (SIEM/proxy/RAM si pertinent)

### Sous 30 jours
- Mettre à jour règles et tableaux de bord

## Gaps / Manques

- Artefacts réseau absents
- Exports SIEM absents
- Exports mobile absents

## ENDPOINT

# Endpoint Forensics Report (Auto)
_Généré le: 2025-10-16T10:38:07Z (UTC)_

- Case: `cases/case-test`
- Type: **endpoint**
- Dossier d'entrée: `cases/case-test/inputs/endpoint`
- Fichiers détectés: **2**
- **Risque (Détection Lite)**: FAIBLE (25/100)

## Findings (heuristiques)

- Effacement de journaux détecté (1102)

## Aperçu des fichiers
- test.txt
- timeline.csv

## Next steps suggérés
- Poursuivre l'analyse standard, compléter artefacts manquants.

