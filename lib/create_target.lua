os.loadAPI("lib/utils")

CreateTarget = {
    id = nil,
    target = nil,
    data = {} -- cache data because of https://github.com/tweaked-programs/cccbridge/issues/116
}

function CreateTarget:new(id)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.id = id
    o.target = utils.getPeripheral("create_target", "create_target_"..id)
    o.data = {}
    return o
end

function CreateTarget:getId()
    if self.target == nil then
        return nil
    end
    
    return peripheral.getName(self.target)
end

function CreateTarget:getLine(i)
    if self.target == nil then
        return "n/a"
    end

    local line = self.target.getLine(i)
    if line == nil then
        return "n/a"
    end
    line = utils.trim(line)

    if line == "" and self.data[i] ~= nil then
        return self.data[i]
    end

    self.data[i] = line
    return line
end

function CreateTarget:refresh(lines)
    for i=1,lines do
        self:getLine(i)
    end
end