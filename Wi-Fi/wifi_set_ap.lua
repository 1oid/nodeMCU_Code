wifi.setmode(wifi.STATIONAP)
cfg={}
cfg.ssid="nodemcu"
cfg.pwd="12345678"
cfg.auth=wifi.WPA2_PSK
wifi.ap.config(cfg)
print("create ap successfully")
