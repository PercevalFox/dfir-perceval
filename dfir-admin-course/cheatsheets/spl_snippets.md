# SPL — Snippets

```spl
index=winevent* earliest=10/14/2025:00:00:00 latest=10/15/2025:23:59:59
EventCode IN (4625,4624,4672,4720,4728,4732)
| bin _time span=10m
| stats count by user, EventCode, _time
```
