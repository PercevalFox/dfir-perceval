# Module 02 — Monorepo & Workflow

- Dossiers clés : `engine/` (actions), `cases/` (tes dossiers d’enquête), `remediation/`, `.github/workflows/`
- Dépose dans `cases/<ID_CASE>/inputs/<type>/` → **Actions** déclenchent :
  - `outputs/per_type/<type>/report.md|json`
  - `reports/CaseReport.md`
  - `reports/SuperReport.md` (global)
  - `reports/RemediationPlan.md` si ≥2 cases + prereqs
- Les **Détections Lite** donnent un **score** et des **Findings** utilisables immédiatement.
