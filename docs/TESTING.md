# 🧪 Test ve Doğrulama Kılavuzu (`TESTING.md`)

Bu belge, `parslinux-limine-theme` bileşenlerinin test ve doğrulama aşamalarını açıklar.

---

## 1. Otomatik Bütünlük Kontrolü

Proje kök dizininde şu komutu çalıştırarak dosyaların bütünlüğünü ve sözdizimini test edebilirsiniz:

```bash
./run.sh --check
```

Bu kontrol şunları denetler:
1. `background.png` görselinin varlığı ve çözünürlüğü.
2. `theme.conf` ve `limine_sample.conf` dosyalarının varlığı.
3. Gerekli anahtar Limine direktiflerinin (`interface_resolution`, `wallpaper`, `term_background`, `term_palette` vb.) tanımlılığı.

---

## 2. Paket Derleme Testi

Debian paketinin hatasız derlenip derlenmediğini doğrulamak için:

```bash
./package.sh
```

Beklenen çıktı:
- `build/parslinux-limine-theme_1.0.0_all.deb`
- `build/parslinux-limine-theme-1.0.0.tar.gz`

Paket içeriğini incelemek için:
```bash
dpkg-deb -c build/parslinux-limine-theme_1.0.0_all.deb
```

---

## 3. QEMU veya Sanal Makine Testi

Limine önyükleyicisini sanal makinede test etmek için:
1. Bir test ISO'su veya disk imajı oluşturun.
2. Limine ve ParsLinux tema dosyalarını dahil edin.
3. `qemu-system-x86_64 -m 1024 -cdrom ...` veya UEFI modunda `ovmf` ile çalıştırın.
