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

---- helpers ----
local function calculateStatus(module)
    if not module then return STATUS.UNKNOWN end
    local usage = module:getUsage()
    local total = module:getTotal()
    if total == nil or usage == nil then return STATUS.ERROR end
    if usage == 0 then return STATUS.IDLE end
    if usage > 0 then return STATUS.ON end
    return STATUS.OFF
end

local function formatUsagePercent(percent)
    if percent == 0 or percent ~= percent then return "--"
    else return string.format("%d%%", math.floor(percent * 100)) end
end

---- columns ----
local columns = {
    {
        header = "Status",
        width = 35,
        value = function(module)
            local status = calculateStatus(module)
            return {
                text = iconMap[status] or iconMap[STATUS.UNKNOWN],
                color = colorMap[status] or colors.gray,
                isStatus = true
            }
        end
    },
    {
        header = "Module Name",
        width = 20,
        value = function(module)
            return { text = module:getName() or "Module", color = colors.white }
        end
    },
    {
        header = "Usage %",
        width = 8,
        value = function(module)
            local pct = module:getUsagePercent() and module:getUsagePercent() or 0
            return { text = formatUsagePercent(pct), color = colors.lightGray }
        end
    },
    {
        header = "Output",
        width = 10,
        value = function(module)
            local usage = module:getUsage() and module:getUsage() or 0
            return { text = utils.humanizeNumber(usage), color = colors.gray }
        end
    },
    {
        header = "Fuel",
        width = 12,
        value = function(module)
            if not module or module:getUsagePercent() == nil then
                return { text = "0.000 /min", color = colors.gray }
            end
            local fuelUsage = 1.875 * (module:getUsagePercent() / 100)
            return { text = string.format("%.4f /min", fuelUsage), color = colors.lightblue }
        end
    }
}

---- GeneratorsTable table ----
GeneratorsTable = {}
GeneratorsTable.__index = GeneratorsTable

function GeneratorsTable:new()
    local o = {}
    setmetatable(o, GeneratorsTable)
    return o
end

function GeneratorsTable:drawHeader(monitor, x, y)
    local colX = x
    for _, col in ipairs(columns) do
        monitor:drawText(colX, y, col.header, colors.lightGray)
        colX = colX + col.width + 2
    end
end

function GeneratorsTable:drawRow(monitor, x, y, height, module)
    local cursorX = x
    for _, col in ipairs(columns) do
        local cell = col.value(module)

        if cell.isStatus then
            monitor:drawBox(cursorX, y, col.width, height, cell.color, colors.white, true)
            monitor:drawText(cursorX + 2, y, cell.text, colors.white)
        else
            monitor:drawText(cursorX, y, cell.text, cell.color)
        end
        cursorX = cursorX + col.width + 2
    end
end