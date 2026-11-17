#!/usr/bin/bash
# Regenerate template terjemahan (.pot) dari seluruh source paket.
set -euo pipefail

cd "$(dirname "$0")"

currentVer='1.0'

find uno_telegram_bot -name '*.py' -not -path '*/__pycache__/*' -print0 \
  | xargs -0 xgettext \
      -o ./uno_telegram_bot/i18n/locales/unodev.pot \
      --foreign-user \
      --package-name="uno_devnova_bot" \
      --package-version="$currentVer" \
      --msgid-bugs-address='admin@devnovaa.id' \
      --keyword=__ \
      --keyword=_ \
      --keyword=_:1,2 \
      --keyword=__:1,2

echo "Wrote ./uno_telegram_bot/i18n/locales/unodev.pot"
