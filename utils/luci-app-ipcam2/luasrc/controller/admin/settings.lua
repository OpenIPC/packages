module("luci.controller.admin.settings", package.seeall)

function index()
	entry({"admin", "ipcam", "settings"}, cbi("admin_ipcam/settings"), _("Settings"))
end