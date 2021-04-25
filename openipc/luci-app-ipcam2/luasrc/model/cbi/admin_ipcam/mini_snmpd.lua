local fs = require "nixio.fs"
local sys = require "luci.sys"

m = Map("snmpd", translate("Mini_snmpd"),
	translate("Mini_snmpd offers a SNMP server. You can configure the settings for it here."))

s = m:section(TypedSection, "snmpd", "")
s.anonymous = true
s.addremove = false
s.reset = false

t = s:option(Flag, "enable", translate("Enable"),
	translate("Specifies if the SNMP server is enabled or disabled"))
t.enabled  = "1"
t.disabled = "0"
t.default  = t.enabled
t.rmempty  = false

l = s:option(Value, "location", translate("Location"),
	translate("Specifies the SNMP server location reply"))
l.default  = "World"

d = s:option(Value, "disk", translate("Disk"),
	translate("Specifies the location to store SNMP temporary files"))
d.default  = "/overlay,/tmp"


t = s:option(Value, "timeout", translate("Timeout"),
	translate("Specifies the timeout for SNMP queries to the server"))
t.default  = "1"

c = s:option(Value, "community", translate("Community"),
	translate("Specifies the SNMP server read/write community"))
c.default  = "public"

c2 = s:option(Value, "contact", translate("Contact"),
	translate("Specifies the SNMP server contact reply"))
c2.default  = "OpenIPC"

i = s:option(Value, "interface", translate("Interface"),
	translate("Specifies the SNMP server listening interface, eth0 by default"))
i.widget = "radio"
i.template  = "cbi/network_ifacelist"

return m