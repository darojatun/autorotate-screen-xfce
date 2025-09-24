````markdown
# Autorotate Screen XFCE (dan Window Manager lain)

Script sederhana untuk **memutar layar (screen rotation) secara otomatis** berdasarkan sensor orientasi, sekaligus menyesuaikan **layar sentuh (touchscreen input)** agar tetap akurat.  
Cocok digunakan di **XFCE** maupun window manager lain yang tidak punya fitur autorotate bawaan.

---

## 📦 Dependensi

Pastikan paket berikut sudah terpasang di sistem Anda:

- [`iio-sensor-proxy`](https://github.com/hadess/iio-sensor-proxy) → membaca sensor orientasi
- `xrandr` → mengatur rotasi layar
- `xinput` → menyesuaikan input touchscreen
- `inotify-tools` → mendeteksi perubahan data sensor

Di Debian/Ubuntu dan turunannya bisa dipasang dengan:

```bash
sudo apt install iio-sensor-proxy x11-xserver-utils xinput inotify-tools
````

---

## ⚙️ Instalasi

1. Clone repo ini atau unduh file script:

   ```bash
   git clone https://github.com/darojatun/autorotate-screen-xfce.git
   cd autorotate-screen-xfce
   ```

2. Simpan script ke home directory:

   ```bash
   cp autorotate.sh ~/autorotate.sh
   chmod +x ~/autorotate.sh
   ```

---

## 🚀 Cara Menjalankan

### 1. Autostart via XFCE (Session & Startup)

Tambahkan `~/autorotate.sh` ke:

* **Settings Manager** → **Session and Startup** → **Application Autostart**

Sehingga script berjalan otomatis saat login.

### 2. Menjalankan via Systemd (opsional)

Contoh file service: `~/.config/systemd/user/autorotate.service`

```ini
[Unit]
Description=Auto rotate screen and touchscreen

[Service]
ExecStart=%h/autorotate.sh
Restart=always

[Install]
WantedBy=default.target
```

Aktifkan dengan:

```bash
systemctl --user enable --now autorotate.service
```

---

## 🖐️ Menentukan ID Touchscreen

Untuk menemukan ID touchscreen, jalankan:

```bash
xinput list
⎡ Virtual core pointer                          id=2    [master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
⎜   ↳ Elan Touchpad                             id=8    [slave  pointer  (2)]
⎜   ↳ SYTS7817:00 06CB:1A24                     id=9    [slave  pointer  (2)]
⎣ Virtual core keyboard                         id=3    [master keyboard (2)]
    ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
    ↳ Power Button                              id=6    [slave  keyboard (3)]
    ↳ Video Bus                                 id=7    [slave  keyboard (3)]
    ↳ acpd7219m98357 Headset Jack               id=10   [slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard              id=11   [slave  keyboard (3)]
```

> ⚠️ Perintah ini **tidak bisa dijalankan via SSH** karena butuh akses X server.

Lalu edit variabel `TOUCHSCREEN_ID` di dalam `autorotate.sh` sesuai dengan ID perangkat touchscreen Anda.

---

## 📝 Catatan

* Script ini dibuat untuk sistem dengan **sensor orientasi yang didukung `iio-sensor-proxy`**.
* Sudah diuji di XFCE, namun bisa digunakan di desktop environment lain atau window manager murni dengan syarat semua dependensi tersedia.

---

## 📜 Lisensi

[MIT](LICENSE)

---

💡 Kontribusi, perbaikan, dan saran sangat diterima 🙌

```
au ah elap. ini cuma catatanku saja siapa tau kapan-kapan perlu lagi. o iya ini kudapat dari nanya AI  bawaan brower Brave dengan memberi variable yang dibutuhkan seperti hasil dari perintah monitor-sensor jika layar dibolak balik

```
