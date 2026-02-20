os.loadAPI("lib/utils")

local STATUS = {
    OFF = "OFF",
    ON = "ON",
    IDLE = "IDLE",
    ERROR = "ERROR",
    UNKNOWN = "?"
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

GeneratorIndicator = {}
GeneratorIndicator.__index = GeneratorIndicator

function GeneratorIndicator:new(module)
    local o = {}
    setmetatable(o, GeneratorIndicator)
    
    o.module = module
    o.nmoduleName = "No module"
    o.usage = 0
    o.total = 0
    o.usagePercent = 0
    o.status = STATUS.UNKNOWN

    if module then
        o:refresh(module)
    end

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
    if not module then
        self.moduleName = "No Module"
        self.usage = 0
        self.total = 0
        self.usagePercent = 0
        self.status = STATUS.UNKNOWN
        return
    end
    
    local hasTarget = module.getTarget and module:getTarget() ~= nil
    if not hasTarget then
        self.moduleName = "No Target"
        self.usage = 0
        self.total = 0
        self.usagePercent = 0
        self.status = STATUS.OFF
        return
    end
    
    local rawUsage = module:getUsage()
    local rawTotal = module:getTotal()
    local rawPercent = module:getUsagePercent()
    
    self.moduleName = module:getName() or "Module"
    self.usage = rawUsage or 0
    self.total = rawTotal or 0
    self.usagePercent = rawPercent or 0
    self.status = calculateStatus(self.usage, self.total)
    
end

function GeneratorIndicator:draw(monitor, x, y, width, height, module)
    self:refresh(module)
    
    -- text & colors
    local statusIcon = iconMap[self.status] or iconMap[STATUS.UNKNOWN]
    local statusColor = colorMap[self.status] or colors.gray
    local percentText = formatUsagePercent(self.usagePercent)
    local usageText = utils.humanizeNumber(self.usage)
    
    -- column start positions
    local iconWidth  = 7             
    local colName    = x + iconWidth + 1
    local colPercent = x + width - 12
    local colUsage   = x + width - 6

    -- Status icon
    monitor:drawBox(x, y, iconWidth, height, statusColor, colors.white, true)
    monitor:drawText(x + 1, y + math.floor((height - 1) / 2), statusIcon, colors.white)
    -- Module name
    monitor:drawText(colName, y, self.moduleName, colors.white)
    -- Usage percentage
    monitor:drawText(colPercent, y, percentText, colors.lightGray)
    -- Formatted usage value
    monitor:drawText(colUsage, y, usageText, colors.gray)
end