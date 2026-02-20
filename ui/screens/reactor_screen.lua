os.loadAPI("ui/components/generators_table")
os.loadAPI("ui/screens/base_screen")

ReactorScreen = {}
ReactorScreen.__index = ReactorScreen

function ReactorScreen:new(monitor, title)
    local o = {}
    setmetatable(o, self)
    
    o.monitor = monitor
    o.base = base_screen.BaseScreen:new(monitor, title)
    o.table = generators_table.GeneratorsTable:new()
    return o
end

function ReactorScreen:render(modules)
    self.monitor:clear()
    self.base:drawBorder()

    -- tables config
    local x          = 4
    local headerY    = 5
    local topY       = 5
    local lineHeight = 3

    self.table:drawHeader(self.monitor, x, headerY)
    for i = 1, #modules do
        local yPos = topY + (i - 1) * lineHeight
        self.table:drawRow(self.monitor, x, yPos, 1, modules[i])
    end
end