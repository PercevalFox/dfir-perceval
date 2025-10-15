# DFIR Monorepo — Cases + Engine + Workflows

Monorepo unique qui regroupe :
- **engine** (actions composites) pour générer des rapports par type (réseau/endpoint/siem/mobile), assembler un **CaseReport**, un **SuperReport** et un **RemediationPlan**.
- **case-template** pour créer rapidement un nouveau case.
- **cases/** qui contient un ou plusieurs cases.
- **.github/workflows/global-pipeline.yml** : un **seul workflow** qui pilote l'ensemble.

## Utilisation rapide
1. Crée un nouveau repo GitHub et pousse ce dossier.
2. Duplique `case-template/` vers `cases/<ID_CASE>/`, remplis `metadata/case.yml` et dépose tes artefacts dans `inputs/<type>/`.
3. Push → le workflow **DFIR Global Pipeline** crée automatiquement :
   - un rapport par type dans `outputs/per_type/<type>/report.md|json`,
   - un `reports/CaseReport.md` par case,
   - un `reports/SuperReport.md` (global),
   - et si `remediation/prereqs.yml` existe et qu’il y a ≥2 cases : `reports/RemediationPlan.md`.

## Structure
```
/engine/                   # actions composites
/case-template/            # modèle de case
/cases/<ID_CASE>/          # tes cas (copie du template)
/reports/                  # SuperReport + RemediationPlan (globaux)
/.github/workflows/        # pipeline global
/remediation/prereqs.yml   # prérequis pour générer le plan
```
