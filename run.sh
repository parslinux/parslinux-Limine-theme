#!/usr/bin/env bash
# ==============================================================================
#  ParsLinux Limine Teması — Yönetim, Test ve Önizleme Aracı (run.sh)
#  Telif Hakkı (C) 2026 ParsLinux Geliştirici Ekibi <dev@parslinux.org>
# ==============================================================================

set -e

# Renk tanımları
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_DIR="$SCRIPT_DIR/parslinux"

function print_banner() {
    echo -e "${CYAN}${BOLD}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║     🐆 ParsLinux Limine Teması — Yönetim ve Test Aracı       ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

function check_theme_integrity() {
    echo -e "\n${BOLD}[1] Tema Bütünlüğü ve Dosya Kontrolü Yapılıyor...${NC}\n"
    local errors=0

    # 1. Ana dosya kontrolleri
    echo -e "${BOLD}Temel Dosyalar ve Dizinler:${NC}"
    for f in "background.png" "theme.conf" "limine_sample.conf" "parslinux.f16" "icons" "logo"; do
        if [ -e "$THEME_DIR/$f" ]; then
            echo -e "  ${GREEN}✓${NC} $f $(ls -ld "$THEME_DIR/$f" | awk '{print "(" $5 ")"}')"
        else
            echo -e "  ${RED}✗ EKSİK:${NC} $f"
            errors=$((errors + 1))
        fi
    done

    # Araç ve Kanca Kontrolleri
    echo -e "\n${BOLD}Sistem Araçları ve Kancalar:${NC}"
    for tool in "bin/update-limine" "etc/default/limine" "etc/kernel/postinst.d/zz-update-limine" "etc/kernel/postrm.d/zz-update-limine"; do
        if [ -f "$SCRIPT_DIR/$tool" ]; then
            echo -e "  ${GREEN}✓${NC} $tool"
        else
            echo -e "  ${RED}✗ EKSİK:${NC} $tool"
            errors=$((errors + 1))
        fi
    done

    # 2. Arka plan çözünürlük kontrolü
    if command -v file &>/dev/null && [ -f "$THEME_DIR/background.png" ]; then
        echo -e "\n${BOLD}Görsel Özellikleri:${NC}"
        local img_info
        img_info=$(file "$THEME_DIR/background.png")
        echo -e "  ${CYAN}• background.png:${NC} $img_info"
    fi

    # 3. Sözdizimi kontrolü
    echo -e "\n${BOLD}Sözdizimi ve Direktif Doğrulaması:${NC}"
    for opt in "interface_resolution" "interface_branding" "wallpaper" "term_background" "term_foreground" "term_margin" "term_palette"; do
        if grep -q "^$opt:" "$THEME_DIR/theme.conf"; then
            echo -e "  ${GREEN}✓${NC} Direktif tanımlı: $opt"
        else
            echo -e "  ${RED}✗ EKSİK DİREKTİF:${NC} $opt"
            errors=$((errors + 1))
        fi
    done

    echo ""
    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}${BOLD}Tüm kontroller başarıyla tamamlandı. Tema ve araçlar kullanıma hazır!${NC}\n"
    else
        echo -e "${RED}${BOLD}Toplam $errors hata tespit edildi. Lütfen eksik dosyaları giderin.${NC}\n"
    fi
}

function show_preview() {
    echo -e "${CYAN}${BOLD}"
    cat << 'EOF'
┌──────────────────────────────────────────────────────────────────────────────┐
│                                                                              │
│                                   [ 🐆 ]                                     │
│                        PARSLINUX  GNU/LINUX  SİSTEMİ                         │
│                                                                              │
│   ┌──────────────────────────────────────────────────────────────────────┐   │
│   │                                                                      │   │
│   │  > 1. ParsLinux GNU/Linux (Varsayılan Çekirdek)                      │   │
│   │    2. ParsLinux GNU/Linux (Kurtarma / Onarım Kipi)                   │   │
│   │    3. Windows Boot Manager                                           │   │
│   │    4. UEFI Donanım Yazılımı Ayarları                                 │   │
│   │                                                                      │   │
│   └──────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│      Seçili: ParsLinux GNU/Linux (Varsayılan Çekirdek)                       │
│      [ ↑ / ↓ ] Seç  •  [ Enter ] Başlat  •  [ E ] Düzenle                    │
│      Otomatik başlatmaya kalan süre: 5 saniye                                │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘
EOF
    echo -e "${NC}"
}

function run_qemu_test() {
    echo -e "\n${BOLD}[QEMU Canlı Önyükleme Testi Başlatılıyor...]${NC}\n"
    if ! command -v qemu-system-x86_64 &>/dev/null; then
        echo -e "${RED}HATA:${NC} 'qemu-system-x86_64' sistemde bulunamadı."
        return
    fi
    if ! command -v xorriso &>/dev/null; then
        echo -e "${RED}HATA:${NC} 'xorriso' sistemde bulunamadı."
        return
    fi

    local iso_file="${SCRIPT_DIR}/build/limine-test.iso"
    echo -e "  ${CYAN}[1/2] Test ISO imajı hazırlanıyor...${NC}"

    local test_dir
    test_dir=$(mktemp -d)
    local iso_root="${test_dir}/iso_root"
    mkdir -p "${iso_root}/limine/themes/parslinux" "${iso_root}/EFI/BOOT"

    cp "${SCRIPT_DIR}/parslinux/background.png" "${iso_root}/limine/themes/parslinux/"
    cp "${SCRIPT_DIR}/parslinux/parslinux.f16" "${iso_root}/limine/themes/parslinux/"
    [ -f /usr/share/limine/limine-bios-cd.bin ] && cp /usr/share/limine/limine-bios-cd.bin "${iso_root}/limine/"
    [ -f /usr/share/limine/limine-bios.sys ] && cp /usr/share/limine/limine-bios.sys "${iso_root}/limine/"
    [ -f /usr/share/limine/limine-uefi-cd.bin ] && cp /usr/share/limine/limine-uefi-cd.bin "${iso_root}/limine/"
    [ -f /usr/share/limine/BOOTX64.EFI ] && cp /usr/share/limine/BOOTX64.EFI "${iso_root}/EFI/BOOT/"

    cat << 'EOF' > "${iso_root}/limine.conf"
timeout: 10
default_entry: 1
interface_resolution: 1920x1080
interface_branding: ParsLinux GNU/Linux (QEMU Canlı Test)
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

term_font: boot():/limine/themes/parslinux/parslinux.f16
term_font_size: 8x16
term_font_scale: 1x1

/ParsLinux GNU/Linux 6.1 (Canlı Test)
    comment: ParsLinux Limine Teması Test Menüsü
    protocol: efi

/ParsLinux Kurtarma Kipi
    comment: Tek Kullanıcı Kurtarma Kipi
    protocol: efi

/UEFI Donanım Ayarları
    comment: Anakart BIOS / UEFI Arayüzü
    protocol: efi
EOF

    mkdir -p "${SCRIPT_DIR}/build"
    xorriso -as mkisofs -b limine/limine-bios-cd.bin \
            -no-emul-boot -boot-load-size 4 -boot-info-table \
            --efi-boot limine/limine-uefi-cd.bin \
            -efi-boot-part --efi-boot-image --protective-msdos-label \
            "${iso_root}" -o "${iso_file}" >/dev/null 2>&1

    if command -v limine &>/dev/null; then
        limine bios-install "${iso_file}" >/dev/null 2>&1 || true
    fi
    rm -rf "${test_dir}"
    echo -e "  ${GREEN}✓${NC} Test ISO oluşturuldu: ${iso_file} ($(ls -lh "${iso_file}" | awk '{print $5}'))"

    echo -e "\n  ${CYAN}[2/2] QEMU Sanal Makinesi Başlatılıyor...${NC}"
    echo -e "  ${YELLOW}Bilgi:${NC} QEMU penceresini kapatmak için pencereyi kapatın veya 'Ctrl+Alt+G' kullanın.\n"
    
    local qemu_opts=(-cdrom "${iso_file}" -m 1024 -vga std)
    [ -w /dev/kvm ] && qemu_opts+=(-enable-kvm)

    if [ -n "$DISPLAY" ] || [ -n "$WAYLAND_DISPLAY" ]; then
        qemu-system-x86_64 "${qemu_opts[@]}"
    else
        echo -e "  ${YELLOW}Grafik ekranı bulunamadı, konsol ekran görüntüsü testi yapılıyor...${NC}"
        qemu-system-x86_64 "${qemu_opts[@]}" -display none -monitor stdio
    fi
}

function show_menu() {
    print_banner
    echo -e "${BOLD}Lütfen bir işlem seçin:${NC}\n"
    echo -e "  ${CYAN}1)${NC} Tema ve Araç Bütünlüğü Kontrolü"
    echo -e "  ${CYAN}2)${NC} Limine Terminal ASCII Önizlemesini Göster"
    echo -e "  ${CYAN}3)${NC} Temayı Sisteme Kur (install.sh)"
    echo -e "  ${CYAN}4)${NC} Temayı Sistemden Kaldır (uninstall.sh)"
    echo -e "  ${CYAN}5)${NC} Debian Paketi ve Arşiv Oluştur (package.sh)"
    echo -e "  ${CYAN}6)${NC} update-limine ile Yapılandırmayı Yenile"
    echo -e "  ${CYAN}7)${NC} QEMU Canlı Önyükleme Testi (ISO + QEMU)"
    echo -e "  ${CYAN}0)${NC} Çıkış\n"
    read -rp "Seçiminiz [0-7]: " choice

    case "$choice" in
        1) check_theme_integrity ;;
        2) show_preview ;;
        3) sudo ./install.sh ;;
        4) sudo ./uninstall.sh ;;
        5) ./package.sh ;;
        6) sudo ./bin/update-limine ;;
        7) run_qemu_test ;;
        0) exit 0 ;;
        *) echo -e "${RED}Geçersiz seçim!${NC}" ;;
    esac
}

# Parametre desteği
case "$1" in
    --check|-c)
        print_banner
        check_theme_integrity
        ;;
    --preview|-p)
        print_banner
        show_preview
        ;;
    --install|-i)
        sudo ./install.sh
        ;;
    --uninstall|-u)
        sudo ./uninstall.sh
        ;;
    --package|-b)
        ./package.sh
        ;;
    --test|--qemu|-t)
        print_banner
        run_qemu_test
        ;;
    --help|-h)
        echo "Kullanım: $0 [--check | --preview | --install | --uninstall | --package | --test | --help]"
        ;;
    *)
        show_menu
        ;;
esac
