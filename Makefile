SHELL := /usr/bin/env bash
VERSION := $(shell cat pubspec.yaml | grep "^version: " | cut -c 10- | sed 's/+/\-/')
SHORT_VERSION := $(shell xx="$(VERSION)"; arrVersion=($${xx//-/ }); echo $${arrVersion[0]};)
BUILD_ROOT := ../build-package
BASE_NAME := deborah_$(SHORT_VERSION)
BUILD_DIR := $(BUILD_ROOT)/$(BASE_NAME)
BIN_TAR := $(BUILD_ROOT)/$(BASE_NAME).orig.tar
SRC_TAR := $(BUILD_ROOT)/$(BASE_NAME)-src.tar
FLUTTER := /opt/flutter/bin/flutter

version:
	@echo VERSION is $(VERSION)
	@echo SHORT_VERSION is $(SHORT_VERSION)
	@echo BUILD_ROOT is $(BUILD_ROOT)
	@echo type "make bin" to create binary package
	@echo type "make ppa" to upload to launchpad

distclean:
	$(FLUTTER) clean
	rm -rf $(BUILD_ROOT)/*

deborah: distclean
	$(FLUTTER) pub get
	$(FLUTTER) build linux --release

bin: deborah
	mkdir -p $(BUILD_DIR)
	cp -a build/linux/x64/release/bundle/* $(BUILD_DIR)
	cp -a assets/resources $(BUILD_DIR)
	tar -C $(BUILD_ROOT) -c -v -f $(BIN_TAR) $(BASE_NAME)
	xz -z $(BIN_TAR)

ppa: version
	cp $(BIN_TAR).xz /mnt/data/dev/debianpackages/deborah.deb/
	cd /mnt/data/dev/debianpackages/deborah.deb/deborah ; \
	dch -v $(VERSION) "New changelog message" ; \
	vi debian/changelog ; \
	for dist in focal jammy; do \
		sed -i "1 s/^\(.*\)) UNRELEASED;\(.*\)\$$/\1~xxx1.0) xxx;\2/g" debian/changelog ; \
		sed -i "1 s/~.*1\.0) .*;\(.*\)\$$/~$${dist}1.0) $$dist;\1/g" debian/changelog ; \
		dpkg-buildpackage -d -S -sa ; \
		dput ppa:yannick-mauray/deborah ../deborah_$(VERSION)~$${dist}1.0_source.changes ; \
	done

src:
	mkdir -p $(BUILD_ROOT)
	tar -C .. -c -v -f $(SRC_TAR) --exclude .git --transform 's/^deborah/$(BASE_NAME)/' deborah
	rm ${SRC_TAR}.xz
	xz -z $(SRC_TAR)
