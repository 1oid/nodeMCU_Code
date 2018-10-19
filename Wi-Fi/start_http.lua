dofile('httpServer.lua')
dofile('table_to_string.lua')

httpServer:listen(80)
TMR_WIFI = 4

httpServer:use('/', function(req, res)
        if wifi.getmode() == 3 then
            res:sendFile("index.html")
        else
            res:send("<h1>Hello,nodeMCU</h1>")
        end
end)

httpServer:use('/config', function(req, res)
    if req.query.ssid ~= nil and req.query.pwd ~= nil then
        wifi.sta.disconnect()
        local cfg = {}
        cfg.ssid = req.query.ssid
        cfg.pwd = req.query.pwd
        wifi.sta.config(cfg)
        print("connect wifi ssid: "..cfg.ssid.." pwd: "..cfg.pwd)

        -- 等待10秒连接wifi,这里可以自己修改
        tmr.alarm(TMR_WIFI, 10000, tmr.ALARM_AUTO, function()
            print(wifi.sta.getip())
            if wifi.sta.getip() ~= nil then
                res:send('{"status":"connect success."}')
                wifi.setmode(wifi.STATION)
                tmr.stop(TMR_WIFI)
            else
                res:send('{"status":"connect fail."}')
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
