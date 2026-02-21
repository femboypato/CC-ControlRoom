ModuleToggle = {}
ModuleToggle.__index = ModuleToggle

-- init
function ModuleToggle:new(moduleId)
    local o = {}
    setmetatable(o, self)
    o.modem = peripheral.find("modem")
    o.id = moduleId
    o.signalState = false
    if o.modem then
        rednet.open("top")
    end
    return o
end

function ModuleToggle:toggleSignal()
    self.signalState = not self.signalState
end

function ModuleToggle:broadcast()
    rednet.broadcast(self.signalState, "moduleToggle_" .. tostring(self.id))
end