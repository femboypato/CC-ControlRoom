function getPeripheral(type, name)
    local results = { peripheral.find(type) }
    for _, p in pairs(results) do
        if peripheral.getName(p) == name then
            return p
        end
    end

    return nil
end

function trim(str)
    return string.gsub(str, "^%s*(.-)%s*$", "%1")
end

function parseSU(str)
    if str == nil then
        return -1
    end

    num = string.gsub(str, "%D", "")

    if num == "" then
        return -2
    end

    return tonumber(num)
end