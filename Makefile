.PHONY: help install

osdir = /usr/share/ganeti/os/nocloud
confdir = /etc/ganeti/nocloud
variants = $(shell cat os/variants.list)

help:
	@echo "Usage: make install [DESTDIR=...]"

install:
	install -m 755 -d ${DESTDIR}$(osdir)
	install -m 644 os/ganeti_api_version ${DESTDIR}$(osdir)/ganeti_api_version
	install -m 644 os/parameters.list ${DESTDIR}$(osdir)/parameters.list
	install -m 644 os/common.sh ${DESTDIR}$(osdir)/common.sh
	install -m 755 os/create ${DESTDIR}$(osdir)/create
	install -m 755 os/rename ${DESTDIR}$(osdir)/rename
	install -m 755 os/export ${DESTDIR}$(osdir)/export
	install -m 755 os/import ${DESTDIR}$(osdir)/import
	install -m 755 os/verify ${DESTDIR}$(osdir)/verify
	install -m 755 -d ${DESTDIR}$(confdir)
	install -m 755 -d ${DESTDIR}$(confdir)/user-data
	install -m 755 -d ${DESTDIR}$(confdir)/variants
	ln -snf $(confdir)/variants.list ${DESTDIR}$(osdir)/variants.list
	install -m 644 os/variants.list ${DESTDIR}$(confdir)/variants.list
	for v in $(variants); do \
	    install -m 644 os/variants/$${v}.conf ${DESTDIR}$(confdir)/variants/$${v}.conf; \
	done
