local fs  = require "nixio.fs"
local sys = require "luci.sys"
local util = require "luci.util"
local LIP = require 'luci.LIP'

tbl2 = LIP.load("/etc/majestic.yaml")

function ifval(val, match)
    if string.find(val, match) then
        return true
    else
        return false
    end
end

function cleanval(val)
    val = tostring(val)
    if val == nil then
        return ""
    else 
        return val:gsub('%W','')
    end
end

i = SimpleForm("settings", translate("Settings"),
    translate("This is the confguration settings for Majestic, the OpenIPC streaming server. Majestic will be restarted automatically when you save any changes to the configuration.<br><br><b>BETA NOTICE:</b>You may have to use the <a href=?tab.settings.system=cfg>Reset/Edit</a> tab to restore the 'default' (cleaned) configuration file to remove invalid charactors (comments, ; etc.)"))
i.reset = false

function i.handle(self, state, data)
    if luci.http.formvalue("cbid.settings.system.save_cfd_yaml_content") ~= "Save Changes" then
        if luci.http.formvalue("cbid.settings.system.restore_cfd_yaml_content") ~= "Restore" then
            if state == FORM_VALID then

                tbl2['system']['sensor_config'] = nil
                tbl2['system']['sensor_config_dir'] = nil
                tbl2['system']['log_level'] = data.log_level
                tbl2['system']['web_port'] = data.web_port
                tbl2['system']['update_channel'] = data.update_channel

                tbl2['isp']['max_pool_cnt'] = data.max_pool_cnt
                tbl2['isp']['thread_stack_size'] = data.thread_stack_size
                tbl2['isp']['blk_cnt'] = data.blk_cnt
                tbl2['isp']['align_width'] = data.align_width

                if(data.luminance_auto == "true") then
                    tbl2['image']['luminance'] = "auto"
                else
                    tbl2['image']['luminance'] = data.luminance
                end

                if(data.contrast_auto == "true") then
                    tbl2['image']['contrast'] = "auto"
                else
                    tbl2['image']['contrast'] = data.contrast
                end
                tbl2['image']['hue'] = data.hue
                tbl2['image']['saturation'] = data.saturation
                tbl2['image']['mirror'] = data.mirror
                tbl2['image']['flip'] = data.flip

                tbl2['night_mode']['ir_sensor_pin_invert'] = data.ir_sensor_pin_invert
                tbl2['night_mode']['check_interval_s'] = data.check_interval_s
                tbl2['night_mode']['ir_sensor_pin'] = data.ir_sensor_pin
                tbl2['night_mode']['enable'] = data.night_mode
                tbl2['night_mode']['pin_switch_delay_us'] = data.pin_switch_delay_us
                tbl2['night_mode']['ir_cut_pin2'] = data.ir_cut_pin2
                tbl2['night_mode']['ir_cut_pin1'] = data.ir_cut_pin1

                tbl2['motion_detect']['enable'] = data.motion_detect
                tbl2['motion_detect']['visualize'] = data.motion_visualize
                tbl2['motion_detect']['debug'] = data.motion_debug

                tbl2['osd']['font'] = data.osd_font
                tbl2['osd']['template'] = data.osd_template
                tbl2['osd']['enable'] = data.osd_enable
                tbl2['osd']['pos_y'] = data.osd_posy
                tbl2['osd']['pos_x'] = data.osd_posx

                tbl2['raw']['mode'] = data.raw

                tbl2['jpeg']['qfactor'] = data.jpeg_qfactor
                tbl2['jpeg']['height'] = data.jpeg_height
                tbl2['jpeg']['to_progressive'] = data.jpeg_progressive
                tbl2['jpeg']['enable'] = data.jpeg_enable
                tbl2['jpeg']['width'] = data.jpeg_width

                tbl2['video_0']['bitrate'] = data.video_0_bitrate
                tbl2['video_0']['codec'] = data.video_0_codec
                tbl2['video_0']['height'] = data.video_0_height
                tbl2['video_0']['fps'] = data.video_0_fps
                tbl2['video_0']['enable'] = data.video_0_enable
                tbl2['video_0']['width'] = data.video_0_width

                tbl2['video_1']['bitrate'] = data.video_1_bitrate
                tbl2['video_1']['codec'] = data.video_1_codec
                tbl2['video_1']['height'] = data.video_1_height
                tbl2['video_1']['fps'] = data.video_1_fps
                tbl2['video_1']['enable'] = data.video_1_enable
                tbl2['video_1']['width'] = data.video_1_width

                tbl2['rtsp']['enable'] = data.rtsp_enable
                tbl2['rtsp']['port'] = data.rtsp_port

                tbl2['mjpeg']['bitrate'] = data.mjpeg_bitrate
                tbl2['mjpeg']['height'] = data.mjpeg_height
                tbl2['mjpeg']['enable'] = data.mjpeg_enable
                tbl2['mjpeg']['fps'] = data.mjpeg_fps
                tbl2['mjpeg']['width'] = data.mjpeg_width

                tbl2['records']['enable'] = data.record_enable
                tbl2['records']['path'] = data.record_path
                tbl2['records']['max_usage'] = data.record_max

                tbl2['ipeye']['enable'] = data.ipeye_enable

                tbl2['netip']['password'] = data.netip_password
                tbl2['netip']['port'] = data.netip_port
                tbl2['netip']['user'] = data.netip_user
                tbl2['netip']['enable'] = data.netip_enable
                tbl2['netip']['snapshots'] = data.netip_snapshots

                tbl2['onvif']['enable'] = data.onvif_enable

                tbl2['http_post']['enable'] = data.http_post
                tbl2['http_post']['width'] = data.http_width
                tbl2['http_post']['host'] = data.http_host
                tbl2['http_post']['qfactor'] = data.http_qfactor
                tbl2['http_post']['password'] = data.http_password
                tbl2['http_post']['height'] = data.http_height
                tbl2['http_post']['url'] = data.http_url
                tbl2['http_post']['login'] = data.http_login
                tbl2['http_post']['interval'] = data.http_interval

                LIP.save("/etc/majestic.yaml", tbl2)

                sys.call("killall -sigint majestic")
                sys.call("export SENSOR=`fw_printenv -n sensor`; majestic 2>&1 | logger -p daemon.info -t majestic &")
                luci.http.redirect(luci.dispatcher.build_url("admin","ipcam","settings"))
            end 
        end
     end   
end

s2 = i:section(TypedSection, "_dummy", "IP Cam Configuration")
s2.addremove = false
s2.anonymous = true

s2:tab("system",  translate("System"))
s2:tab("isp",  translate("ISP"))
s2:tab("image", translate("Image"))
s2:tab("night", translate("Night"))
s2:tab("motion", translate("Motion"))
s2:tab("osd", translate("OSD"))
s2:tab("raw", translate("RAW"))
s2:tab("mjpeg", translate("MJPEG"))
s2:tab("jpeg", translate("JPG"))
s2:tab("video", translate("Video"))
s2:tab("service", translate("Service"))
s2:tab("cfg", translate("Reset/Edit"))

function s2.cfgsections()
    return { "system" }
end

log_level = s2:taboption("system", ListValue, "log_level", translate("Log level"))
log_level.default = cleanval(tbl2['system']['log_level'])
log_level:value("TRACE", "TRACE")
log_level:value("ERROR", "ERROR")
log_level:value("WARN", "WARN")
log_level:value("INFO", "INFO")
log_level:value("DEBUG", "DEBUG")

update_channel = s2:taboption("system", ListValue, "update_channel", translate("Update channel"))
update_channel.default = cleanval(tbl2['system']['update_channel'])
update_channel:value("stable", "stable")
update_channel:value("beta", "beta")
update_channel:value("testing", "testing")
update_channel:value("none", "none")

web_port = s2:taboption("system", Value, "web_port", translate("Web port"))
web_port.default = tbl2['system']['web_port']
web_port.datatype = "port"

align_width = s2:taboption("isp", Value, "align_width", translate("Align width"))
align_width.default = tbl2['isp']['align_width']

max_pool_cnt = s2:taboption("isp", Value, "max_pool_cnt", translate("Max pool count"))
max_pool_cnt.default = tbl2['isp']['max_pool_cnt']

blk_cnt = s2:taboption("isp", Value, "blk_cnt", translate("Block count"), translate("4 for hi3518E, 10 for hi3516C"))
blk_cnt.default = tbl2['isp']['blk_cnt']

thread_stack_size = s2:taboption("isp", Value, "thread_stack_size", translate("Thread stack size"), translate("in Kbytes"))
thread_stack_size.default = tbl2['isp']['thread_stack_size']

mirror = s2:taboption("image", ListValue, "mirror", translate("Mirror"), translate("Mirror image left to right"))
mirror.default = cleanval(tbl2['image']['mirror'])
mirror:value("true", "true")
mirror:value("false", "false")

flip = s2:taboption("image", ListValue, "flip", translate("Flip"), translate("Turn image upside down"))
flip.default = cleanval(tbl2['image']['flip'])
flip:value("true", "true")
flip:value("false", "false")

luminanceauto = s2:taboption("image", ListValue, "luminance_auto", translate("Luminance Auto"), translate("auto disables manual modes"))
if(cleanval(tbl2['image']['luminance']) == "auto") then
    luminanceauto.default = "true"
else
    luminanceauto.default = "false"
end
luminanceauto:value("true", "true")
luminanceauto:value("false", "false")

contrastauto = s2:taboption("image", ListValue, "contrast_auto", translate("Contrast Auto"), translate("auto disables manual modes"))
if(cleanval(tbl2['image']['contrast']) == "auto") then
    contrastauto.default = "true"
else
    contrastauto.default = "false"
end
contrastauto:value("true", "true")
contrastauto:value("false", "false")

luminance = s2:taboption("image", Value, "luminance", translate("Luminance"), translate("(1-99) Default (50)"))
if(cleanval(tbl2['image']['luminance']) == "auto") then
    luminance.default = "50"
else
    luminance.default = tbl2['image']['luminance']
end
luminance.template = "admin_ipcam/range"
luminance.max = "99"
luminance.min = "1"
luminance.size = "250"
luminance:depends("luminance_auto", "false")

contrast = s2:taboption("image", Value, "contrast", translate("Contrast"), translate("(1-99) Default (50)"))
if(cleanval(tbl2['image']['contrast']) == "auto") then
    contrast.default = "50"
else
    contrast.default = tbl2['image']['contrast']
end
contrast.template = "admin_ipcam/range"
contrast.max = "99"
contrast.min = "1"
contrast.size = "250"
contrast:depends("contrast_auto", "false")

hue = s2:taboption("image", Value, "hue", translate("Hue"), translate("(1-99) Default (50)"))
hue.default = tbl2['image']['hue']
hue.template = "admin_ipcam/range"
hue.max = "99"
hue.min = "1"
hue.size = "250"

saturation = s2:taboption("image", Value, "saturation", translate("Saturation"), translate("(1-99) Default (50)"))
saturation.default = tbl2['image']['saturation']
saturation.template = "admin_ipcam/range"
saturation.max = "100"
saturation.min = "0"
saturation.size = "250"

night_mode = s2:taboption("night", ListValue, "night_mode", translate("Enable"))
night_mode.default = cleanval(tbl2['night_mode']['enable'])
night_mode:value("true", "true")
night_mode:value("false", "false")

ir_sensor_pin_invert = s2:taboption("night", ListValue, "ir_sensor_pin_invert", translate("IR cut pin invert"))
ir_sensor_pin_invert.default = cleanval(tbl2['night_mode']['ir_sensor_pin_invert'])
ir_sensor_pin_invert:value("true", "true")
ir_sensor_pin_invert:value("false", "false")

check_interval_s = s2:taboption("night", Value, "check_interval_s", translate("Check interval seconds"), translate("Interval to check light sensor state in seconds"))
check_interval_s.default = tbl2['night_mode']['check_interval_s']

pin_switch_delay_us = s2:taboption("night", Value, "pin_switch_delay_us", translate("Pin Switch Delay Us"), translate("Switch delay in us on IRcut filter pins. WARNING! a very long delay can damage the IRcut filter!"))
pin_switch_delay_us.default = tbl2['night_mode']['pin_switch_delay_us']

ir_sensor_pin = s2:taboption("night", Value, "ir_sensor_pin", translate("IR Cut Sensor Pin"))
ir_sensor_pin.default = tbl2['night_mode']['ir_sensor_pin']

ir_cut_pin1 = s2:taboption("night", Value, "ir_cut_pin1", translate("IR Cut Pin 1"))
ir_cut_pin1.default = tbl2['night_mode']['ir_cut_pin1']

ir_cut_pin2 = s2:taboption("night", Value, "ir_cut_pin2", translate("IR Cut Pin 2"))
ir_cut_pin2.default = tbl2['night_mode']['ir_cut_pin2']

motion_detect = s2:taboption("motion", ListValue, "motion_detect", translate("Enable"))
motion_detect.default = cleanval(tbl2['motion_detect']['enable'])
motion_detect:value("true", "true")
motion_detect:value("false", "false")

motion_visualize = s2:taboption("motion", ListValue, "motion_visualize", translate("Visualize"))
motion_visualize.default = cleanval(tbl2['motion_detect']['visualize'])
motion_visualize:value("true", "true")
motion_visualize:value("false", "false")

motion_debug = s2:taboption("motion", ListValue, "motion_debug", translate("Debug"))
motion_debug.default = cleanval(tbl2['motion_detect']['debug'])
motion_debug:value("true", "true")
motion_debug:value("false", "false")

osd_enable = s2:taboption("osd", ListValue, "osd_enable", translate("Enable"))
osd_enable.default = cleanval(tbl2['osd']['enable'])
osd_enable:value("true", "true")
osd_enable:value("false", "false")

osd_font = s2:taboption("osd", Value, "osd_font", translate("Font"))
osd_font.default = tbl2['osd']['font']

osd_template = s2:taboption("osd", Value, "osd_template", translate("Text Template"), translate("%a %e %B %Y, %H:%M:%S (add %f to show milliseconds, takes more resources)"))
osd_template.default = tbl2['osd']['template']

osd_posy = s2:taboption("osd", Value, "osd_posy", translate("Pos Y"))
osd_posy.default =tbl2['osd']['pos_y']

osd_posx = s2:taboption("osd", Value, "osd_posx", translate("Pos X"))
osd_posx.default = tbl2['osd']['pos_x']

raw = s2:taboption("raw", ListValue, "raw", translate("Mode"))
raw.default = cleanval(tbl2['raw']['mode'])
raw:value("slow", "slow")
raw:value("fast", "fast")
raw:value("none", "none")

mjpeg_enable = s2:taboption("mjpeg", ListValue, "mjpeg_enable", translate("Enable"))
mjpeg_enable.default = cleanval(tbl2['mjpeg']['enable'])
mjpeg_enable:value("true", "true")
mjpeg_enable:value("false", "false")

mjpeg_bitrate = s2:taboption("mjpeg", Value, "mjpeg_bitrate", translate("Bitrate"))
mjpeg_bitrate.default = tbl2['mjpeg']['bitrate']

mjpeg_fps = s2:taboption("mjpeg", Value, "mjpeg_fps", translate("FPS"))
mjpeg_fps.default = tbl2['mjpeg']['fps']

mjpeg_height = s2:taboption("mjpeg", Value, "mjpeg_height", translate("Height"))
mjpeg_height.default = tbl2['mjpeg']['height']


mjpeg_width = s2:taboption("mjpeg", Value, "mjpeg_width", translate("Width"))
mjpeg_width.default = tbl2['mjpeg']['width']

jpeg_enable = s2:taboption("jpeg", ListValue, "jpeg_enable", translate("Enable"))
jpeg_enable.default = cleanval(tbl2['jpeg']['enable'])
jpeg_enable:value("true", "true")
jpeg_enable:value("false", "false")

jpeg_progressive = s2:taboption("jpeg", ListValue, "jpeg_progressive", translate("Progressive Mode"))
jpeg_progressive.default = cleanval(tbl2['jpeg']['to_progressive'])
jpeg_progressive:value("true", "true")
jpeg_progressive:value("false", "false")

jpeg_qfactor = s2:taboption("jpeg", Value, "jpeg_qfactor", translate("qfactor"))
jpeg_qfactor.default = tbl2['jpeg']['qfactor']

jpeg_height = s2:taboption("jpeg", Value, "jpeg_height", translate("Height"))
jpeg_height.default = tbl2['jpeg']['height']

jpeg_width = s2:taboption("jpeg", Value, "jpeg_width", translate("Width"))
jpeg_width.default = tbl2['jpeg']['width']

video_0_enable = s2:taboption("video", ListValue, "video_0_enable", translate("V0 Enable"))
video_0_enable.default = cleanval(tbl2['video_0']['enable'])
video_0_enable:value("true", "true")
video_0_enable:value("false", "false")

video_0_codec = s2:taboption("video", ListValue, "video_0_codec", translate("V0 Codec"))
video_0_codec.default = cleanval(tbl2['video_0']['codec'])
video_0_codec:value("h265", "h265")
video_0_codec:value("h264", "h264")

video_0_bitrate = s2:taboption("video", Value, "video_0_bitrate", translate("V0 Bitrate"))
video_0_bitrate.default = tbl2['video_0']['bitrate']

video_0_fps = s2:taboption("video", Value, "video_0_fps", translate("V0 FPS"))
video_0_fps.default = tbl2['video_0']['fps']

video_0_width = s2:taboption("video", Value, "video_0_width", translate("V0 Width"))
video_0_width.default = tbl2['video_0']['width']

video_0_height = s2:taboption("video", Value, "video_0_height", translate("V0 Height"))
video_0_height.default = tbl2['video_0']['height']

video_1_enable = s2:taboption("video", ListValue, "video_1_enable", translate("V1 Enable"))
video_1_enable.default = cleanval(tbl2['video_1']['enable'])
video_1_enable:value("true", "true")
video_1_enable:value("false", "false")

video_1_codec = s2:taboption("video", ListValue, "video_1_codec", translate("V1 Codec"))
video_1_codec.default = cleanval(tbl2['video_1']['codec'])
video_1_codec:value("h265", "h265")
video_1_codec:value("h264", "h264")

video_1_bitrate = s2:taboption("video", Value, "video_1_bitrate", translate("V1 Bitrate"))
video_1_bitrate.default = tbl2['video_1']['bitrate']

video_1_fps = s2:taboption("video", Value, "video_1_fps", translate("V1 FPS"))
video_1_fps.default = tbl2['video_1']['fps']

video_1_width = s2:taboption("video", Value, "video_1_width", translate("V1 Width"))
video_1_width.default = tbl2['video_1']['width']

video_1_height = s2:taboption("video", Value, "video_1_height", translate("V1 Height"))
video_1_height.default = tbl2['video_1']['height']

rtsp_label = s2:taboption("service", DummyValue, "rtsp_label", translate("RTSP Server"))
rtsp_label.rawhtml = true
rtsp_label.title = nil
rtsp_label.default = "<legend>RTSP Server</legend>"

rtsp_enable = s2:taboption("service", ListValue, "rtsp_enable", translate("Enable"))
rtsp_enable.default = cleanval(tbl2['rtsp']['enable'])
rtsp_enable:value("true", "true")
rtsp_enable:value("false", "false")

rtsp_port = s2:taboption("service", Value, "rtsp_port", translate("Port"))
rtsp_port.default = tbl2['rtsp']['port']

http_label = s2:taboption("service", DummyValue, "http_label", translate("HTTP Post Client"))
http_label.rawhtml = true
http_label.title = nil
http_label.default = "<legend>HTTP Post Client</legend>"

http_enable = s2:taboption("service", ListValue, "http_post", translate("Enable"))
http_enable.default = cleanval(tbl2['http_post']['enable'])
http_enable:value("true", "true")
http_enable:value("false", "false")

http_host = s2:taboption("service", Value, "http_host", translate("Host"))
http_host.default = tbl2['http_post']['host']

http_url = s2:taboption("service", Value, "http_url", translate("URL"))
http_url.default = tbl2['http_post']['url']

http_login = s2:taboption("service", Value, "http_login", translate("Login"))
http_login.default = tbl2['http_post']['login']

http_password = s2:taboption("service", Value, "http_password", translate("Password"))
http_password.default = tbl2['http_post']['password']

http_interval = s2:taboption("service", Value, "http_interval", translate("Interval Seconds"))
http_interval.default = tbl2['http_post']['interval']

http_qfactor = s2:taboption("service", Value, "http_qfactor", translate("Jpg qfactor"))
http_qfactor.default = tbl2['http_post']['qfactor']

http_height = s2:taboption("service", Value, "http_height", translate("Jpg Height"))
http_height.default = tbl2['http_post']['height']

http_width = s2:taboption("service", Value, "http_width", translate("Jpg Width"))
http_width.default = tbl2['http_post']['width']

record_label = s2:taboption("service", DummyValue, "record_label", translate("Recording"))
record_label.rawhtml = true
record_label.title = nil
record_label.default = "<legend>Recording</legend>"

record_enable = s2:taboption("service", ListValue, "record_enable", translate("Enable"))
record_enable.default = cleanval(tbl2['records']['enable'])
record_enable:value("true", "true")
record_enable:value("false", "false")

record_path = s2:taboption("service", Value, "record_path", translate("Path"))
record_path.default = tbl2['records']['path']

record_max = s2:taboption("service", Value, "record_max", translate("Max Usage %"))
record_max.default = tbl2['records']['max_usage']

netip_label = s2:taboption("service", DummyValue, "netip_label", translate("NetIP"))
netip_label.rawhtml = true
netip_label.title = nil
netip_label.default = "<legend>NetIP</legend>"

netip_enable = s2:taboption("service", ListValue, "netip_enable", translate("Enable"))
netip_enable.default = cleanval(tbl2['netip']['enable'])
netip_enable:value("true", "true")
netip_enable:value("false", "false")

netip_snapshots = s2:taboption("service", ListValue, "netip_snapshots", translate("Snapshots"))
netip_snapshots.default = cleanval(tbl2['netip']['snapshots'])
netip_snapshots:value("true", "true")
netip_snapshots:value("false", "false")

netip_portt = s2:taboption("service", Value, "netip_port", translate("Port"))
netip_portt.default = tbl2['netip']['port']

netip_login = s2:taboption("service", Value, "netip_user", translate("Login"))
netip_login.default = tbl2['netip']['user']

netip_password = s2:taboption("service", Value, "netip_password", translate("Password"))
netip_password.default = tbl2['netip']['password']

onvif_label = s2:taboption("service", DummyValue, "onvif_label", translate("Onvif"))
onvif_label.rawhtml = true
onvif_label.title = nil
onvif_label.default = "<legend>Onvif</legend>"

onvif_enable = s2:taboption("service", ListValue, "onvif_enable", translate("Enable"))
onvif_enable.default = cleanval(tbl2['onvif']['enable'])
onvif_enable:value("true", "true")
onvif_enable:value("false", "false")

ipeye_label = s2:taboption("service", DummyValue, "ipeye_label", translate("Ipeye"))
ipeye_label.rawhtml = true
ipeye_label.title = nil
ipeye_label.default = "<legend>Ipeye</legend>"

ipeye_enable = s2:taboption("service", ListValue, "ipeye_enable", translate("Enable"))
ipeye_enable.default = cleanval(tbl2['ipeye']['enable'])
ipeye_enable:value("true", "true")
ipeye_enable:value("false", "false")

cfg_yaml = s2:taboption("cfg", DummyValue, "cfd_yaml", "/etc/majestic.yaml")
cfg_yaml.rawhtml = true
cfg_yaml.title = nil
cfg_yaml.default = "<legend>Edit /etc/majestic.yaml</legend>"

cfd_yaml_content = s2:taboption("cfg", TextValue, "cfd_yaml_content")
cfd_yaml_content.rmempty = true
cfd_yaml_content.rows = 30

save_cfd_yaml_content =  s2:taboption("cfg", Button, "save_cfd_yaml_content", translate("Save Changes"), translate("Save configuration changes made to the unparsed /etc/majestic.yaml file."))

function cfd_yaml_content.cfgvalue()
    return fs.readfile("/etc/majestic.yaml") or ""
end

sreset = s2:taboption("cfg", DummyValue, "sreset", "Restore Configuration")
sreset.rawhtml = true
sreset.title = nil
sreset.default = "<legend>Restore Configuration</legend>"

restore_cfd_yaml_content =  s2:taboption("cfg", Button, "restore_cfd_yaml_content", translate("Restore"), translate("Remove all changes and restore default configuration"))
restore_cfd_yaml_content.inputstyle = "remove"

function save_cfd_yaml_content.write(self, section, data) 
    fs.writefile("/etc/majestic.yaml", luci.http.formvalue("cbid.settings.system.cfd_yaml_content"):gsub("\r\n", "\n"))
    sys.call("killall -sigint majestic")
    sys.call("export SENSOR=`fw_printenv -n sensor`; majestic 2>&1 | logger -p daemon.info -t majestic &")
    luci.http.redirect(luci.dispatcher.build_url("admin","ipcam","settings"))
end

function restore_cfd_yaml_content.write() 
    tbl2['raw']['mode'] =  "slow"
    tbl2['video_1']['bitrate'] = "4096"
    tbl2['video_1']['codec'] =  "h264"
    tbl2['video_1']['height'] = "576"
    tbl2['video_1']['fps'] = "15"
    tbl2['video_1']['enable'] =  "false"
    tbl2['video_1']['width'] = "704"
    tbl2['motion_detect']['enable'] =  "false"
    tbl2['motion_detect']['visualize'] =  "true"
    tbl2['motion_detect']['debug'] =  "true"
    tbl2['video_0']['bitrate'] = "4096"
    tbl2['video_0']['codec'] =  "h264"
    tbl2['video_0']['height'] = "1080"
    tbl2['video_0']['fps'] = "30"
    tbl2['video_0']['enable'] =  "true"
    tbl2['video_0']['width'] = "1920"
    tbl2['image']['hue'] = "50"
    tbl2['image']['saturation'] = "50"
    tbl2['image']['flip'] =  "false"
    tbl2['image']['luminance'] = "auto"
    tbl2['image']['mirror'] =  "false"
    tbl2['image']['contrast'] = "auto"
    tbl2['isp']['max_pool_cnt'] = "128"
    tbl2['isp']['thread_stack_size'] = "16"
    tbl2['isp']['blk_cnt'] = "4"
    tbl2['isp']['align_width'] = "64"
    tbl2['night_mode']['ir_sensor_pin_invert'] =  "false"
    tbl2['night_mode']['check_interval_s'] = "10"
    tbl2['night_mode']['ir_sensor_pin'] = "62"
    tbl2['night_mode']['enable'] =  "false"
    tbl2['night_mode']['pin_switch_delay_us'] = "150"
    tbl2['night_mode']['ir_cut_pin2'] = "2"
    tbl2['night_mode']['ir_cut_pin1'] = "1"
    tbl2['mjpeg']['bitrate'] = "1024"
    tbl2['mjpeg']['height'] = "1080"
    tbl2['mjpeg']['enable'] =  "true"
    tbl2['mjpeg']['fps'] = "30"
    tbl2['mjpeg']['width'] = "1920"
    tbl2['rtsp']['enable'] =  "true"
    tbl2['rtsp']['port'] = "554"
    tbl2['ipeye']['enable'] =  "false"
    tbl2['http_post']['enable'] =  "false"
    tbl2['http_post']['width'] = "640"
    tbl2['http_post']['host'] =  "host"
    tbl2['http_post']['qfactor'] = "95"
    tbl2['http_post']['password'] =  "password"
    tbl2['http_post']['height'] = "360"
    tbl2['http_post']['url'] =  "/~login/000000000000/%Y/%m/%d/%H.%M.jpg" 
    tbl2['http_post']['login'] =  "login"
    tbl2['http_post']['interval'] = "60"
    tbl2['records']['enable'] =  "false"
    tbl2['records']['path'] =  "/sdcard/%Y/%m/%d/%H.mp4"
    tbl2['records']['max_usage'] = "95"
    tbl2['onvif']['enable'] =  "false"
    tbl2['osd']['font'] =  "fonts.bin"
    tbl2['osd']['template'] =  "%a %e %B %Y, %H:%M:%S"
    tbl2['osd']['enable'] =  "false"
    tbl2['osd']['pos_y'] = "100"
    tbl2['osd']['pos_x'] = "100"
    tbl2['netip']['password'] = "6V0Y4HLF"
    tbl2['netip']['port'] = "34567"
    tbl2['netip']['user'] =  "admin"
    tbl2['netip']['enable'] =  "false"
    tbl2['netip']['snapshots'] =  "true"
    tbl2['jpeg']['qfactor'] = "99"
    tbl2['jpeg']['height'] = "1080"
    tbl2['jpeg']['to_progressive'] =  "false"
    tbl2['jpeg']['enable'] =  "true"
    tbl2['jpeg']['width'] = "1920"
    tbl2['system']['log_level'] =  "TRACE"
    tbl2['system']['web_port'] = "8888"
    tbl2['system']['update_channel'] =  "stable"
    LIP.save("/etc/majestic.yaml", tbl2)
    sys.call("killall -sigint majestic")
    sys.call("export SENSOR=`fw_printenv -n sensor`; majestic 2>&1 | logger -p daemon.info -t majestic &")
    luci.http.redirect(luci.dispatcher.build_url("admin","ipcam","settings"))
end

return i


