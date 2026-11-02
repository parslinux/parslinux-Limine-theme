#!/usr/bin/env bash
# ==============================================================================
#  ParsLinux Limine Teması — Kurulum Sihirbazı (install.sh)
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
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEME_SRC="${SCRIPT_DIR}/parslinux"

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║      🐆 ParsLinux Limine Teması — Kurulum Sihirbazı          ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Root yetkisi kontrolü
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}${BOLD}HATA:${NC} Bu betik root (yönetici) hakları ile çalıştırılmalıdır."
    echo -e "Lütfen şu komutla çalıştırın: ${CYAN}sudo $0${NC}\n"
    exit 1
fi

if [ ! -d "${THEME_SRC}" ]; then
    echo -e "${RED}${BOLD}HATA:${NC} Tema kaynak klasörü (${THEME_SRC}) bulunamadı!\n"
    exit 1
fi

# 1. Limine yapılandırma dosyası ve dizin tespiti
CANDIDATE_CONFIGS=(
    "/boot/limine.conf"
    "/boot/limine/limine.conf"
    "/boot/efi/limine.conf"
    "/boot/efi/limine/limine.conf"
    "/boot/efi/EFI/limine/limine.conf"
    "/boot/EFI/limine/limine.conf"
)

LIMINE_CONF=""
for cfg in "${CANDIDATE_CONFIGS[@]}"; do
    if [ -f "$cfg" ]; then
        LIMINE_CONF="$cfg"
        break
    fi
done

if [ -z "$LIMINE_CONF" ]; then
    if [ -d "/boot/efi" ]; then
        LIMINE_CONF="/boot/efi/limine.conf"
    else
        LIMINE_CONF="/boot/limine.conf"
    fi
    echo -e "  ${YELLOW}BİLGİ:${NC} Mevcut limine.conf bulunamadı, ${CYAN}${LIMINE_CONF}${NC} konumunda oluşturulacak."
fi

CONF_DIR="$(dirname "${LIMINE_CONF}")"
TARGET_THEME_DIR="${CONF_DIR}/themes/${THEME_NAME}"
USR_SHARE_THEMES="/usr/share/limine/themes/${THEME_NAME}"

echo -e "${BOLD}[1/5] Tema dosyaları kopyalanıyor...${NC}"
mkdir -p "${CONF_DIR}/themes"
mkdir -p "/usr/share/limine/themes"

rm -rf "${TARGET_THEME_DIR}" "${USR_SHARE_THEMES}"
cp -r "${THEME_SRC}" "${TARGET_THEME_DIR}"
cp -r "${THEME_SRC}" "${USR_SHARE_THEMES}"

# /boot/limine/themes her zaman güncel tutulsun
if [ "${CONF_DIR}" != "/boot/limine" ]; then
    mkdir -p "/boot/limine/themes"
    rm -rf "/boot/limine/themes/${THEME_NAME}"
    cp -r "${THEME_SRC}" "/boot/limine/themes/${THEME_NAME}"
fi

echo -e "  ${GREEN}✓${NC} Önyükleyici tema dizini: ${TARGET_THEME_DIR}"
echo -e "  ${GREEN}✓${NC} Sistem paylaşılan dizini: ${USR_SHARE_THEMES}"

echo -e "\n${BOLD}[2/5] update-limine ve sistem kancaları kuruluyor...${NC}"
mkdir -p /usr/sbin /etc/default /etc/kernel/postinst.d /etc/kernel/postrm.d
if [ -f "${SCRIPT_DIR}/bin/update-limine" ]; then
    install -m 755 "${SCRIPT_DIR}/bin/update-limine" /usr/sbin/update-limine
    echo -e "  ${GREEN}✓${NC} /usr/sbin/update-limine kuruldu."
fi

if [ -f "${SCRIPT_DIR}/etc/default/limine" ] && [ ! -f /etc/default/limine ]; then
    install -m 644 "${SCRIPT_DIR}/etc/default/limine" /etc/default/limine
    echo -e "  ${GREEN}✓${NC} /etc/default/limine oluşturuldu."
fi

if [ -f "${SCRIPT_DIR}/etc/kernel/postinst.d/zz-update-limine" ]; then
    install -m 755 "${SCRIPT_DIR}/etc/kernel/postinst.d/zz-update-limine" /etc/kernel/postinst.d/zz-update-limine
    install -m 755 "${SCRIPT_DIR}/etc/kernel/postrm.d/zz-update-limine" /etc/kernel/postrm.d/zz-update-limine
    echo -e "  ${GREEN}✓${NC} Çekirdek güncelleme kancaları (/etc/kernel/*.d/zz-update-limine) kuruldu."
fi

echo -e "\n${BOLD}[3/5] Yapılandırma işleniyor...${NC}"
# Eğer sistemde çekirdekler varsa update-limine ile tam yapılandırma üret
if command -v update-limine &>/dev/null && [ -d "/boot" ] && ls /boot/vmlinuz-* &>/dev/null; then
    echo -e "  ${CYAN}update-limine çalıştırılıyor...${NC}"
    /usr/sbin/update-limine
else
    # Yedek al ve tema bloğunu en başa ekle
    if [ -f "${LIMINE_CONF}" ]; then
        BACKUP_FILE="${LIMINE_CONF}.bak.$(date +%Y%m%d%H%M%S)"
        cp "${LIMINE_CONF}" "${BACKUP_FILE}"
        echo -e "  ${GREEN}✓${NC} Yedek oluşturuldu: ${BACKUP_FILE}"
        
        sed -i '/### BEGIN PARSLINUX LIMINE THEME ###/,/### END PARSLINUX LIMINE THEME ###/d' "${LIMINE_CONF}"
        sed -i '/^interface_resolution:/d' "${LIMINE_CONF}"
        sed -i '/^interface_branding:/d' "${LIMINE_CONF}"
        sed -i '/^interface_branding_color:/d' "${LIMINE_CONF}"
        sed -i '/^interface_help_hidden:/d' "${LIMINE_CONF}"
        sed -i '/^wallpaper:/d' "${LIMINE_CONF}"
        sed -i '/^wallpaper_style:/d' "${LIMINE_CONF}"
        sed -i '/^backdrop:/d' "${LIMINE_CONF}"
        sed -i '/^term_background:/d' "${LIMINE_CONF}"
        sed -i '/^term_foreground:/d' "${LIMINE_CONF}"
        sed -i '/^term_margin:/d' "${LIMINE_CONF}"
        sed -i '/^term_palette:/d' "${LIMINE_CONF}"
    else
        touch "${LIMINE_CONF}"
    fi

    TEMP_BLOCK=$(mktemp)
    cat << 'EOF' > "${TEMP_BLOCK}"
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

term_font: boot():/limine/themes/parslinux/parslinux.f16
term_font_size: 8x16
term_font_scale: 1x1
### END PARSLINUX LIMINE THEME ###

EOF
    EXISTING_CONTENT=""
    [ -s "${LIMINE_CONF}" ] && EXISTING_CONTENT=$(cat "${LIMINE_CONF}")
    cat "${TEMP_BLOCK}" > "${LIMINE_CONF}"
    [ -n "${EXISTING_CONTENT}" ] && echo "${EXISTING_CONTENT}" >> "${LIMINE_CONF}"
    rm -f "${TEMP_BLOCK}"
    echo -e "  ${GREEN}✓${NC} Tema direktifleri ${LIMINE_CONF} dosyasına uygulandı."
fi

echo -e "\n${BOLD}[4/5] Limine Önyükleyici Varlığı Kontrol Ediliyor...${NC}"
if command -v limine &>/dev/null; then
    echo -e "  ${GREEN}✓${NC} Limine yardımcı ikili dosyası hazır ($(limine --version 2>/dev/null || echo 'hazır'))."
else
    echo -e "  ${CYAN}•${NC} Limine önyükleyici ikilisi sistem PATH'inde aranmadı, yapılandırma ve kancalar tamamlandı."
fi

echo -e "\n${BOLD}[5/5] Kurulum Doğrulaması:${NC}"
[ -f "${TARGET_THEME_DIR}/background.png" ] && echo -e "  ${GREEN}✓${NC} Tema arka planı: ${TARGET_THEME_DIR}/background.png"
[ -f "${TARGET_THEME_DIR}/parslinux.f16" ] && echo -e "  ${GREEN}✓${NC} Konsol yazı tipi: ${TARGET_THEME_DIR}/parslinux.f16"
[ -f "/usr/sbin/update-limine" ] && echo -e "  ${GREEN}✓${NC} Otomasyon aracı: /usr/sbin/update-limine"

echo -e "\n${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════╗"
echo "║         🎉 ParsLinux Limine Teması Başarıyla Kuruldu!        ║"
echo "╚══════════════════════════════════════════════════════════════╝${NC}"
echo -e "  ${CYAN}• Tema Konumu      :${NC} ${TARGET_THEME_DIR}"
echo -e "  ${CYAN}• Yapılandırma     :${NC} ${LIMINE_CONF}"
echo -e "  ${CYAN}• Güncelleme Aracı :${NC} update-limine"
echo -e "  ${CYAN}• Durum            :${NC} Bir sonraki açılışta veya çekirdek güncellemesinde otomatik aktiftir.\n"
