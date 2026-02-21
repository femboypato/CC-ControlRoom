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

    local success, err = pcall(function()
        local result = rednet.broadcast(self.signalStates[moduleIndex], "moduleManagerToggle_" .. tostring(moduleIndex))
        if not result then
            error("rednet.broadcast failed")
        end
    end)

    if not success then
        print("[Error] rednet.broadcast: " .. tostring(err))
    end

    print("Module " .. moduleIndex .. " is " .. (self.signalStates[moduleIndex] and "OFF" or "ON"))
end
