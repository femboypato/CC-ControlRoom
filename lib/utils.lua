function getPeripheral(type, name)
    local results = peripheral.find(type)
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