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
        self.data[i] = utils.trim(self.target.getLine(i))
    end
end

function CreateTarget:getData(line)
    return self.data[line]
end