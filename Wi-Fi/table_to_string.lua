function table_to_string(tbl)
    local result = "{"
    for key, value in pairs(tbl) do
    	print("ssid: "..key)
        key = '\"'..key..'\"'
        value = '\"'..value..'\"'
        result = result..key..":"..value..","
    end
    result = result.."}"
    return result
end
