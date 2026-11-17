# uno-telegram-bot

Bot Telegram untuk bermain **UNO** di grup lewat inline query.
Berjalan sebagai [@uno_devnova_bot](https://t.me/uno_devnova_bot).

Channel update: [@dreamtorealitycreative](https://t.me/dreamtorealitycreative)

## Fitur

- Inline query — play kartu langsung dari chat box.
- Beberapa mode: Classic, Fast, Wild, dan Text.
- Statistik pemain, dukungan multi-bahasa, dan pengaturan per-user.
- Beberapa grup dapat dimainkan bersamaan.

## Asal & Lisensi

Fork dari [`mau_mau_bot`](https://github.com/jh0ker/mau_mau_bot) karya
[Jannes Höke](https://github.com/jh0ker) dan para kontributor.
Dirilis ulang di bawah **GNU Affero General Public License v3 (AGPLv3)**.
Modifikasi oleh [devnovaa-id](https://github.com/devnovaa-id).
Lihat [`LICENSE`](./LICENSE).

## Prasyarat

- Python 3.8+
- `gettext` (menyediakan `msgfmt`) — untuk meng-compile terjemahan.

## Instalasi

### Cara cepat

```sh
git clone https://github.com/devnovaa-id/uno-telegram-bot.git
cd uno-telegram-bot
./setup.sh
```

`setup.sh` akan membuat virtualenv (`.venv-uno`, atau memakai `venv/` yang sudah ada),
meng-install dependensi, menanyakan token, dan meng-compile terjemahan.

Jalankan bot:

```sh
source .venv-uno/bin/activate
python3 bot.py
```

### Manual

```sh
python3 -m venv .venv-uno
source .venv-uno/bin/activate
pip install -r requirements.txt

cp config.json.example config.json
# isi "token" pada config.json

find . -maxdepth 2 -type d -name 'LC_MESSAGES' \
  -exec bash -c 'msgfmt {}/unodev.po -o {}/unodev.mo' \;

python3 bot.py
```

## Konfigurasi

Setelan ada di `config.json` (lihat `config.json.example`) dan dapat dioverride
lewat environment variable.

| Kunci | Env | Default | Keterangan |
|---|---|---|---|
| `token` | `TOKEN` | — | Token bot dari @BotFather. |
| `workers` | `WORKERS` | `32` | Jumlah worker. |
| `admin_list` | `ADMIN_LIST` | `[]` | Daftar user ID admin. |
| `open_lobby` | `OPEN_LOBBY` | `true` | Lobby terbuka saat game dibuat. |
| `enable_translations` | `ENABLE_TRANSLATIONS` | `false` | Terjemahan multi-bahasa default. |
| `default_gamemode` | `DEFAULT_GAMEMODE` | `fast` | Mode default (`classic`/`fast`/`wild`). |
| `waiting_time` | `WAITING_TIME` | `120` | Detik menunggu sebelum game dimulai. |
| `min_players` | `MIN_PLAYERS` | `2` | Pemain minimum untuk mulai. |

`config.json` berisi token rahasia dan **tidak** masuk git. Untuk deployment,
disarankan lewat environment variable.

## BotFather

Wajib diatur agar inline query berfungsi:

- `/setinline`
- `/setinlinefeedback`
- `/setcommands` — tempel isi [`commandlist.txt`](./commandlist.txt)

## Docker

```sh
cp .env.example .env
# isi TOKEN di .env
docker compose up -d --build
```

Atau tanpa Compose:

```sh
docker build -t uno-telegram-bot .
docker run --rm \
  -e TOKEN="<token>" \
  -v "$PWD/data:/app/data" \
  uno-telegram-bot
```

Data (database SQLite) disimpan di `./data` (`UNO_DB=/app/data/uno.sqlite3`).

## Daftar perintah

Lihat [`commandlist.txt`](./commandlist.txt). Perintah utama:
`/new`, `/join`, `/start`, `/leave`, `/help`, `/modes`, `/settings`, `/stats`.

## Berkontribusi

Kontribusi terbuka. Buka issue atau pull request.
Kredit kontributor asli ada di [`AUTHORS.md`](./AUTHORS.md) dan
[`TRANSLATORS.md`](./TRANSLATORS.md).
