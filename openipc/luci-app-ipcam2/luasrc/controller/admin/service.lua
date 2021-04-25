module("luci.controller.admin.service", package.seeall)

function index()
	entry({"admin", "ipcam", "service"}, template("admin_ipcam/service"), _("Service"), 1)
	entry({"admin", "ipcam", "service", "control"}, call("svc_control")).leaf = true
end

function svc_control() 
	if luci.http.formvalue("action") == "Restart" then
		luci.sys.call("killall -sigint majestic")
	    luci.sys.call("export SENSOR=`fw_printenv -n sensor`; majestic 2>&1 | logger -p daemon.info -t majestic &")
	end
	if luci.http.formvalue("action") == "Stop" then
		luci.sys.call("killall -sigint majestic")
	end
	if luci.http.formvalue("action") == "Start" then
		luci.sys.call("killall -sigint majestic")
	    luci.sys.call("export SENSOR=`fw_printenv -n sensor`; majestic 2>&1 | logger -p daemon.info -t majestic &")
	end
	luci.http.redirect(luci.dispatcher.build_url("admin/ipcam/service"))
end