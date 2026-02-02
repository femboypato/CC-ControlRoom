os.loadAPI("lib/utils")

CreateTarget = {
    id = nil,
    target = nil,
    lines = 0,
    data = {}
}

function CreateTarget:new(o, id, lines)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.name = id
    self.lines = lines
    self.target = utils.getPeripheral("create_target", "create_target_"..id)
    return o
end

function CreateTarget:getLine(i)
    if self.target == nil then
        return "n/a"
    end
    
    local line = self.target.getLine(i)
    if line == nil then
        return "n/a"
    else
        return utils.trim(line)
    end
end