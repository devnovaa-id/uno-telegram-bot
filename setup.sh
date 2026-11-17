#!/usr/bin/env bash
# Setup otomatis uno-telegram-bot.
# Ponytail: satu skrip idempoten, cukup untuk VPS Debian/Ubuntu/Arch/Fedora.
# Kalau butuh Docker/systemd, lihat bagian bawah README.

set -euo pipefail

BOLD=$'\e[1m'; RED=$'\e[31m'; GRN=$'\e[32m'; YLW=$'\e[33m'; RST=$'\e[0m'
say() { printf '%s==>%s %s\n' "$GRN" "$RST" "$*"; }
warn() { printf '%s!!%s %s\n' "$YLW" "$RST" "$*"; }
die() { printf '%sxx%s %s\n' "$RED" "$RST" "$*" >&2; exit 1; }

cd "$(dirname "$0")"

# ---------- 1. Python ----------
command -v python3 >/dev/null || die "python3 tidak ada. Install dulu: apt install python3 python3-venv"
PYVER=$(python3 -c 'import sys;print("%d.%d"%sys.version_info[:2])')
case "$PYVER" in
  3.8|3.9|3.10|3.11|3.12|3.13) ;;
  *) warn "Python $PYVER belum teruji. Lanjut?" ;;
esac
say "Python $PYVER terdeteksi"

# ---------- 2. gettext (msgfmt) ----------
if ! command -v msgfmt >/dev/null; then
  warn "msgfmt tidak ada, mencoba install gettext..."
  if command -v apt-get >/dev/null; then
    sudo apt-get update -qq && sudo apt-get install -y -qq gettext
  elif command -v dnf >/dev/null; then
    sudo dnf install -y gettext
  elif command -v pacman >/dev/null; then
    sudo pacman -S --noconfirm gettext
  else
    die "Install gettext manual (Butuh 'msgfmt')."
  fi
fi
say "gettext siap"

# ---------- 3. Virtualenv ----------
VENVDIR=".venv-uno"
if [ -d venv ] && [ ! -d "$VENVDIR" ]; then
  warn "Folder 'venv' lama terdeteksi, memakainya ulang"
  VENVDIR="venv"
fi
if [ ! -x "$VENVDIR/bin/python" ]; then
  say "Membuat virtualenv $VENVDIR"
  python3 -m venv "$VENVDIR" || die "python3-venv tidak tersedia. apt install python3-venv"
fi
[ -f "$VENVDIR/bin/activate" ] || die "Virtualenv $VENVDIR rusak (bin/activate tidak ada). Hapus lalu jalankan ulang."
# shellcheck disable=SC1091
source "$VENVDIR/bin/activate"
say "Virtualenv aktif: $VIRTUAL_ENV"

# ---------- 4. Dependensi ----------
say "Install dependensi (requirements.txt)"
python -m pip install --quiet --upgrade pip
python -m pip install --quiet -r requirements.txt
say "Dependensi terpasang"

# ---------- 5. config.json + token ----------
if [ ! -f config.json ]; then
  cp config.json.example config.json 2>/dev/null || die "config.json hilang dan tidak ada template"
fi

TOKEN=$(python - <<'PY'
import json, os
try:
    with open("config.json") as f:
        print(json.load(f).get("token", ""))
except Exception:
    print("")
PY
)

if [ -z "$TOKEN" ] || [ "$TOKEN" = "PUT_YOUR_BOT_TOKEN_HERE" ]; then
  warn "Token bot belum diisi."
  printf 'Masukkan token dari @BotFather (kosongkan untuk skip): '
  read -r INPUT || INPUT=""
  if [ -n "${INPUT:-}" ]; then
    python - "$INPUT" <<'PY'
import json, sys
p = "config.json"
data = json.load(open(p))
data["token"] = sys.argv[1].strip()
json.dump(data, open(p, "w"), indent=2)
print("Token tersimpan di config.json")
PY
    TOKEN="$INPUT"
  else
    warn "Dilewati. Isi 'token' di config.json atau set variabel TOKEN."
  fi
fi

if [ -n "$TOKEN" ] && [ "$TOKEN" != "PUT_YOUR_BOT_TOKEN_HERE" ]; then
  say "Token terisi"
else
  warn "Bot belum bisa start tanpa token."
fi

# ---------- 6. Compile locale ----------
say "Compile file terjemahan (.po -> .mo)"
find uno_telegram_bot -type d -name 'LC_MESSAGES' -print0 |
while IFS= read -r -d '' d; do
  [ -f "$d/unodev.po" ] || continue
  msgfmt "$d/unodev.po" -o "$d/unodev.mo" 2>/dev/null && echo "   ok: $d"
done

# ---------- 7. Data dir ----------
mkdir -p data
say "Direktori data: ./data"

# ---------- 8. Selesai ----------
cat <<EOF

${BOLD}Setup selesai.${RST}

Jalankan bot:
  source ${VENVDIR}/bin/activate
  python3 bot.py

Setelah bot hidup, atur di @BotFather:
  /setinline          (wajib, agar inline query jalan)
  /setinlinefeedback  (opsional)
  /setcommands        (paste isi commandlist.txt)

Cek cepat sebelum jalan:
  TOKEN=\$(python -c 'import json;print(json.load(open("config.json"))["token"])')
  python3 -c "from telegram import Bot; print(Bot('\$TOKEN').get_me())"

EOF
