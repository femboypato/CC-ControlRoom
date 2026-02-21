ModuleManager = {}
ModuleManager.__index = ModuleManager

-- init
function ModuleManager:new(numModules)
    local o = {}
    setmetatable(o, self)
    o.modem = peripheral.find("modem")
    if o.modem then
        rednet.open("top")
    end

    o.signalStates = {}
    for i = 1, numModules do
        o.signalStates[i] = false
    end

    o.numModules = numModules
    return o
end

function ModuleManager:toggleSignal(moduleIndex)
    if moduleIndex >= 1 and moduleIndex <= self.numModules then
        self.signalStates[moduleIndex] = not self.signalStates[moduleIndex]
        rednet.broadcast(self.signalStates[moduleIndex], "moduleManagerToggle_" .. tostring(self.id))
    end
end
