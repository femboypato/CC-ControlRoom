os.loadAPI("lib/utils")

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
    [STATUS.ERROR] = colors.red,
    [STATUS.UNKNOWN] = colors.gray
}

local iconMap = {
    [STATUS.IDLE] = "[ ]",
    [STATUS.ON] = "[O]",
    [STATUS.OFF] = "[X]",
    [STATUS.ERROR] = "[!]",
    [STATUS.UNKNOWN] = "[?]"
}

GeneratorIndicator = {
    usage = nil,
    moduleName = "",
    status = STATUS.OFF
}

function GeneratorIndicator:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.status = STATUS.OFF
    o.usage = nil
    o.moduleName = ""
    return o
end

------------ private helpers ------------
local function calculateStatus(usage, total)
    if total == nil or usage == nil then
        return STATUS.ERROR
    elseif usage == 0 then
        return STATUS.IDLE
    elseif usage > 0 then
        return STATUS.ON
    else
        return STATUS.OFF
    end
end

local function formatUsagePercent(percent)
    if percent == 0 or percent ~= percent then
        return "--"
    else
        return string.format("%d%%", math.floor(percent * 100))
    end
end


------------ public methods ------------
function GeneratorIndicator:refresh(module)
    self.moduleName = module:getName() or "Module"
    self.usage = module:getUsage() or 0
    self.total = module:getTotal() or 0
    self.usagePercent = module:getUsagePercent() or 0
    self.status = calculateStatus(self.usage, self.total)
end

function GeneratorIndicator:draw(monitor, x, y, width, height, module)
    self:refresh(module)
    
    -- text & colors
    local statusIcon = iconMap[self.status] or iconMap[STATUS.UNKNOWN]
    local statusColor = colorMap[self.status] or colors.gray
    local percentText = formatUsagePercent(self.usagePercent)
    local usageText = utils.humanizeNumber(self.usage)

    -- columns width
    local iconWidth = #statusIcon
    local nameWidth = math.min(#self.moduleName, width - iconWidth - 8)
    local percentWidth = 5
    local usageWidth = width - iconWidth - nameWidth - percentWidth - 4

    -- Status icon
   monitor:drawBox(x, y, iconWidth, height, statusColor, colors.white, true)
    monitor:drawText(x + 1, y + math.floor((height - 1) / 2), statusIcon, colors.white)
    
    -- Module name
    local truncatedName = string.sub(self.module_name, 1, nameWidth)
    monitor:drawText(x + iconWidth + 1, y, truncatedName, colors.white)
    
    -- Usage percentage
    monitor:drawText(x + iconWidth + nameWidth + 2, y, percentText, colors.lightGray)
    
    -- Formatted usage value
    monitor:drawText(x + usageWidth, y, usageText, colors.gray)
end