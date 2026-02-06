local STATUS = {
    OFF = "OFF",
    ON = "ON",
    IDLE = "IDLE",
    ERROR = "ERROR"
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
    self.usage = usage
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
    elseif module:getUsage() == module:getTotal() then
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

    -- info
    local boxColor = colorMap[self:getStatus()] or colors.cyan
    local statusText = STATUS[self:getStatus()] or "UNKNOWN"

    -- medidas
    local leftWidth = math.floor(width / 2)
    local rightWidth = width - leftWidth
    local dividerX = x + leftWidth

    -- module name
    monitor:drawText(x + math.floor((width - #self:getModuleName()) / 2), y, self:getModuleName(), colors.white)
    
    -- divider
    monitor:drawVLine(dividerX, y + 1, y + height - 1, colors.black)

    -- LEFT: status box
    monitor:drawBox(x + 1, y + 1, leftWidth - 2, height - 3, boxColor, colors.white, true)

    -- RIGHT: status & usage
    local usageText = string.format("Usage: %d%%", math.floor((module:getUsagePercent() or 0) * 100))
    monitor:drawText(dividerX + 2, y + 2, "Status: " .. statusText, colors.white)
    monitor:drawText(dividerX + 2, y + 4, usageText, colors.white)
end
