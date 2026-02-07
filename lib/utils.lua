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
        return 0
    end

    num = string.gsub(str, "%D", "")

    if num == "" then
        return 0
    end

    return tonumber(num)
end

function formatPercent(num)
    if num == nil then
        return "N/A"
    end
    return math.floor(num*100).."%"
end


function humanizeNumber(n)
    if n >= 1e6 then
        return string.format("%.2f M", n / 1e6) -- Millions
    elseif n >= 1e3 then
        return string.format("%.2f K", n / 1e3) -- Thousands
    else
        return tostring(n)
    end
end
