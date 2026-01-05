#!/usr/bin/env bash
set -euo pipefail

qdbus_bin=""
for candidate in qdbus qdbus6 qdbus-qt5 qdbus-qt6; do
  if command -v "$candidate" >/dev/null 2>&1; then
    qdbus_bin="$candidate"
    break
  fi
done

if [[ -z "$qdbus_bin" ]]; then
  text="VD n/a"
  tooltip="Plasma escritorio: qdbus no disponible"
else
  current="$("$qdbus_bin" \
    org.kde.KWin \
    /VirtualDesktopManager \
    org.freedesktop.DBus.Properties.Get \
    org.kde.KWin.VirtualDesktopManager \
    current 2>/dev/null || true)"

  desktops="$("$qdbus_bin" --literal \
    org.kde.KWin \
    /VirtualDesktopManager \
    org.freedesktop.DBus.Properties.Get \
    org.kde.KWin.VirtualDesktopManager \
    desktops 2>/dev/null || true)"

  label=""
  if [[ -n "$current" && -n "$desktops" && -n "${current// }" ]]; then
    if command -v python3 >/dev/null 2>&1; then
      label="$(CURRENT_ID="$current" DESKTOPS_RAW="$desktops" python3 - <<'PY'
import os
import re

current_raw = os.environ.get("CURRENT_ID", "").strip()
match = re.search(r'[0-9a-fA-F-]{36}', current_raw)
current = match.group(0) if match else current_raw.strip('"')
data = os.environ.get("DESKTOPS_RAW", "")
for index, desk_id, desk_name in re.findall(r'\(uss\)\s*(\d+),\s*"([^"]+)",\s*"([^"]*)"', data):
    if desk_id == current:
        name = desk_name.strip()
        if name:
            print(name)
        else:
            print(str(int(index) + 1))
        break
PY
      )"
    else
      label="$(printf '%s\n' "$desktops" | sed -n "s/.*\"$current\", \"\\([^\"]*\\)\".*/\\1/p")"
    fi
  fi

  if [[ -z "$label" ]]; then
    label="n/a"
  fi

  text="VD ${label}"
  tooltip="Plasma escritorio: ${label}"
fi

if command -v python3 >/dev/null 2>&1; then
  TEXT_VALUE="$text" TOOLTIP_VALUE="$tooltip" python3 - <<'PY'
import json
import os
text = os.environ.get("TEXT_VALUE", "")
tooltip = os.environ.get("TOOLTIP_VALUE", "")
print(json.dumps({"text": text, "tooltip": tooltip}))
PY
else
  escape() {
    printf '%s' "$1" | sed \
      -e 's/\\/\\\\/g' \
      -e 's/"/\\"/g' \
      -e 's/\r/\\r/g' \
      -e 's/\t/\\t/g' \
      -e ':a;N;$!ba;s/\n/\\n/g'
  }

  text_esc="$(escape "$text")"
  tooltip_esc="$(escape "$tooltip")"
  printf '{"text":"%s","tooltip":"%s"}\n' "$text_esc" "$tooltip_esc"
fi
