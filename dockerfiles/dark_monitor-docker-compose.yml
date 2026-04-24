#!/bin/bash
set -euo pipefail

echo "========================================================="
echo "   AIL Framework - Extras Setup"
echo "   Tor + SMTP + Lacus + Telegram Feeder"
echo "========================================================="

BASE_DIR="${BASE_DIR:-$HOME}"
AIL_DIR="${AIL_DIR:-/home/sysadmin/ail-framework}"
CONFIG_FILE="$AIL_DIR/configs/core.cfg"

echo ""
echo "[*] Checking AIL installation..."

if [ ! -d "$AIL_DIR" ]; then
  echo "[!] AIL directory not found: $AIL_DIR"
  echo "    Run with:"
  echo "    AIL_DIR=/ruta/a/ail-framework ./setup_ail_extras_full.sh"
  exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
  echo "[!] AIL config not found: $CONFIG_FILE"
  exit 1
fi

echo "[+] AIL directory: $AIL_DIR"
echo "[+] Config file:   $CONFIG_FILE"

echo ""
echo "[*] STEP 1: Installing system dependencies..."

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update -y
sudo apt-get install -y tor libmagic1 ghostscript exiftool qpdf python3-venv python3-pip git curl docker.io docker-compose

echo ""
echo "[*] STEP 2: Configuring Tor SOCKS proxy on 127.0.0.1:9050..."

if sudo grep -qxF 'SocksPort 127.0.0.1:9050' /etc/tor/torrc; then
  echo "[+] Tor SOCKS port already configured."
else
  echo 'SocksPort 127.0.0.1:9050' | sudo tee -a /etc/tor/torrc > /dev/null
  echo "[+] Added SocksPort 127.0.0.1:9050 to /etc/tor/torrc"
fi

sudo systemctl restart tor
sudo systemctl enable tor

if ss -ltnp 2>/dev/null | grep -q '127.0.0.1:9050'; then
  echo "[+] Tor is listening on 127.0.0.1:9050"
else
  echo "[!] Warning: Tor does not appear to be listening on 127.0.0.1:9050"
  echo "    Check with: sudo systemctl status tor"
fi

echo ""
echo "[*] STEP 3: Keeping AIL dashboard local-only..."

cp "$CONFIG_FILE" "$CONFIG_FILE.bak.$(date +%Y%m%d_%H%M%S)"
echo "[+] Backup created: $CONFIG_FILE.bak.$(date +%Y%m%d_%H%M%S)"

if grep -q '^host *= *0\.0\.0\.0' "$CONFIG_FILE"; then
  sed -i 's/^host *= *0\.0\.0\.0/host = 127.0.0.1/' "$CONFIG_FILE"
  echo "[+] Changed host = 0.0.0.0 back to host = 127.0.0.1"
else
  echo "[+] AIL is not configured as host = 0.0.0.0"
fi

echo ""
echo "[*] STEP 4: Configuring SMTP notifications..."

read -rp "Enter sender email: " SENDER
read -srp "Enter sender password/app password: " SENDER_PW
echo ""
read -rp "Enter SMTP host, e.g. smtp.gmail.com: " SENDER_HOST
read -rp "Enter SMTP port [default: 587]: " SENDER_PORT

SENDER_PORT="${SENDER_PORT:-587}"
SENDER_USER="$SENDER"

update_notification_key() {
  local key="$1"
  local value="$2"

  if sed -n '/^\[Notifications\]/,/^\[/p' "$CONFIG_FILE" | grep -q "^$key *="; then
    sed -i "/^\[Notifications\]/,/^\[/ s|^$key *=.*|$key = $value|" "$CONFIG_FILE"
  else
    sed -i "/^\[Notifications\]/a $key = $value" "$CONFIG_FILE"
  fi
}

update_notification_key "sender" "$SENDER"
update_notification_key "sender_user" "$SENDER_USER"
update_notification_key "sender_pw" "$SENDER_PW"
update_notification_key "sender_host" "$SENDER_HOST"
update_notification_key "sender_port" "$SENDER_PORT"

echo "[+] SMTP notification settings updated."

echo ""
echo "[*] STEP 5: Deploying Lacus Dark Web Crawler..."

cd "$BASE_DIR"

if [ -d "$BASE_DIR/lacus" ]; then
  echo "[+] Lacus directory already exists: $BASE_DIR/lacus"
  cd "$BASE_DIR/lacus"
  git pull || true
else
  git clone https://github.com/ail-project/lacus.git "$BASE_DIR/lacus"
  cd "$BASE_DIR/lacus"
fi

cat <<EOF > docker-compose.override.yml
services:
  lacus:
    network_mode: "host"
EOF

if command -v docker-compose >/dev/null 2>&1; then
  sudo docker-compose up -d --build
elif docker compose version >/dev/null 2>&1; then
  sudo docker compose up -d --build
else
  echo "[!] Docker Compose not found."
  echo "    Your original script assumes Docker/Compose is already installed."
  echo "    Install docker-compose or docker compose plugin, then rerun this script."
  exit 1
fi

echo "[+] Lacus deployment command completed."

echo ""
echo "[*] STEP 6: Setting up Telegram Feeder Environment..."

cd "$BASE_DIR"

if [ -d "$BASE_DIR/ail-feeder-telegram" ]; then
  echo "[+] Telegram feeder directory already exists: $BASE_DIR/ail-feeder-telegram"
  cd "$BASE_DIR/ail-feeder-telegram"
  git pull || true
else
  git clone https://github.com/ail-project/ail-feeder-telegram.git "$BASE_DIR/ail-feeder-telegram"
  cd "$BASE_DIR/ail-feeder-telegram"
fi

python3 -m venv venv
source venv/bin/activate
python3 -m pip install --upgrade pip
pip3 install -U -r requirements.txt

if [ ! -f etc/conf.cfg ]; then
  cp etc/conf.cfg.sample etc/conf.cfg
  echo "[+] Created Telegram config: $BASE_DIR/ail-feeder-telegram/etc/conf.cfg"
else
  echo "[+] Telegram config already exists: $BASE_DIR/ail-feeder-telegram/etc/conf.cfg"
fi

deactivate

echo ""
echo "[*] STEP 7: Final checks..."

echo ""
echo "[+] AIL bind settings:"
grep -E '^host *=|^port *=' "$CONFIG_FILE" || true

echo ""
echo "[+] SMTP notification config, password hidden:"
sed -n '/^\[Notifications\]/,/^\[/p' "$CONFIG_FILE" \
  | sed 's/^sender_pw *=.*/sender_pw = ********/'

echo ""
echo "[+] Tor listener:"
ss -ltnp 2>/dev/null | grep '127.0.0.1:9050' || true

echo ""
echo "[+] Docker containers:"
sudo docker ps || true

echo ""
echo "========================================================="
echo " [+] DONE"
echo "========================================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Restart AIL:"
echo "   $AIL_DIR/bin/LAUNCH.sh -r"
echo ""
echo "2. Access AIL safely with SSH tunnel:"
echo "   ssh -L 7000:127.0.0.1:7000 sysadmin@10.0.4.90"
echo ""
echo "3. Open:"
echo "   https://localhost:7000/"
echo ""
echo "4. In AIL, add Lacus Crawler URL:"
echo "   http://127.0.0.1:7100"
echo ""
echo "5. Edit Telegram feeder config:"
echo "   nano $BASE_DIR/ail-feeder-telegram/etc/conf.cfg"
echo ""
echo "Important:"
echo "   This script does NOT expose AIL on 0.0.0.0."
echo "   This script uses the same base apt dependencies as your original script."