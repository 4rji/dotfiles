#!/bin/sh

# Obtiene IP pública; ciudad y país solo en tooltip para Waybar

# Pequeña utilidad para escapar cadenas en JSON
json_escape() {
  # Escapa barra inversa y comillas dobles
  printf "%s" "$1" | sed -e 's/\\\\/\\\\\\\\/g' -e 's/\"/\\\"/g'
}

# Extrae un valor string por clave en JSON (tolerante a espacios y saltos de linea)
json_get_string() {
  KEY="$1"
  JSON_ONE_LINE=$(printf "%s" "$2" | tr -d '\n')
  if printf "%s" "$JSON_ONE_LINE" | grep -q "\"$KEY\"[[:space:]]*:[[:space:]]*null"; then
    return 0
  fi
  printf "%s" "$JSON_ONE_LINE" | sed -n "s/.*\"$KEY\"[[:space:]]*:[[:space:]]*\"\\([^\"]*\\)\".*/\\1/p"
}

CLASS="custom-public-ip"

# IP pública (timeout corto para no bloquear Waybar)
IP=$(curl -sS -m 3 https://api.ipify.org 2>/dev/null)

CITY=""
COUNTRY=""
COUNTRY_CODE=""

if [ -n "$IP" ]; then
  # Geolocalización usando ipapi.co (sin token)
  GEO_JSON=$(curl -sS -m 4 "https://ipapi.co/$IP/json" 2>/dev/null)
  CITY=$(json_get_string "city" "$GEO_JSON")
  COUNTRY=$(json_get_string "country_name" "$GEO_JSON")
  COUNTRY_CODE=$(json_get_string "country_code" "$GEO_JSON")

  # Fallback: si ipapi.co no dio ciudad/código, intenta ipinfo.io
  if [ -z "$CITY" ] || [ -z "$COUNTRY_CODE" ]; then
    ALT_JSON=$(curl -sS -m 4 "https://ipinfo.io/$IP/json" 2>/dev/null)
    if [ -z "$CITY" ]; then
      CITY=$(json_get_string "city" "$ALT_JSON")
    fi
    if [ -z "$COUNTRY_CODE" ]; then
      COUNTRY_CODE=$(json_get_string "country" "$ALT_JSON")
    fi
  fi
fi

if [ -z "$IP" ]; then
  TEXT="--"
  TOOLTIP="No se pudo obtener IP"
  ESC_TEXT=$(json_escape "$TEXT")
  ESC_TOOLTIP=$(json_escape "$TOOLTIP")
  echo '{"text": '"\"$ESC_TEXT\""', "class": '"\"$CLASS\""', "tooltip": '"\"$ESC_TOOLTIP\""'}'
  exit 0
fi

# Texto en barra: muestra IP y, si hay datos, "(Ciudad, CC)"
TEXT="$IP"
if [ -n "$CITY" ]; then
  if [ -n "$COUNTRY_CODE" ]; then
    TEXT="$IP ($CITY, $COUNTRY_CODE)"
    TOOLTIP="IP: $IP | $CITY, $COUNTRY_CODE"
  elif [ -n "$COUNTRY" ]; then
    TEXT="$IP ($CITY, $COUNTRY)"
    TOOLTIP="IP: $IP | $CITY, $COUNTRY"
  else
    TEXT="$IP ($CITY)"
    TOOLTIP="IP: $IP | $CITY"
  fi
else
  TOOLTIP="IP: $IP"
fi

# Imprime JSON para Waybar
ESC_TEXT=$(json_escape "$TEXT")
ESC_TOOLTIP=$(json_escape "$TOOLTIP")
echo '{"text": '"\"$ESC_TEXT\""', "class": '"\"$CLASS\""', "tooltip": '"\"$ESC_TOOLTIP\""'}'
