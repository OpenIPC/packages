#
# Copyright (C) 2013-2021 OpenIPC.org
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ipctool
PKG_VERSION:=2021.03
PKG_RELEASE:=latest
PKG_MAINTAINER:=Dmitry Ilyin <dima@doty.ru>

include $(INCLUDE_DIR)/package.mk

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/OpenIPC/ipctool.git
#PKG_SOURCE_VERSION:=763a2749afadfd752a66eb073b8802bd6a5149d1

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/$(PKG_NAME)
	SECTION:=openipc
	CATEGORY:=OpenIPC
	SUBMENU:=Utils
	TITLE:=New util for get info from IPCamera SoC's
	MAINTAINER:=Dmitry Ilyin <dima@doty.ru>
	DEPENDS:=@(TARGET_hi35xx)
endef

define Package/$(PKG_NAME)/description
    New util for get info from IPCamera (Hisi) SoC's
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/bin/

endef

$(eval $(call BuildPackage,$(PKG_NAME)))
