#!/usr/bin/bash

currentVer='1.0'

xgettext *.py -o ./locales/unodev.pot --foreign-user \
  --package-name="uno_devnova_bot" \
  --package-version="$currentVer" \
  --msgid-bugs-address='admin@devnovaa.id' \
  --keyword=__ \
  --keyword=_ \
  --keyword=_:1,2 \
  --keyword=__:1,2