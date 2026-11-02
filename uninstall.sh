#!/usr/bin/env bash
# ==============================================================================
#  ParsLinux Limine Teması — Kaldırma Betiği (uninstall.sh)
#  Telif Hakkı (C) 2026 ParsLinux Geliştirici Ekibi <dev@parslinux.org>
# ==============================================================================

set -e

# Renk tanımları
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

THEME_NAME="parslinux"

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║       🐆 ParsLinux Limine Teması — Kaldırma Sihirbazı        ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}${BOLD}HATA:${NC} Bu betik root (yönetici) hakları ile çalıştırılmalıdır."
    echo -e "Lütfen şu komutla çalıştırın: ${CYAN}sudo $0${NC}\n"
    exit 1
fi

echo -e "${BOLD}[1/2] Tema dosyaları temizleniyor...${NC}"
rm -rf "/boot/limine/themes/${THEME_NAME}"
rm -rf "/boot/efi/themes/${THEME_NAME}"
rm -rf "/boot/efi/limine/themes/${THEME_NAME}"
rm -rf "/boot/EFI/limine/themes/${THEME_NAME}"
rm -rf "/usr/share/limine/themes/${THEME_NAME}"
echo -e "  ${GREEN}✓${NC} Sistemdeki ${THEME_NAME} tema klasörleri kaldırıldı."

echo -e "\n${BOLD}[2/2] Limine yapılandırma dosyaları temizleniyor...${NC}"
CANDIDATE_CONFIGS=(
    "/boot/limine.conf"
    "/boot/limine/limine.conf"
    "/boot/efi/limine.conf"
    "/boot/efi/limine/limine.conf"
    "/boot/efi/EFI/limine/limine.conf"
    "/boot/EFI/limine/limine.conf"
)

for cfg in "${CANDIDATE_CONFIGS[@]}"; do
    if [ -f "$cfg" ]; then
        if grep -q "BEGIN PARSLINUX LIMINE THEME" "$cfg"; then
            sed -i '/### BEGIN PARSLINUX LIMINE THEME ###/,/### END PARSLINUX LIMINE THEME ###/d' "$cfg"
            echo -e "  ${GREEN}✓${NC} Tema bloğu temizlendi: ${cfg}"
        fi
    fi
done

echo -e "\n${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════╗"
echo "║    ✓ ParsLinux Limine Teması Sistemden Başarıyla Kaldırıldı   ║"
echo "╚══════════════════════════════════════════════════════════════╝${NC}\n"
