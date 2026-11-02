# 🛡️ Önyükleyici Bütünlüğü ve Veri Koruma Kılavuzu (`DATA_SAVING_GUIDE.md`)

Bu kılavuz, önyükleme yapılandırması sırasında olası sistem kilitlenmelerini önleme ve yedekten geri dönme yollarını açıklar.

---

## 1. Otomatik Yedekleme Mekanizması

`install.sh` betiği her çalıştığında `/etc/default/limine` dosyasının zaman damgalı kopyasını alır:
```bash
/etc/default/limine.bak.YYYYMMDDHHMMSS
```

## 2. Geri Alma (Rollback) Adımları

Herhangi bir grafik uyuşmazlığı nedeniyle Limine ekranı açılmazsa:
1. Bilgisayarı açarken `Shift` (BIOS) veya `Esc` (UEFI) tuşuna basarak Limine metin moduna girin.
2. Açılış parametresine `nomodeset` ekleyin.
3. Sistem açıldığında yedeği geri yükleyin:
   ```bash
   sudo cp /etc/default/limine.bak.* /etc/default/limine
   sudo update-limine
   ```
