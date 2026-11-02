# 📦 Flatpak ve Sandbox Kapsamı Değerlendirmesi (`FLATPAK_PACKAGING.md`)

Bu belge, bir Limine önyükleme temasının neden doğrudan bir Flatpak paketi olamayacağını ve olası GUI tema yöneticisi çözümlerini değerlendirir.

---

## 1. Mimari Sınırlar

- **Kök Dizin ve Önyükleyici Erişimi**: Limine temaları `/boot/limine/` ve `/etc/default/limine` dosyalarına doğrudan erişim ve `update-limine` çalıştırma yetkisi gerektirir.
- **Flatpak İzolasyonu**: Flatpak uygulamaları kullanıcı alanında korumalı bir sanal ortamda (sandbox) çalışır ve çekirdek seviyesindeki önyükleme yapılandırmalarına erişemez.

---

## 2. Olası Entegrasyon: "Pars Tema Yöneticisi" Flatpak'i

Gelecekte geliştirilebilecek bir grafiksel Limine tema seçici Flatpak uygulaması:
- Flatpak içinde çalışır.
- `org.freedesktop.Flatpak.SystemHelper` veya D-Bus/Polkit portali üzerinden yetki alarak temayı `/boot/limine/themes` altına kurabilir.
