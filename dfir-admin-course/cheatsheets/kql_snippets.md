# KQL — Snippets

```kql
SecurityEvent
| where TimeGenerated between (datetime(2025-10-14) .. datetime(2025-10-15))
| where EventID in (4625,4624,4672,4720,4728,4732)
| summarize count() by Account, EventID, bin(TimeGenerated, 10m)
```
