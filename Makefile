all: nomake

nomake:
	@echo "no make"

install:
	mkdir -p $(DESTDIR)/usr/share/limine/themes
	mkdir -p $(DESTDIR)/boot/limine/themes
	@cp -fr parslinux $(DESTDIR)/usr/share/limine/themes/
	@cp -fr parslinux $(DESTDIR)/boot/limine/themes/

uninstall:
	@rm -fr $(DESTDIR)/usr/share/limine/themes/parslinux
	@rm -fr $(DESTDIR)/boot/limine/themes/parslinux

.PHONY: install uninstall
