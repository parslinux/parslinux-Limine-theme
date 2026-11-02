# 🏛️ ParsLinux Limine Teması Mimari Belgesi (`ARCHITECTURE.md`)

Bu belge, **ParsLinux Limine Teması** (`parslinux-limine-theme`) bileşenlerinin teknik mimarisini, dosya yapısını, Limine önyükleyici grafiksel terminal motorunun çalışma prensiplerini ve sistem entegrasyonunu açıklamaktadır.

---

## 1. Genel Bakış ve Limine Grafik Motoru

Limine önyükleyicisi, modern x86/x86_64/aarch64/riscv64 mimarilerini destekleyen yeni nesil bir önyükleyicidir. Limine:
- UEFI GOP (Graphics Output Protocol) ve BIOS VBE grafik modlarını yerel olarak destekler.
- PNG, BMP, JPEG ve QOI formatındaki arka plan duvar kağıtlarını doğrudan işler.
- `limine.conf` üzerinden merkezi ve yalın bir yapılandırma modeli sunar.
- Yarı saydam (`TTRRGGBB`) grafiksel terminal penceresi, özel renk paleti (`term_palette`), kenar boşlukları (`term_margin`) ve yumuşak gradyan çerçeveler (`term_margin_gradient`) sağlar.

---

## 2. Dizin ve Dosya Mimarisi

```
parslinux-limine-theme/
├── parslinux/                         # Limine Tema Çekirdeği
│   ├── background.png                 # 1920x1080 Full HD ana arka plan görseli
│   ├── theme.conf                     # Limine tema direktifleri şablonu
│   └── limine_sample.conf             # Canlı / üretim sistemleri için tam limine.conf örneği
│
├── debian/                            # Debian (.deb) Paketleme Kaynakları
│   ├── control                        # Paket bağımlılıkları ve üstveri tanımları
│   ├── rules                          # dh derleme kuralları
│   ├── changelog                      # Paket sürüm geçmişi
│   ├── copyright                      # GPL-3.0 lisans bildirimleri
│   ├── postinst                       # Kurulum sonrası tetikleyici
│   └── postrm                         # Kaldırma sonrası tetikleyici
│
├── docs/                              # Proje ve Mimari Belgeleri
│   ├── ARCHITECTURE.md                # Teknik mimari ve bileşen detayları
│   ├── LIMINE_THEME_GUIDE.md          # Tema özelleştirme ve Limine kılavuzu
│   ├── INSTALL.md                     # Kurulum yöntemleri rehberi
│   ├── CLI_REFERENCE.md               # run.sh ve betik parametreleri referansı
│   └── TESTING.md                     # Test ve doğrulama süreçleri
│
├── screenshots/                       # Ekran görüntüleri ve önizlemeler
│   └── preview.png                    # Görsel tema önizlemesi
│
├── install.sh                         # Tek tıkla otomatik sistem kurulum betiği
├── uninstall.sh                       # Güvenli sistem kaldırma betiği
├── package.sh                         # Debian paketi (.deb) ve .tar.gz üretici
├── run.sh                             # İnteraktif yönetim ve test arayüzü
├── Makefile                           # Sistem kurulum yönergeleri
└── README.md                          # Proje tanıtım ve dokümantasyon ana sayfası
```

---

## 3. Limine Tema Direktifleri ve Anlamları

| Direktif | Değer | Açıklama |
| :--- | :--- | :--- |
| `interface_resolution` | `1920x1080` | Menünün çalışacağı yerel çözünürlük |
| `interface_branding` | `ParsLinux GNU/Linux` | Menünün en üstünde yer alan başlık metni |
| `interface_branding_color` | `6` (Camgöbeği) | Başlık metninin renk indeksi |
| `wallpaper` | `boot():/.../background.png` | Arka plan görselinin önyükleme yolu |
| `wallpaper_style` | `stretched` | Görselin ekrana yayılma biçimi |
| `backdrop` | `080b12` | Koyu ParsLinux derin uzay lacivert/siyahı |
| `term_background` | `99080b12` | Yarı saydam koyu terminal arka planı |
| `term_foreground` | `ffffff` | Terminal metin rengi (Beyaz) |
| `term_foreground_bright`| `38bdf8` | Vurgulu öğe ve odak rengi (Açık Mavi/Camgöbeği) |
| `term_margin` | `96` | Menü kutusunun ekran kenarlarından mesafesi (px) |
| `term_margin_gradient` | `16` | Menü kutusunun etrafındaki yumuşak gradyan geçişi |
| `term_palette` | `8 renk dizilimi` | Standart ANSI renk paleti |
| `term_palette_bright` | `8 parlak renk` | Yüksek kontrastlı parlak ANSI renk paleti |

---

## 4. Sistem Entegrasyonu ve Dosya Yolları

- **/usr/share/limine/themes/parslinux/**: Sistem çapında dağıtılan değişmez kaynak tema dosyaları.
- **/boot/limine/themes/parslinux/**: Önyükleme esnasında Limine tarafından doğrudan erişilen hedef konum.
- **/boot/limine.conf** (veya ESP'deki `/boot/efi/limine.conf`): Temanın bildirildiği merkezi Limine yapılandırma dosyası.
