# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal, multi-machine dotfiles + infrastructure-config + pentesting-notes collection. **There is no build system, no tests, no package manager.** Files here are *sources* that get copied (or symlinked) into system locations on the target machine — for example `waybar/*` → `~/.config/waybar/`, `nixos/<month>/*.nix` → `/etc/nixos/`, `tmux.conf` → `~/.tmux.conf`, `caddy/Caddyfile` → host Caddy config, etc. Changes are validated on the target host, not here.

Don't try to `build`, `test`, `lint`, or `install` anything at the repo root. If you think a command should exist, it probably doesn't.

## Commit and workflow conventions

- Commit style is terse, imperative, file-scoped: `Update config`, `Update p10k.zsh`, `Update <dir>`. Match the existing tone — no scopes, no bodies unless truly needed.
- **Never** add `Co-Authored-By` or any AI attribution to commit messages (enforced by user's global rules).
- Never run a build step after changes — there isn't one.
- This repo tracks large binaries on purpose (`GEYO-locacion.tar.gz`, `jota.jex.enc`, `ssha.zip`, `angrywifi/*.tar.gz`, `wireguardfiles/*.deb`, `proxychainfiles/*.deb`). Don't "clean them up" — they're intentional payload for offline deploys.

## Repo layout — big picture

Top-level is flat, with each top-level dir (or loose file) being a **self-contained config bundle** for a specific tool or machine role. They are NOT modules of one system — they're independent artifacts. Edit one without worrying about the others.

Categories (not an exhaustive file list — explore the dir if you need specifics):

- **Terminal / shell / editor**: `tmux.conf`, `kitty/`, `p10k.zsh` (+ variants `p10k.zsh_blanco`, `p10k.zsh_cuadro-mini`, `p10k clean`), `nanorc`.
- **Wayland desktop (Hyprland stack)**: `hypr/`, `waybar/`, `wofi/`. `waybar/first/readme.txt` explains its own deploy step.
- **NixOS machines**: `configuration.nix`, `configuration.nix-displaydual`, `xps-configuration.nix`, `vm.nix`, plus `nixos/<month_year>/` snapshots (`ene 25/`, `feb 25/`, `mar_25/`). Each snapshot is a frozen copy of a machine's `/etc/nixos/` at a point in time. **Don't merge snapshots** — they're deliberate history. The *current* working Nix lives in the newest month dir and in the top-level `*.nix` files.
- **Docker stacks** (each standalone — one compose file, no shared orchestrator): `dockerfiles/` (Firefox-in-Docker variants, see `dockerfiles/readme` for RDP/Weston/xrdp notes), `caddy/`, `aaria-torrent/`, `wazuhdocker/`, `stig-navy/`.
- **Networking / tunneling / firewall**: `frp/` (frps + frpc, reverse tunnel; `frpc.toml` has an auth token — treat as secret), `wireguardfiles/`, `proxychainfiles/`, `xray_config.json`, `xray_config_client.json`, `squid.conf` (~340 KB — huge, don't reflow), `unbound.conf`, `nginx_conf_default`, `nginx_conf_xray_setup`, `paloalto/` (PAN-OS XML exports), `vyos-config`.
- **Mail server**: `mail-fedora-ccdc/` (Dovecot + Postfix config for a Fedora CCDC setup).
- **SSH inventory**: top-level `config` is the `~/.ssh/config` source. ~60+ hosts across sites (`cjs`, `cdmx`, `thp`, `changa`, `metro`, `mega`, etc.), many with `ProxyJump` chains. IPs and usernames are real — **don't paste diffs into public issues/PRs**.
- **Ansible**: `ansible_hosts` (inventory). Helper scripts (`ansiconf`, `ansicc`, `ansip`, `ansipp`, `ansihost`, `ansibleplay`, `sshansi`) are documented in `4rjinotes/Github/Ansible.md` but their sources live elsewhere on the user's machine, not in this repo.
- **Security / auditing**: `auditd_rules`, `stig-navy/`.
- **Obsidian vault**: `4rjinotes/` — personal pentesting notebook with HTB machine writeups (`htb/<box>/{nmap,content,exploits}`), academy notes, presentation drafts. `.obsidian/` is the Obsidian workspace config — don't touch. `4rjinotes/.trash/` is Obsidian's trash — also leave alone. HTB exploit artifacts (binaries, pcaps, captured hashes) live under `htb/<box>/content/` and `exploits/` and are intentional; don't delete as "junk".
- **ssha**: `ssha/*.json` — per-site JSON manifests for a custom SSH helper (see `ssha.zip` for the tool itself).
- **Assorted machine configs**: `lsyncd-xsp.conf`, `ansible_hosts`, `pixel_blanco_invisible.png` (transparent pixel — yes, it's used), etc.

## Naming conventions you will see everywhere

**Archived / backup variants live next to the live file with a suffix.** The plain name is the current one; the suffixed one is a frozen previous version. Do NOT edit the suffixed copies, and don't "reconcile" them.

Patterns to expect:
- `*.old`, `*.old-<date>`, `*.bac`, `*.save`, `*.working`, `*.ssss`, `*.aaa`, `*.bk`, `*_broken`, `*.2`, `<name> clean`
- Entire `back/` subfolders (`kitty/back/`, `waybar/first/`)
- Multiple themed variants of the same file (`p10k.zsh`, `p10k.zsh_blanco`, `p10k.zsh_cuadro-mini`, `p10k clean`) — all valid, user swaps between them manually.

When adding a new backup, follow the pattern (don't introduce a new scheme).

## Secrets and sensitive data

Some files in this repo contain real credentials, tokens, or internal topology:
- `frp/frpc.toml` — auth token
- `config` — internal hostnames, IPs, usernames, ProxyJump topology
- `ansible_hosts` — inventory with usernames/ports
- `caddy/Caddyfile` references `{env.CF_API_TOKEN}` (via env, OK)
- `xray_config*.json`, `wireguardfiles/`, `ssha/*.json`

Before sharing diffs, posting to issues, or pushing to a public mirror, sanity-check that you're not leaking these. Don't rotate or scrub values unprompted — the user manages rotation manually.

## Language preferences

The user writes commits and notes in both English and Rioplatense Spanish. When editing comments or note content, match the surrounding language of the file — don't translate.

## When you're asked to "update X"

1. Find the *live* file (unsuffixed name).
2. Check if a neighboring `<name>.<suffix>` exists — if the change is risky, snapshot the current live file into a new suffixed backup first (following the existing naming style).
3. Edit the live file.
4. Commit with `Update <filename-or-dir>`.
