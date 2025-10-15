# Module 03 — Network basics & filtres

## Quand / pourquoi
- Confirme l’alerte, réduit la fenêtre temporelle, liste IoC (domaines/IP).

## Entrées typiques
- PCAP (ou export CSV/SNI), flux, résolutions DNS.

## Détection Lite (dans l’action)
- TLD exotiques (.xyz, .ru, .top), plateformes exfil (mega, pastebin)
- Activité nocturne (créneaux 00–04 UTC)

## Filtres Wireshark utiles
- `tls.handshake.extensions_server_name contains "domaine"`
- `tcp.port == 445 or tcp.port == 3389`
- `frame.time >= "YYYY-MM-DD 00:00:00"`

## Next steps
- Extraire les domaines/IP → table IoC → enrichir SIEM.
