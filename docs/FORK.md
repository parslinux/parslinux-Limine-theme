# 🌿 Fork ve Menşe Belgesi (`FORK.md`)

Bu belge, **`parslinux-limine-theme`** projesinin kökenini, forklama amacını ve yapılan temel değişiklikleri belgeler.

---

## 1. Menşe ve Üst Kaynak (Upstream) Bilgileri

- **Kaynak Proje:** `pardus-bilge-limine-theme`
- **Kaynak Depo:** `https://github.com/pardus/pardus-bilge-limine-theme`
- **Lisans:** GNU General Public License v3.0 (GPL-3.0+)
- **Forklanma Tarihi:** 17 Ekim 2026

---

## 2. Fork Gerekçesi

1. **Görsel Modernizasyon**: Orijinal üst projede `background.png` 4x4 piksellik boş bir yer tutucuydu. ParsLinux için 1920x1080 yerel çözünürlükte, koyu lüks neon tasarımlı tam bir görsel tema üretilmiştir.
2. **ParsLinux Markalama**: ParsLinux'un resmi geometrik Anadolu Parsı amblemi ve renk paleti entegre edilmiştir.
3. **Zengin İkon Seti**: Üst depodaki tek ve geçici ikon yerine 16 farklı popüler işletim sistemi ve kurtarma ikonu eklenmiştir.
4. **Bağımsız Kurulum Araçları**: Yalnızca Debian paketine bağımlı kalmadan tüm dağıtımlarda çalışabilen `install.sh` ve `uninstall.sh` geliştirilmiştir.

---

## 3. Yapılan Başlıca Değişiklikler

| Dosya / Bileşen | Eski Durum (Upstream) | Yeni Durum (ParsLinux) |
| :--- | :--- | :--- |
| **Tema Klasörü** | `bilge/` | `parslinux/` |
| **Arka Plan** | 4x4 px düz renk | 1920x1080 Full HD ParsLinux amblemli neon görsel |
| **İkonlar** | 1 adet (2x2 px debian.png) | 16 adet 32x32 px modern OS ikonu |
| **Seçim Çubuğu** | Düz turkuaz çubuk | Oval neon indikatörlü mor-indigo kapsül |
| **Geri Sayım** | 15 px tam ekran geniş çubuk | 14 px ortalanmış zarif 480 px kapsül |
| **Paketleme** | `pardus-bilge-limine-theme` | `parslinux-limine-theme` 1.0.0 |
