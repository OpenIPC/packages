# luci-app-ipcam2
### About:

Original package from [luci-app-config](https://github.com/ZigFisher/Glutinium/tree/master/luci-app-ipcam) by @ZigFisher. Modified to configure OpenIPC settings, view OpenIPC service information, etc.

This should be considered a beta extension!

### Download

Download the luci-app-ipcam2_2021-04-21-2.0_hi35xx.ipk release [here](https://github.com/randysbytes/luci-app-ipcam2/releases/download/v2.0/luci-app-ipcam2_2021-04-21-2.0_hi35xx.ipk) or clone this repository to your OpenIPC source code directory.

### Installation

First download the ipk package or build it from source and transfer it to the /tmp/ directoy of your OpenIPC camera using scp.

`# scp luci-app-ipcam2_2021-04-21-2.0_hi35xx.ipk root@OpenIPC_CAMERAIP:/tmp/luci-app-ipcam2_2021-04-21-2.0_hi35xx.ipk`

If the package luci-app-ipcam is installed on OpenIPC, remove it by running this command on your camera.

`# opkg remove luci-app-ipcam`

Now run the opkg install process on your camera.

`# opkg install /tmp/luci-app-ipcam2_2021-04-21-2.0_hi35xx.ipk`

Now from your OpenIPC camera you can use the IPCam menu in luci.

### Configuration

Due to the default configuration having comments in it and the way the configuration is parsed in lua, some settings with the default /etc/majestic.yaml configuration may have comments in them or white space's, if you wish to get rid of this, it is suggested you restore the configuration on the Reset/Edit tab of the settings page, you will lose any configuration changes you have made to your majestic.yaml configuration and a "cleaned" configuration will be written.

If for some reason you need to remove this application and want to restore the the default majestic configuration yaml, run the following command.

`# cp /rom/etc/majestic.yaml /etc/majestic.yaml`

### Screenshots

**![IPCam Settings](https://github.com/randysbytes/luci-app-ipcam2/blob/main/docs/img/ipcam2_settings.jpg)**

**![IPCam Services](https://github.com/randysbytes/luci-app-ipcam2/blob/main/docs/img/ipcam2_services.jpg)**

**![IPCam Mini SNMPd](https://github.com/randysbytes/luci-app-ipcam2/blob/main/docs/img/ipcam2_minisnmpd.jpg)**

**![IPCam SDCard Settings](https://github.com/randysbytes/luci-app-ipcam2/blob/main/docs/img/ipcam2_sdcardsettings.jpg)**

**![IPCam FileBrowser](https://github.com/randysbytes/luci-app-ipcam2/blob/main/docs/img/ipcam2_filebrowser.jpg)**
