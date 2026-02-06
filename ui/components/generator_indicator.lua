GeneratorIndicator = {
    STATUS = {
        OFF = 0,
        ON = 1,
        IDLE = 3,
        ERROR = 4
    },
    usage = nil,
    module_name = ""
}

function GeneratorIndicator:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.status = self.STATUS.OFF
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
        return self.STATUS.ERROR
    elseif module:getUsage() == 0 then
        return self.STATUS.IDLE
    elseif module:getUsage() == module:getTotal() then
        return self.STATUS.ON
    else
        return self.STATUS.OFF
    end
end

function GeneratorIndicator:refresh(module)
    self:setModuleName(module:getName())
    self:setUsage(module:getUsagePercent())
    self:setStatus(self:calculateStatus(module))
end

function GeneratorIndicator:draw(monitor, x, y, width, height, module)
    self:refresh(module)

    local colorMap = {
        [self.STATUS.IDLE] = colors.gray,
        [self.STATUS.ON] = colors.cyan,
        [self.STATUS.OFF] = colors.orange,
        [self.STATUS.ERROR] = colors.red
    }
    local boxColor = colorMap[self:getStatus()] or colors.black

    -- draw box
    for i = 0, height - 1 do
        monitor:drawText(x, y + i, string.rep(" ", width), boxColor)
    end

    -- module name
    monitor:drawText(x + math.floor((width - #self:getModuleName()) / 2), y, self:getModuleName(), colors.white)

    -- module usage
    local usageText = string.format("Usage: %d%%", math.floor((module:getUsagePercent() or 0) * 100))
    monitor:drawText(x + math.floor((width - #usageText) / 2), y + height - 1, usageText, colors.white)
end
