os.loadAPI("lib/utils")

RedstoneRelay = {
    id = nil,
    relay = nil,
}

function RedstoneRelay:new(o, id)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.name = id
    self.target = utils.getPeripheral("redstone_relay", "redstone_relay_"..id)
    return o
end

-- side: ("top", "bottom", "left", "right", "front" and "back")
function RedstoneRelay:getInput(side)
   return self.target.getInput(side)
end

-- side: ("top", "bottom", "left", "right", "front" and "back")
-- on: boolean
function RedstoneRelay:setOutput(side, on)
   return self.target.setOutput(side, on)
end