# 🎨 ParsLinux Limine Tema Geliştirme ve Özelleştirme Kılavuzu

Bu kılavuz, ParsLinux Limine önyükleyici temasını kendi tercihlerinize göre nasıl özelleştirebileceğinizi adım adım açıklamaktadır.

---

## 1. Arka Plan Görselini Değiştirme

Tema varsayılan olarak `parslinux/background.png` dosyasını kullanır (1920x1080 çözünürlüğünde).
Kendi görselinizi kullanmak isterseniz:
1. Görselinizi 1920x1080 veya 4K (3840x2160) çözünürlüğünde PNG veya JPEG olarak kaydedin.
2. Görseli `/boot/limine/themes/parslinux/background.png` konumuna kopyalayın.
3. `wallpaper_style` ayarını tercihinize göre belirleyin:
   - `stretched`: Görseli tüm ekrana sündürerek kaplar (Önerilen).
   - `centered`: Görseli merkezler, kalan kısımlara `backdrop` rengini uygular.
   - `tiled`: Görseli desen gibi yineler.

---

## 2. Saydamlık ve Terminal Renklerini Ayarlama

Limine'de `term_background` değeri `TTRRGGBB` formatında 8 haneli onaltılık (hex) değer alır.
İlk 2 hane (`TT`) saydamlık düzeyini belirler:
- `00` : Tamamen saydam (yalnızca arka plan görseli görünür)
- `40` : %25 opaklık
- `80` : %50 opaklık
- `99` : Yaklaşık %60 opaklık (ParsLinux varsayılanı)
- `CC` : %80 opaklık (daha koyu okunabilirlik)
- `FF` : Tamamen opak / mat siyah

Örnek:
```conf
term_background: 80080b12   # %50 yarı saydam derin uzay koyusu
term_foreground: ffffff     # Beyaz metin
term_foreground_bright: 38bdf8 # Neon camgöbeği vurgu
```

---

## 3. Menü Boyutunu ve Kenar Boşluklarını Ayarlama

Menü kutusunun ekrandaki büyüklüğünü `term_margin` direktifi ile piksel cinsinden ayarlayabilirsiniz:
- Küçük ekranlar / dizüstü bilgisayarlar: `term_margin: 48`
- Standart Full HD (1080p): `term_margin: 96` (Varsayılan)
- 2K / 4K geniş monitörler: `term_margin: 160`

Menü kenarlarındaki yumuşak geçiş için:
```conf
term_margin_gradient: 16    # 16 piksellik gradyan kenarlık
```

---

## 4. Özel CP437 Yazı Tipi Kullanma

Limine, 256 karakterlik Code Page 437 bitmap yazı tiplerini destekler.
Örnek bir 8x16 yazı tipi eklemek için:
```conf
term_font: boot():/limine/themes/parslinux/parslinux.f16
term_font_size: 8x16
term_font_scale: 1x1
```
HiDPI (4K) ekranlarda yazı boyutunu iki katına çıkarmak için `term_font_scale: 2x2` kullanabilirsiniz.
