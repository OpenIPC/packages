module("luci.controller.admin.snmpd", package.seeall)

function index()
	entry({"admin", "ipcam", "mini_snmpd"}, cbi("admin_ipcam/mini_snmpd"), _("Mini SNMPd"))
end