os.loadAPI("lib/create_target")
os.loadAPI("lib/redstone_relay")
os.loadAPI("lib/utils")

TOTAL_LINE_INDEX = 2
USAGE_LINE_INDEX = 1

ReactorModule = {
}
ReactorModule.__index = ReactorModule

function ReactorModule:new(name, targetId, relayId)
    local o = {}
    setmetatable(o, self)
    
    o.name = name
    o.target = create_target.CreateTarget:new(targetId)
    o.relay = redstone_relay.RedstoneRelay:new(relayId)
    return o
end

function ReactorModule:getName()
    return self.name
end

function ReactorModule:getTarget()
    return self.target
end

function ReactorModule:refresh()
    self.target:refresh(2)
end

function ReactorModule:getTotal()
    return utils.parseSU(self.target:getLine(TOTAL_LINE_INDEX))
end

function ReactorModule:getRawTotal()
    return self.target:getLine(TOTAL_LINE_INDEX)
end

function ReactorModule:getUsage()
    return utils.parseSU(self.target:getLine(USAGE_LINE_INDEX))
end

function ReactorModule:getRawUsage()
    return self.target:getLine(USAGE_LINE_INDEX)
end

function ReactorModule:getRemaining()
    local total = self:getTotal()
    local usage = self:getUsage()
    if total == nil or usage == nil then
        return nil
    end

    return total - usage
end

function ReactorModule:getUsagePercent()
    local total = self:getTotal()
    local usage = self:getUsage()
    if total == nil or usage == nil then
        return nil
    end

    return usage / total
end