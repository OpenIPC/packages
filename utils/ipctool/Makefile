#
# Copyright (C) 2013-2021 OpenIPC.org
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=ipctool
PKG_VERSION:=master
PKG_RELEASE:=latest
PKG_MAINTAINER:=Dmitry Ilyin <dima@doty.ru>

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/OpenIPC/ipctool.git
PKG_SOURCE_VERSION:=3c21f3c914b5f55fee9243a517f22b47ee3eeb24
#PKG_SOURCE_VERSION:=360ba07038af31d3f9c64fee44d88086c92e6676
#PKG_SOURCE_VERSION:=04b2eec1f6d2cbb053548257836e6a7bbebf9d93
#PKG_SOURCE_VERSION:=84b48c5035795de5233b354e843d30f58a1e8bc4
#PKG_SOURCE_VERSION:=7e523a84b054a122245039b7b32e67bf0995ba8f

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/$(PKG_NAME)
	SECTION:=openipc
	CATEGORY:=OpenIPC
	SUBMENU:=Utils
	TITLE:=New util for get info from IPCamera SoCs
	MAINTAINER:=Dmitry Ilyin <dima@doty.ru>
	DEPENDS:=@(TARGET_hi35xx)
endef

define Package/$(PKG_NAME)/description
    New util for get info from IPCamera (Hisi) SoCs
endef

CMAKE_OPTIONS += -DBUILD_SHARED_LIBS=ON -DCMAKE_BUILD_TYPE=Release -DSKIP_VERSION=ON

define Build/Prepare
	(cd $(PKG_BUILD_DIR) && tar --strip-components 1 -xvzf $(DL_DIR)/$(PKG_SOURCE))
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/ipcinfo $(1)/usr/bin/

endef

$(eval $(call BuildPackage,$(PKG_NAME)))
