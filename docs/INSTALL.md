# 🚀 ParsLinux Limine Teması Kurulum Rehberi (`INSTALL.md`)

Bu belgede **ParsLinux Limine Teması**'nı sisteminize kurmanın farklı yolları anlatılmaktadır.

---

## Yöntem 1: Hızlı Kurulum Betiği (Önerilen)

En kolay ve güvenli kurulum yöntemi, projenin kök dizinindeki `install.sh` betiğini çalıştırmaktır:

```bash
cd parslinux-Limine-theme
sudo ./install.sh
```

Bu betik:
1. Mevcut `limine.conf` dosyasını otomatik olarak arar ve tespit eder.
2. Var olan yapılandırmanın zaman damgalı yedeğini (`limine.conf.bak.*`) alır.
3. Tema dosyalarını `/boot/limine/themes/parslinux` ve `/usr/share/limine/themes/parslinux` dizinlerine kopyalar.
4. `limine.conf` dosyasının başına tema direktiflerini temiz bir biçimde ekler.

---

## Yöntem 2: Debian Paketi (.deb) ile Kurulum

Eğer `.deb` paketi oluşturduysanız:

```bash
# Paketi derleyin:
./package.sh

# Paketi sisteme kurun:
sudo dpkg -i build/parslinux-limine-theme_1.0.0_all.deb
```

---

## Yöntem 3: Elle (Manuel) Kurulum

Tema dosyalarını doğrudan elle sisteminize yerleştirmek isterseniz:

1. Tema klasörünü kopyalayın:
   ```bash
   sudo mkdir -p /boot/limine/themes/
   sudo cp -r parslinux /boot/limine/themes/
   ```

2. `/boot/limine.conf` dosyanızı açın ve üst kısma şu bloğu ekleyin:
   ```conf
   ### BEGIN PARSLINUX LIMINE THEME ###
   interface_resolution: 1920x1080
   interface_branding: ParsLinux GNU/Linux
   interface_branding_color: 6
   interface_help_hidden: no

   wallpaper: boot():/limine/themes/parslinux/background.png
   wallpaper_style: stretched
   backdrop: 080b12

   term_background: 99080b12
   term_foreground: ffffff
   term_background_bright: 80161b26
   term_foreground_bright: 38bdf8
   term_margin: 96
   term_margin_gradient: 16

   term_palette: 080b12;ef4444;10b981;f59e0b;3b82f6;8b5cf6;06b6d4;cbd5e1
   term_palette_bright: 475569;f87171;34d399;fbbf24;60a5fa;a78bfa;22d3ee;ffffff
   ### END PARSLINUX LIMINE THEME ###
   ```

3. Dosyayı kaydedip kapatın. Bir sonraki yeniden başlatmada tema aktif olacaktır.
