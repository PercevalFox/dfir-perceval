# Module 04 — Endpoint Windows artefacts

## Artefacts clés
- EVTX (Security, Sysmon si dispo), Prefetch, Amcache, SRUM, Shimcache
- Timeline (CSV)

## Détection Lite (dans l’action)
- `powershell -enc`, `certutil -urlcache`, `bitsadmin`, `rundll32`
- 1102 (effacement de journaux), 4720/4728/4732 (comptes/groupes)
- `7z`, `rclone`, `vssadmin`, `bcdedit`, `ssh` (timeline)

## Astuces
- Toujours travailler sur **copie** ; garder les **hashs**.
- Aligner la **TZ** (UTC conseillé).
