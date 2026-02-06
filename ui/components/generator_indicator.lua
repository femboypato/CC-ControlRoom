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

GeneratorIndicator = {
    usage = nil,
    module_name = ""
}

function GeneratorIndicator:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.status = STATUS.OFF
    o.usage = nil
    o.module_name = ""
    return o
end

------------ getters and setters ------------
function GeneratorIndicator:getStatus()
    return self.status
end

function GeneratorIndicator:setStatus(status)
    self.status = status
end

function GeneratorIndicator:getUsage()
    return self.usage
end

function GeneratorIndicator:setUsage(usage)
    if usage and usage >= 0 and usage <= 1 then
        self.usage = 1 - usage
    else
        self.usage = 0
    end
end

function GeneratorIndicator:getModuleName()
    return self.module_name
end

function GeneratorIndicator:setModuleName(name)
    self.module_name = name
end

------------ logic functions ------------
function GeneratorIndicator:calculateStatus(module)
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

function GeneratorIndicator:refresh(module)
    self:setModuleName(module:getName())
    self:setUsage(module:getUsagePercent())
    self:setStatus(self:calculateStatus(module))
end

function GeneratorIndicator:draw(monitor, x, y, width, height, module)
    self:refresh(module)

    -- debug
    local rawUsagePercent = module:getUsagePercent()
    local rawUsage = module:getUsage()
    local rawTotal = module:getTotal()

    -- info
    local boxColor = colorMap[self:getStatus()] or colors.cyan
    local statusText = self:getStatus() or "?"
    local usageText = string.format("%d%%", math.floor((self.usage or 0) * 100))

    -- medidas
    local boxHeight = math.floor(height - 2)

    -- module name
    monitor:drawText(x + math.floor((width - #self:getModuleName()) / 2), y, self:getModuleName(), colors.white)

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
