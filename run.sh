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
    echo -e "${BOLD}Temel Dosyalar:${NC}"
    for f in "background.png" "theme.conf" "limine_sample.conf" "parslinux.f16"; do
        if [ -f "$THEME_DIR/$f" ]; then
            echo -e "  ${GREEN}✓${NC} $f $(ls -lh "$THEME_DIR/$f" | awk '{print "(" $5 ")"}')"
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
    echo -e "\n${BOLD}[QEMU Test Ortamı Kontrol Ediliyor...]${NC}"
    if ! command -v qemu-system-x86_64 &>/dev/null; then
        echo -e "${YELLOW}UYARI:${NC} 'qemu-system-x86_64' bulunamadı. Canlı QEMU testi için qemu-system-x86 kurulmalıdır."
        return
    fi

    echo -e "${CYAN}QEMU test parametreleri hazırlandı. Canlı önizleme için ISO veya EFI Limine yapısı gerekiyor.${NC}"
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
    echo -e "  ${CYAN}7)${NC} QEMU Test Kontrolü"
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
    --help|-h)
        echo "Kullanım: $0 [--check | --preview | --install | --uninstall | --package | --help]"
        ;;
    *)
        show_menu
        ;;
esac
