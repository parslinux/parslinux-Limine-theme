#!/usr/bin/env bash
# ==============================================================================
#  ParsLinux Limine Teması — Paketleme Aracı (package.sh)
#  Telif Hakkı (C) 2026 ParsLinux Geliştirici Ekibi <dev@parslinux.org>
# ==============================================================================

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

echo -e "${CYAN}${BOLD}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║       📦 ParsLinux Limine Teması — Paketleme Aracı            ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

PKG_NAME="parslinux-limine-theme"
VERSION=$(head -n 1 debian/changelog 2>/dev/null | awk -F '[()]' '{print $2}')
[ -z "$VERSION" ] && VERSION="1.0.0"
ARCH="all"
OUTPUT_DIR="${SCRIPT_DIR}/build"

echo -e "${BOLD}Paket Adı    :${NC} ${CYAN}${PKG_NAME}${NC}"
echo -e "${BOLD}Sürüm        :${NC} ${CYAN}${VERSION}${NC}"
echo -e "${BOLD}Mimari       :${NC} ${CYAN}${ARCH}${NC}"
echo -e "${BOLD}Çıktı Dizini :${NC} ${CYAN}${OUTPUT_DIR}${NC}\n"

rm -rf "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}"

# 1. Debian Paketi Oluşturma
echo -e "${BOLD}[1/2] Debian (.deb) Paketi Oluşturuluyor...${NC}"

if command -v dpkg-buildpackage &>/dev/null; then
    echo -e "  ${CYAN}dpkg-buildpackage ile tam Debian inşası başlatılıyor...${NC}"
    dpkg-buildpackage -us -uc -b
    mv ../${PKG_NAME}_* "${OUTPUT_DIR}/" 2>/dev/null || true
    echo -e "  ${GREEN}✓${NC} dpkg-buildpackage ile paket inşa edildi."
else
    # Evrensel deb oluşturma (dpkg-deb veya ar+tar ile her sistemde çalışır)
    STAGE_DIR="${OUTPUT_DIR}/${PKG_NAME}_${VERSION}_${ARCH}"
    mkdir -p "${STAGE_DIR}/DEBIAN"
    mkdir -p "${STAGE_DIR}/usr/share/limine/themes"
    mkdir -p "${STAGE_DIR}/boot/limine/themes"

    # Tema dosyalarını kopyala
    cp -r parslinux "${STAGE_DIR}/usr/share/limine/themes/"
    cp -r parslinux "${STAGE_DIR}/boot/limine/themes/"

    # Bakımcı betiklerini hazırla
    cp debian/postinst "${STAGE_DIR}/DEBIAN/postinst"
    cp debian/postrm "${STAGE_DIR}/DEBIAN/postrm"
    chmod 755 "${STAGE_DIR}/DEBIAN/postinst" "${STAGE_DIR}/DEBIAN/postrm"

    # Control dosyasını hazırla
    cat <<EOF > "${STAGE_DIR}/DEBIAN/control"
Package: ${PKG_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Maintainer: ParsLinux Dev Team <dev@parslinux.org>
Suggests: limine
Provides: limine-theme
Description: ParsLinux Limine Theme
 A modern, sleek and elegant Limine bootloader theme featuring the
 ParsLinux Anatolian leopard branding, high-contrast cyber-dark aesthetic,
 custom terminal color palette, and high-definition wallpaper.
EOF

    DEB_FILE="${OUTPUT_DIR}/${PKG_NAME}_${VERSION}_${ARCH}.deb"

    if command -v dpkg-deb &>/dev/null; then
        echo -e "  ${CYAN}dpkg-deb aracı ile paketleniyor...${NC}"
        dpkg-deb --build "${STAGE_DIR}" "${DEB_FILE}" >/dev/null
    elif command -v ar &>/dev/null && command -v tar &>/dev/null; then
        echo -e "  ${CYAN}Sistem 'ar' ve 'tar' araçları ile evrensel .deb derleniyor...${NC}"
        WORK_TEMP=$(mktemp -d)
        echo "2.0" > "${WORK_TEMP}/debian-binary"

        # control.tar.gz
        (cd "${STAGE_DIR}/DEBIAN" && tar --owner=root:0 --group=root:0 -czf "${WORK_TEMP}/control.tar.gz" .)

        # data.tar.gz
        (cd "${STAGE_DIR}" && tar --exclude='./DEBIAN' --owner=root:0 --group=root:0 -czf "${WORK_TEMP}/data.tar.gz" ./usr ./boot)

        # ar ile .deb birleştir
        (cd "${WORK_TEMP}" && ar rcs "${DEB_FILE}" debian-binary control.tar.gz data.tar.gz)
        rm -rf "${WORK_TEMP}"
    fi

    rm -rf "${STAGE_DIR}"
    echo -e "  ${GREEN}✓${NC} Debian paketi oluşturuldu: $(basename "${DEB_FILE}")"
fi

# 2. Bağımsız Kaynak / Yayın Arşivi Oluşturma (.tar.gz)
echo -e "\n${BOLD}[2/2] Evrensel Kaynak / Dağıtım Arşivi (.tar.gz) Oluşturuluyor...${NC}"
TAR_NAME="${PKG_NAME}-${VERSION}.tar.gz"
tar --exclude='./build' --exclude='./.git' -czf "${OUTPUT_DIR}/${TAR_NAME}" \
    parslinux install.sh uninstall.sh run.sh package.sh Makefile README.md debian docs screenshots 2>/dev/null || \
tar --exclude='./build' --exclude='./.git' -czf "${OUTPUT_DIR}/${TAR_NAME}" \
    parslinux install.sh uninstall.sh run.sh package.sh Makefile README.md debian

echo -e "  ${GREEN}✓${NC} Evrensel arşiv oluşturuldu: ${TAR_NAME}"

# Çıktı Özeti
echo -e "\n${GREEN}${BOLD}╔══════════════════════════════════════════════════════════════╗"
echo "║             🎉 Paketleme İşlemi Başarıyla Tamamlandı!        ║"
echo "╚══════════════════════════════════════════════════════════════╝${NC}\n"

echo -e "${BOLD}Oluşturulan Paketler:${NC}"
ls -lh "${OUTPUT_DIR}"/*.deb "${OUTPUT_DIR}"/*.tar.gz 2>/dev/null | awk '{printf "  %s  %s (%s)\n", "'"${CYAN}"'•'"${NC}"'", $9, $5}'
echo ""
