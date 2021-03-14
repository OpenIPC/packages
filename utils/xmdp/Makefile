#
# Copyright (C) 2013-2021 OpenIPC.org
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=xmdp
PKG_VERSION:=0.1
PKG_RELEASE:=latest
PKG_MAINTAINER:=Dmitry Ilyin <dima@doty.ru>

include $(INCLUDE_DIR)/package.mk

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

define Package/$(PKG_NAME)
	SECTION:=openipc
	CATEGORY:=OpenIPC
	SUBMENU:=Utils
	TITLE:=Utility for finding devices that support the NETIP protocol
	MAINTAINER:=Dmitry Ilyin <dima@doty.ru>
endef

define Package/$(PKG_NAME)/description
  Utility for finding devices that support the NETIP protocol
endef

define Build/Prepare
	$(INSTALL_DIR) $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Build/Compile
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) -O -g -D LINUX -std=c99 -Wall -Wpedantic -lm -o $(PKG_BUILD_DIR)/$(PKG_NAME) \
	$(PKG_BUILD_DIR)/xmdp.c $(PKG_BUILD_DIR)/netip.c $(PKG_BUILD_DIR)/utils.c $(PKG_BUILD_DIR)/cjson/cJSON.c
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/bin/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
