# uno-telegram-bot

Telegram Bot untuk bermain kartu UNO di grup via inline query.
Bot berjalan sebagai [@uno_devnova_bot](https://t.me/uno_devnova_bot).

Update channel: [@dreamtorealitycreative](https://t.me/dreamtorealitycreative)

## Asal & Lisensi

Proyek ini adalah fork dari [`mau_mau_bot`](https://github.com/jh0ker/mau_mau_bot),
ditulis dan dikelola oleh [Jannes Höke](https://github.com/jh0ker) dan para kontributor.
Dirilis ulang di bawah lisensi **GNU Affero General Public License v3 (AGPLv3)**.

Modifikasi oleh [devnovaa-id](https://github.com/devnovaa-id). Lihat [`LICENSE`](./LICENSE).

## Menjalankan

### Cara cepat (setup otomatis)

```sh
git clone https://github.com/devnovaa-id/uno-telegram-bot.git
cd uno-telegram-bot
./setup.sh
```

Script akan: membuat virtualenv `.venv-uno`, install dependensi, menanyakan token,
dan meng-compile terjemahan. Setelah selesai:

```sh
source .venv-uno/bin/activate
python3 bot.py
```

### Manual

1. Dapatkan token bot dari [@BotFather](https://t.me/BotFather).
2. Salin `config.json.example` menjadi `config.json`, isi `token`.
   (atau set environment `TOKEN`).
3. Install dependensi:

```sh
python3 -m venv .venv-uno
source .venv-uno/bin/activate
pip install -r requirements.txt
```

4. Compile file terjemahan:

```sh
find . -maxdepth 2 -type d -name 'LC_MESSAGES' -exec bash -c 'msgfmt {}/unodev.po -o {}/unodev.mo' \;
```

5. Jalankan bot:

```sh
python3 bot.py
```

## BotFather

- `/setinline` dan `/setinlinefeedback`
- `/setcommands` dengan isi `commandlist.txt`

## Docker

```sh
docker build -t uno-telegram-bot .
docker run --rm -e TOKEN="<token>" -v ./data:/app/data uno-telegram-bot
```
