#!/bin/sh

# Obtiene IP pública; ciudad y país solo en tooltip para Waybar

# Pequeña utilidad para escapar cadenas en JSON
json_escape() {
  # Escapa barra inversa y comillas dobles
  printf "%s" "$1" | sed -e 's/\\\\/\\\\\\\\/g' -e 's/\"/\\\"/g'
}

CLASS="custom-public-ip"

# IP pública (timeout corto para no bloquear Waybar)
IP=$(curl -sS -m 3 https://api.ipify.org 2>/dev/null)

CITY=""
COUNTRY=""
COUNTRY_CODE=""

if [ -n "$IP" ]; then
  # Geolocalización usando ipwho.is (sin token). Limitamos campos para respuesta pequeña
  GEO_JSON=$(curl -sS -m 4 "https://ipwho.is/$IP?fields=success,city,country,country_code" 2>/dev/null)
  if echo "$GEO_JSON" | grep -q '"success":true'; then
    CITY=$(printf "%s" "$GEO_JSON" | sed -n 's/.*"city":"\([^"]*\)".*/\1/p')
    COUNTRY=$(printf "%s" "$GEO_JSON" | sed -n 's/.*"country":"\([^"]*\)".*/\1/p')
    COUNTRY_CODE=$(printf "%s" "$GEO_JSON" | sed -n 's/.*"country_code":"\([^"]*\)".*/\1/p')
  fi

  # Fallback: si ipwho.is no dio ciudad/código, intenta ipapi.co
  if [ -z "$CITY" ] || [ -z "$COUNTRY_CODE" ]; then
    ALT_JSON=$(curl -sS -m 4 "https://ipapi.co/$IP/json" 2>/dev/null)
    if [ -z "$CITY" ]; then
      CITY=$(printf "%s" "$ALT_JSON" | sed -n 's/.*"city":"\([^"]*\)".*/\1/p')
    fi
    if [ -z "$COUNTRY_CODE" ]; then
      COUNTRY_CODE=$(printf "%s" "$ALT_JSON" | sed -n 's/.*"country_code":"\([^"]*\)".*/\1/p')
    fi
    if [ -z "$COUNTRY" ]; then
      COUNTRY=$(printf "%s" "$ALT_JSON" | sed -n 's/.*"country_name":"\([^"]*\)".*/\1/p')
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
