# Module 05 — SIEM (KQL / SPL)

## Use-cases fréquents
- Rafales 4625, connexions RDP/SMB, comptes service anormaux, NTLM externe.

## Snippets KQL (Sentinel-like)
```kql
SecurityEvent
| where TimeGenerated between (datetime(2025-10-14) .. datetime(2025-10-15))
| where EventID in (4625, 4624, 4648, 4672, 4720, 4728, 4732)
| summarize count() by Account, EventID, bin(TimeGenerated, 10m)
```

## Snippets SPL (Splunk-like)
```spl
index=winevent* earliest=10/14/2025:00:00:00 latest=10/15/2025:23:59:59
EventCode IN (4625,4624,4672,4720,4728,4732)
| bin _time span=10m
| stats count by user, EventCode, _time
```
