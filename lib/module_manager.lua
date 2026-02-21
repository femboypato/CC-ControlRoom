ModuleManager = {}
ModuleManager.__index = ModuleManager

-- init
function ModuleManager:new(numModules)
    local o = {}
    setmetatable(o, self)
    o.modem = peripheral.wrap("front")
    if o.modem then
        rednet.open("front")
    end

    o.signalStates = {}
    for i = 1, numModules do
        o.signalStates[i] = false
    end

    o.numModules = numModules
    return o
end

function ModuleManager:toggleSignal(moduleIndex)
    print("Sending " .. "moduleManagerToggle_" .. tostring(moduleIndex))
    self.signalStates[moduleIndex] = not self.signalStates[moduleIndex]
    rednet.broadcast(self.signalStates[moduleIndex], "moduleManagerToggle_" .. tostring(moduleIndex))
    print("Sent " .. (self.signalStates[moduleIndex] and "OFF" or "ON") .. "to module" .. moduleIndex)
end
