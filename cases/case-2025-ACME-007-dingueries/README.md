# Case 2025-ACME-007 — Exfil nocturne (exemple)
Scénario d'entraînement : activité suspecte la nuit (exfil, création compte, effacement de logs). Les fichiers dans `inputs/*` sont au format texte/CSV pour déclencher la Détection Lite.

- Network : domaines/tld à risque + volumes nocturnes
- Endpoint : 4688 (powershell enc/certutil/bitsadmin/rundll32), 1102 (clear logs), 4720/4728 (compte/groupe), timeline (7z/rclone/vssadmin)
- SIEM : 4625 rafales, NTLM, ports 3389/445
- Mobile : mentions Telegram/Signal + "upload"
