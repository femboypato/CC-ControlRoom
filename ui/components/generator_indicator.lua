local STATUS = {
    OFF = "OFF",
    ON = "ON",
    IDLE = "IDLE",
    ERROR = "ERROR",
    UNKNOWN = "?" -- fallback, lo incorporamos cuando hagamos un OFF manual
}

local colorMap = {
    [STATUS.IDLE] = colors.orange,
    [STATUS.ON] = colors.cyan,
    [STATUS.OFF] = colors.gray,
    [STATUS.ERROR] = colors.red
}

function calculateStatus(module)
    if module:getTotal() == nil or module:getUsage() == nil then
        return STATUS.ERROR
    elseif module:getUsage() == 0 then
        return STATUS.IDLE
    elseif module:getUsage() > 0 then
        return STATUS.ON
    else
        return STATUS.OFF
    end
end

function draw(monitor, x, y, width, height, module)
    -- debug
    local rawUsagePercent = module:getUsagePercent()
    local rawUsage = module:getUsage()
    local rawTotal = module:getTotal()
    local status = calculateStatus(module)

    -- info
    local boxColor = colorMap[status] or colors.cyan
    local statusText = status or "?"
    local usageValue = rawUsagePercent
    local usageText = (usageValue == 0) and "--" or string.format("%d%%", math.floor((usageValue or 0) * 100))

    -- medidas
    local boxHeight = math.floor(height - 2)

    -- module name
    monitor:drawText(x + math.floor((width - #module.getName()) / 2), y, module.getName(), colors.white)

    -- status display
    monitor:drawBox(x + 1, y + 1, width - 2, boxHeight, boxColor, colors.white, true)

    -- Status & usage text
    monitor:drawText(x + math.floor((width - #statusText) / 2), y + 1 + math.floor((boxHeight - 2) / 2), statusText, colors.white)
    monitor:drawText(x + 1, y + boxHeight + 2, usageText, colors.white)

    -- DEBUG
    monitor:drawText(x + 1, y + boxHeight + 3, "U:" .. tostring(rawUsage), colors.white)
    monitor:drawText(x + 1, y + boxHeight + 4, "T:" .. tostring(rawTotal), colors.white)
    monitor:drawText(x + 1, y + boxHeight + 5, "P:" .. tostring(rawUsagePercent), colors.white)
end
