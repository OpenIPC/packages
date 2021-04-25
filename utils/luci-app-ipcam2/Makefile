#
# Copyright (C) 2011-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-ipcam2
PKG_VERSION:=2021-04-21
PKG_RELEASE:=2.0
PKG_MAINTAINER:=Randy <randy@randysbytes.com>

include $(INCLUDE_DIR)/package.mk

PKG_LICENSE:=GPL-2.0
PKG_LICENSE_FILES:=LICENSE

define Package/$(PKG_NAME)
	SECTION:=openipc
	CATEGORY:=OpenIPC
	SUBMENU:=Other
	TITLE:=OpenIPC luci extension
	MAINTAINER:=Randy D. <randy@randysbytes.com>
	URL:=http://openipc.org
endef

define Package/$(PKG_NAME)/description
  Original concept from luci-app-config by Igor Zalatov (ZFT Lab.) <flyrouter@gmail.com>. Modified to configure OpenIPC settings and monitor services.
endef

define Build/Prepare
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci
	$(CP) ./luasrc/* $(1)/usr/lib/lua/luci/
	$(CP) ./htdocs/ $(1)/www/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
