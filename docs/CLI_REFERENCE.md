# ⚙️ Komut Satırı ve Betik Referansı (`CLI_REFERENCE.md`)

`parslinux-limine-theme` deposundaki betiklerin ve parametrelerin detaylı referans listesidir.

---

## 1. `run.sh` — Yönetim ve Test Aracı

`run.sh` hem grafiksel konsol menüsü hem de komut satırı argümanları ile çalışabilir.

### Kullanım Biçimleri:

```bash
# Etkileşimli menüyü açar
./run.sh

# Tema dosyalarını ve sözdizimini kontrol eder
./run.sh --check
./run.sh -c

# Terminal önizleme şemasını görüntüler
./run.sh --preview
./run.sh -p

# Otomatik kurulumu başlatır (sudo gerektirir)
./run.sh --install
./run.sh -i

# Temayı sistemden kaldırır (sudo gerektirir)
./run.sh --uninstall
./run.sh -u

# Debian paketi ve kaynak tar.gz oluşturur
./run.sh --package
./run.sh -b

# Yardım iletisini görüntüler
./run.sh --help
./run.sh -h
```

---

## 2. `install.sh` — Kurulum Sihirbazı

```bash
sudo ./install.sh
```
- Sistemdeki Limine yapılandırma dosyasını otomatik olarak tespit eder.
- Zaman damgalı yedek alır.
- Tema dosyalarını ilgili yerlere kopyalar.
- Yapılandırmayı günceller.

---

## 3. `uninstall.sh` — Kaldırma Sihirbazı

```bash
sudo ./uninstall.sh
```
- Tema klasörlerini temizler.
- `limine.conf` içindeki ParsLinux tema direktiflerini ayıklar.

---

## 4. `package.sh` — Paketleyici

```bash
./package.sh
```
- `build/` dizini altında `.deb` ve `.tar.gz` paketlerini oluşturur.
