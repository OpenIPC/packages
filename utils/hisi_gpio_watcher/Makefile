#
# Copyright (C) 2013-2021 OpenIPC.org
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=hisi_gpio_watcher
PKG_VERSION:=0.1
PKG_RELEASE:=latest
PKG_MAINTAINER:=Maxim Patrushev <hidden@shadow.org>

include $(INCLUDE_DIR)/package.mk

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=Utility for executing commands when changing GPIO statuses
	MAINTAINER:=Maxim Patrushev <hidden@shadow.org>
endef

define Package/$(PKG_NAME)/description
  Utility for executing commands when changing GPIO statuses
endef

define Build/Prepare
	$(INSTALL_DIR) $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -o $(PKG_BUILD_DIR)/$(PKG_NAME) $(PKG_BUILD_DIR)/hisi_gpio_watcher.c
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/bin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
