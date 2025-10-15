# Wireshark — Filtres utiles

- `dns.flags.rcode != 0`
- `tcp.port == 445 or tcp.port == 3389`
- `tls.handshake.extensions_server_name contains "<domaine>"`
- `frame.time >= "YYYY-MM-DD 00:00:00"`
