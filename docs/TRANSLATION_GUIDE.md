# 🌍 Çeviri ve Yerelleştirme Kılavuzu (`TRANSLATION_GUIDE.md`)

Bu rehber, Limine teması üzerindeki yönlendirici metinlerin ve menü girdilerinin çoklu dil desteğine nasıl katkı sağlanacağını açıklar.

---

## 1. Limine Tema Metinleri

Limine arayüzündeki statik yönlendirme ipuçları `parslinux/background.png` üzerinde doğrudan işlenmiş olup Türkçe standart kılavuz sunar:
- `[ ↑ / ↓ ] Seçim Yap`
- `[ ENTER ] Başlat`
- `[ E ] Parametreleri Düzenle`
- `[ C ] Limine Komut Satırı`

---

## 2. Geri Sayım ve Sistem Etiketleri

`theme.txt` içerisindeki etiketler Limine2'nin yerel gettext değişkenlerini kullanır:
- `@TIMEOUT_NOTIFICATION_SHORT@`: Sistem diline göre "x saniye içinde başlatılıyor" metnini dinamik basar.
- `@KEYMAP_SHORT@`: Klavye düzeni kodunu görüntüler.

Limine'un sistem çevirilerine katkı sağlamak için `po/` dosyaları upstream GNU Limine projesi üzerinden yönetilir.
