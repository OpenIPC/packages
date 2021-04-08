#
# Copyright (C) 2013-2021 OpenIPC.org
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=majestic
PKG_VERSION:=master
PKG_RELEASE:=latest
PKG_MAINTAINER:=Dmitry Ilyin <dima@doty.ru>

include $(INCLUDE_DIR)/package.mk

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE_URL:=http://openipc.s3-eu-west-1.amazonaws.com

ifeq ($(CONFIG_TARGET_hi35xx_16cv100),y)
	PKG_SOURCE:=$(PKG_NAME).hi3516cv100.$(PKG_VERSION).tar.bz2
	OSDRV_VERSION:=1
endif
ifeq ($(CONFIG_TARGET_hi35xx_18av100),y)
	PKG_SOURCE:=$(PKG_NAME).hi3516cv100.$(PKG_VERSION).tar.bz2
	OSDRV_VERSION:=1
endif
ifeq ($(CONFIG_TARGET_hi35xx_18cv100),y)
	PKG_SOURCE:=$(PKG_NAME).hi3516cv100.$(PKG_VERSION).tar.bz2
	OSDRV_VERSION:=1
endif
ifeq ($(CONFIG_TARGET_hi35xx_18ev100),y)
	PKG_SOURCE:=$(PKG_NAME).hi3516cv100.$(PKG_VERSION).tar.bz2
	OSDRV_VERSION:=1
endif


ifeq ($(CONFIG_TARGET_hi35xx_16cv200),y)
	PKG_SOURCE:=$(PKG_NAME).hi3516cv200.$(PKG_VERSION).tar.bz2
	OSDRV_VERSION:=2
endif
ifeq ($(CONFIG_TARGET_hi35xx_18ev200),y)
	PKG_SOURCE:=$(PKG_NAME).hi3516cv200.$(PKG_VERSION).tar.bz2
	OSDRV_VERSION:=2
endif
ifeq ($(CONFIG_TARGET_hi35xx_18ev201),y)
	PKG_SOURCE:=$(PKG_NAME).hi3516cv200.$(PKG_VERSION).tar.bz2
	OSDRV_VERSION:=2
endif


ifeq ($(CONFIG_TARGET_hi35xx_16cv300),y)
	PKG_SOURCE:=$(PKG_NAME).hi3516cv300.$(PKG_VERSION).tar.bz2
	OSDRV_VERSION:=3
endif
ifeq ($(CONFIG_TARGET_hi35xx_16ev100),y)
	PKG_SOURCE:=$(PKG_NAME).hi3516cv300.$(PKG_VERSION).tar.bz2
	OSDRV_VERSION:=3
endif


ifeq ($(CONFIG_TARGET_hi35xx_16ev200),y)
	PKG_SOURCE:=$(PKG_NAME).hi3516ev300.$(PKG_VERSION).tar.bz2
	OSDRV_VERSION:=4
endif
ifeq ($(CONFIG_TARGET_hi35xx_16ev300),y)
	PKG_SOURCE:=$(PKG_NAME).hi3516ev300.$(PKG_VERSION).tar.bz2
	OSDRV_VERSION:=4
endif
ifeq ($(CONFIG_TARGET_hi35xx_18ev300),y)
	PKG_SOURCE:=$(PKG_NAME).hi3516ev300.$(PKG_VERSION).tar.bz2
	OSDRV_VERSION:=4
endif


PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

PKG_BUILD_DEPENDS:=libevent2 libjson-c lame-lib libpthread hisi-osdrv$(OSDRV_VERSION)-lib


define Package/$(PKG_NAME)
	SECTION:=openipc
	CATEGORY:=OpenIPC
	SUBMENU:=Utils
	TITLE:=Tiny but powerful IPC streaming software
	MAINTAINER:=Dmitry Ilyin <dima@doty.ru>
	DEPENDS:=@(TARGET_hi35xx) +libevent2 +libjson-c +lame-lib +libpthread +hisi-osdrv$(OSDRV_VERSION)-lib
endef

define Package/$(PKG_NAME)/description
    Tiny but powerful IPC streaming software
endef

define Build/Prepare
	(cd $(PKG_BUILD_DIR) && tar -xvjf $(DL_DIR)/$(PKG_SOURCE))
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/etc
	$(CP) $(PKG_BUILD_DIR)/$(PKG_NAME).yaml $(1)/etc/
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) $(PKG_BUILD_DIR)/$(PKG_NAME) $(1)/usr/bin/

endef

$(eval $(call BuildPackage,$(PKG_NAME)))
