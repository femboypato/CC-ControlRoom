os.loadAPI("lib/create_target")
os.loadAPI("lib/redstone_relay")
os.loadAPI("lib/utils")

ReactorModule = {
    target = nil,
    relay = nil
}

function ReactorModule:new(targetId, relayId)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    self.target = create_target.CreateTarget:new(targetId)
    self.relay = redstone_relay.RedstoneRelay:new(relayId)
    return o
end

function ReactorModule:getTarget()
    return self.target
end

function ReactorModule:refresh()
    self.target:refresh(2)
end

function ReactorModule:getTotal()
    return utils.parseSU(self.target:getLine(1))
end

function ReactorModule:getRawTotal()
    return self.target:getLine(1)
end

function ReactorModule:getUsage()
    return utils.parseSU(self.target:getLine(2))
end

function ReactorModule:getRawUsage()
    return self.target:getLine(2)
end

function ReactorModule:getRemaining()
    total = self:getTotal()
    usage = self:getUsage()
    if total == nil or usage == nil then
        return nil
    end

    return total - usage
end

function ReactorModule:getUsagePercent()
    total = self:getTotal()
    usage = self:getUsage()
    if total == nil or usage == nil then
        return nil
    end

    return usage / total
end