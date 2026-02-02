os.loadAPI("lib/utils")

CreateTarget = {
    name = nil,
    target = nil,
    lines = 0,
    data = {}
}

function CreateTarget:new(o, name, lines)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    self.name = name
    self.lines = lines
    self.target = utils.getPeripheral("create_target", name)
    return o
end

function CreateTarget:update()
    for i=1,self.lines do
        local line = self.target.getLine(i)
        if line == nil then
            self.data[i] = "n/a"
        else
            self.data[i] = utils.trim(line)
        end
    end
end

function CreateTarget:getData(line)
    return self.data[line]
end