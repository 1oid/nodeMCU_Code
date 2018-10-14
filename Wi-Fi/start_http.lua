dofile('httpServer.lua')
dofile('table_to_string.lua')

httpServer:listen(80)
TMR_WIFI = 4

httpServer:use('/', function(req, res)
        res:sendFile("index.html")
end)

httpServer:use('/config', function(req, res)
    if req.query.ssid ~= nil and req.query.pwd ~= nil then
        local cfg = {}
        cfg.ssid = req.query.ssid
        cfg.pwd = req.query.pwd
        wifi.sta.config(cfg)
        print("connect wifi ssid: "..cfg.ssid.." pwd: "..cfg.pwd)
        status = 'STA_CONNECTING'
        tmr.alarm(TMR_WIFI, 1000, tmr.ALARM_AUTO, function()
            if status ~= 'STA_CONNECTING' then
                res:type('application/json')
                res:send('{"status":"' .. status .. '"}')
                tmr.stop(TMR_WIFI)
            end
        end)
    end
end)

httpServer:use('/scanap', function(req, res)
    print("Scanning AP...")
    wifi.sta.getap(1, function(table)
        local aptable = {}
        for ssid,v in pairs(table) do
            local ssid, rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]*)")
            aptable[ssid] = channel
        end
        local retResult = table_to_string(aptable)
        res:send(retResult)
    end)
end)
