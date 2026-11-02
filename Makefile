all: nomake

nomake:
	@echo "no make"

install:
	mkdir -p $(DESTDIR)/usr/share/limine/themes
	mkdir -p $(DESTDIR)/boot/limine/themes
	mkdir -p $(DESTDIR)/usr/sbin
	mkdir -p $(DESTDIR)/etc/default
	mkdir -p $(DESTDIR)/etc/kernel/postinst.d
	mkdir -p $(DESTDIR)/etc/kernel/postrm.d
	@cp -fr parslinux $(DESTDIR)/usr/share/limine/themes/
	@cp -fr parslinux $(DESTDIR)/boot/limine/themes/
	@install -m 755 bin/update-limine $(DESTDIR)/usr/sbin/update-limine
	@install -m 644 etc/default/limine $(DESTDIR)/etc/default/limine
	@install -m 755 etc/kernel/postinst.d/zz-update-limine $(DESTDIR)/etc/kernel/postinst.d/zz-update-limine
	@install -m 755 etc/kernel/postrm.d/zz-update-limine $(DESTDIR)/etc/kernel/postrm.d/zz-update-limine

uninstall:
	@rm -fr $(DESTDIR)/usr/share/limine/themes/parslinux
	@rm -fr $(DESTDIR)/boot/limine/themes/parslinux
	@rm -f $(DESTDIR)/usr/sbin/update-limine
	@rm -f $(DESTDIR)/etc/default/limine
	@rm -f $(DESTDIR)/etc/kernel/postinst.d/zz-update-limine
	@rm -f $(DESTDIR)/etc/kernel/postrm.d/zz-update-limine

.PHONY: install uninstall
