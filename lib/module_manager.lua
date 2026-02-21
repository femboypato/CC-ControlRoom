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
    if moduleIndex >= 1 and moduleIndex <= self.numModules then
        print("Sending ".. "moduleManagerToggle_" .. tostring(self.id))
        self.signalStates[moduleIndex] = not self.signalStates[moduleIndex]
        local success, err = pcall(function()
            local result = rednet.broadcast(self.signalStates[moduleIndex], "moduleManagerToggle_" .. tostring(self.id))
            if not result then
                error("rednet.broadcast failed")
            end
        end)
        if not success then
            print("[Error] rednet.broadcast: " .. tostring(err))
        end
        print("Module " .. moduleIndex .." is ".. (self.signalStates[moduleIndex] and "OFF" or "ON"))
    end
end
