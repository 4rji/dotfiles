# Dotfiles y configuraciones personales

Repositorio personal con dotfiles, configuraciones de sistemas, stacks Docker, archivos de red y notas tecnicas. No es una aplicacion ni un proyecto con build: cada carpeta o archivo funciona como un artefacto independiente que se copia o se enlaza en la maquina destino.

## Contenido

### Terminal, shell y escritorio

| Ruta | Descripcion |
| --- | --- |
| `tmux.conf` | Configuracion principal de tmux. |
| `kitty/` | Configuraciones y temas para Kitty. |
| `p10k.zsh`, `p10k.zsh_blanco`, `p10k.zsh_cuadro-mini`, `p10k clean` | Variantes de Powerlevel10k. |
| `nanorc` | Configuracion basica para nano. |
| `hypr/` | Configuracion de Hyprland, Hyprpaper e Hypridle. |
| `waybar/` | Configuracion, estilos y scripts para Waybar. |
| `wofi/` | Estilos para Wofi. |

### NixOS

| Ruta | Descripcion |
| --- | --- |
| `configuration.nix` | Configuracion NixOS principal. |
| `configuration.nix-displaydual` | Variante para setup con doble pantalla. |
| `xps-configuration.nix` | Configuracion para equipo XPS. |
| `vm.nix` | Configuracion para maquina virtual. |
| `nixos/` | Snapshots historicos de configuraciones NixOS por fecha. |

### Docker y servicios

| Ruta | Descripcion |
| --- | --- |
| `dockerfiles/` | Dockerfiles y compose files para entornos como Firefox aislado, Chromium, Debian minimal, AFFiNE y WireGuard. |
| `caddy/` | Caddy con Docker Compose y soporte para variables de entorno. |
| `aaria-torrent/` | Stack de aria2. |
| `wazuhdocker/` | Compose y certificados para Wazuh. |
| `stig-navy/` | Compose relacionado con STIG/Navy. |
| `mail-fedora-ccdc/` | Configuraciones de Postfix y Dovecot para un setup Fedora/CCDC. |

### Red, VPN, proxy y tunneling

| Ruta | Descripcion |
| --- | --- |
| `frp/` | Configuraciones de FRP para tuneles reversos. |
| `wireguardfiles/` | Paquetes `.deb` de WireGuard y dependencias para despliegues offline. |
| `proxychainfiles/` | Paquetes `.deb` de proxychains para despliegues offline. |
| `xray_config.json`, `xray_config_client.json` | Configuraciones de Xray. |
| `squid.conf` | Configuracion extensa de Squid. |
| `unbound.conf` | Configuracion de Unbound. |
| `nginx_conf_default`, `nginx_conf_xray_setup` | Configuraciones de Nginx. |
| `paloalto/` | Exportaciones/configuraciones de Palo Alto/PAN-OS. |
| `vyos-config` | Configuracion de VyOS. |
| `radius-tacacs/` | Configuraciones de RADIUS/TACACS+. |

### SSH, Ansible y automatizacion

| Ruta | Descripcion |
| --- | --- |
| `config` | Fuente para `~/.ssh/config`. |
| `ansible_hosts` | Inventario de Ansible. |
| `ssha/`, `ssha.zip` | Manifiestos y paquete para helper SSH personalizado. |
| `auditd_rules` | Reglas de auditd. |
| `lsyncd-xsp.conf` | Configuracion de lsyncd. |

### Notas de seguridad y pentesting

| Ruta | Descripcion |
| --- | --- |
| `4rjinotes/` | Vault de notas tipo Obsidian con material de pentesting, GitHub, Ansible y writeups de HTB. |
| `4rjinotes/htb/` | Notas, escaneos, contenido y exploits por maquina de Hack The Box. |
| `angrywifi/` | Binarios comprimidos de angryoxide para varias arquitecturas. |
| `obsidian/` | Indice o apuntes relacionados con Obsidian. |

### Archivos empaquetados y artefactos

El repo tambien guarda paquetes, backups y artefactos utiles para despliegues o recuperacion:

- `GEYO-locacion.tar.gz`
- `jota.jex.enc`
- `wroot.zip`
- `pantallin_theme/`
- `pixel_blanco_invisible.png`
- Paquetes `.deb`, `.tar.gz`, `.zip` y exportaciones usadas como payloads offline.

## Uso esperado

No hay instalador unico. El flujo normal es copiar o enlazar cada archivo en su destino:

```bash
# ejemplos
cp tmux.conf ~/.tmux.conf
cp -r kitty ~/.config/kitty
cp -r waybar ~/.config/waybar
cp -r hypr ~/.config/hypr
```

Para NixOS, copiar la configuracion necesaria hacia `/etc/nixos/` y validar en la maquina correspondiente. Para Docker, entrar en la carpeta del servicio y usar el `Dockerfile` o `docker-compose.yml` especifico.

## Convenciones

- Los archivos sin sufijo suelen ser la version activa.
- Los archivos con sufijos como `.old`, `.bac`, `.save`, `.working`, `.bk`, `_broken` o carpetas `back/` son respaldos o variantes historicas.
- Los snapshots dentro de `nixos/` se mantienen como historial; no son modulos que deban fusionarse automaticamente.
- Los binarios y paquetes grandes estan versionados a proposito para despliegues offline.

## Seguridad

Este repositorio puede contener configuraciones reales, inventarios, topologias internas, tokens, llaves, IPs, usuarios o artefactos de laboratorios. Antes de publicar, compartir diffs o clonar en un entorno publico, revisar especialmente:

- `config`
- `ansible_hosts`
- `frp/`
- `xray_config*.json`
- `wireguardfiles/`
- `ssha/`
- `4rjinotes/htb/**/content/`
- `4rjinotes/htb/**/exploits/`

## Notas para mantenimiento

Este repo no tiene build, tests ni package manager en la raiz. La validacion se hace en la maquina o servicio donde se aplica cada configuracion.

Para detalles operativos adicionales dentro del repo, revisar `CLAUDE.md`.
