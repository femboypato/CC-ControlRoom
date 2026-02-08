os.loadAPI("ui/components/generator_indicator")
os.loadAPI("ui/screens/base_screen")

ReactorScreen = {
}

function ReactorScreen:new(monitor, title)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    
    o.monitor = monitor
    o.base = base_screen.BaseScreen:new(monitor, title)
    return o
end

function ReactorScreen:render(modules)
    self.monitor:clear()
    self.base:drawBorder()

    -- Indicators config
    local topY = 4    
    local lineHeight = 2
    local tableWidth = 70

    for i = 1, #modules do
        local yPos = topY + (i - 1) * lineHeight
        local indicator = generator_indicator.GeneratorIndicator:new()
        indicator:draw(self.monitor, 4, yPos, tableWidth, 1, modules[i])
    end
end