# 🌐 Yerel Depoda Barındırma Kılavuzu (`SELF_HOSTING_GUIDE.md`)

Bu belge, `parslinux-limine-theme` paketinin kurumsal ağlarda veya yerel ParsLinux APT depolarında nasıl barındırılacağını açıklar.

---

## 1. Reprepro ile APT Deposu Oluşturma

```bash
# Gerekli araçları kurun
sudo apt install reprepro gnupg

# Depo dizini
mkdir -p /var/www/repo/conf
```

`conf/distributions` yapılandırması:
```ini
Origin: ParsLinux
Label: ParsLinux Repo
Codename: pars
Architectures: amd64 arm64 all
Components: main
Description: ParsLinux Official Software Repository
```

## 2. Paketi Depoya Ekleme

```bash
./package.sh
reprepro -b /var/www/repo includedeb pars build/parslinux-limine-theme_1.0.0_all.deb
```

## 3. İstemci Sistemlerde Kullanma

```bash
echo "deb [trusted=yes] http://repo.parslinux.org/ pars main" | sudo tee /etc/apt/sources.list.d/parslinux.list
sudo apt update
sudo apt install parslinux-limine-theme
```
