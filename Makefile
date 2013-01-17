all: installer debian
.PHONY: all

VERSION := 1.0.0

SRC_DIR := src
PLUGIN := $(SRC)/suns_plugin.py
WIZARD := $(SRC)/suns_search.py
PLUGIN_PATH:= /usr/lib/python2.7/dist-packages/pmg_tk/startup
WIZARD_PATH:= /usr/lib/python2.7/dist-packages/pymol/wizard

BUILD_DIR := build

INSTALL_DIR := installer
INSTALLER := install_suns.py
INSTALL_HEADER := $(INSTALL_DIR)/install_suns_header.template
INSTALL_MIDDLE := $(INSTALL_DIR)/install_suns_middle.template
INSTALL_FOOTER := $(INSTALL_DIR)/install_suns_footer.template

installer: $(BUILD_DIR)/$(INSTALLER)
.PHONY: installer

$(BUILD_DIR)/$(INSTALLER):      \
    $(INSTALL_HEADER) \
    $(WIZARD)         \
    $(INSTALL_MIDDLE) \
    $(PLUGIN)         \
    $(INSTALL_FOOTER)
        mkdir -p $(BUILD_DIR)
	cat $(INSTALL_HEADER) \
	    $(WIZARD)         \
            $(INSTALL_MIDDLE) \
            $(PLUGIN)         \
	    $(INSTALL_FOOTER) \
	    >$(BUILD_DIR)/$(INSTALLER)

DEBDIR := debian
DEB_BUILD_DIR := $(DEBDIR)/build
DEB_NAME := pymol-suns-search
DEB_VERSION := 1
DEB_FULL := $(DEB_NAME)_$(VERSION)-$(DEB_VERSION)_all.deb

debian: $(BUILD_DIR)/$(DEB_FULL)
.PHONY: debian

$(BUILD_DIR)/$(DEB_FULL):
    mkdir -p $(BUILD_DIR)                   \
             $(DEB_BUILD_DIR)/DEBIAN        \
             $(DEB_BUILD_DIR)$(PLUGIN_PATH) \
             $(DEB_BUILD_DIR)$(WIZARD_PATH)
    cp $(PLUGIN) $(DEB_BUILD_DIR)$(PLUGIN_PATH)
    cp $(WIZARD) $(DEB_BUILD_DIR)$(WIZARD_PATH)
    cp $(DEB_DIR)/control $(DEB_BUILD_DIR)/DEBIAN/control
    dpkg-deb --build $(BUILD_DIR)/$(DEB_FULL)

.PHONY: clean
clean:
    rm -rf $(DEB_BUILD_DIR)
    rm -rf $(BUILD_DIR)
