os.loadAPI("ui/components/generators_table")
os.loadAPI("ui/screens/base_screen")

ReactorScreen = {}
ReactorScreen.__index = ReactorScreen
-- monitor size 71 x 26

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
    self.monitor:drawHLine(2, 22, self.monitor:getW() - 2, colors.white)

    -- tables config
    local x          = 6
    local headerY    = 4
    local topY       = 6
    local lineHeight = 2 -- multiplier

    --- table
    self.table:drawHeader(self.monitor, x, headerY)
    for i = 1, 14 do
        modules[i]:refresh()
    end
    for i = 1, 14 do
        local yPos = topY + (i - 1) * lineHeight
        self.table:drawRow(self.monitor, x, yPos, 1, modules[i])
    end   

end