os.loadAPI("ui/components/generator_indicator")
os.loadAPI("ui/screens/base_screen")

ReactorScreen = {
    monitor = nil,
    base = nil
}

function ReactorScreen:new(monitor, title)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    
    o.monitor = monitor
    o.base = base_screen.BaseScreen:new(monitor, title)
    return o
end

function ReactorScreen:render(monitor, modules)
    self.monitor:clear()
    self.base:drawBorder()

    -- Indicators config
    local topY = 4     -- top row starts at 4
    local bottomY = 15 -- bottom row starts at 15
    local indicatorWidth = 9
    local indicatorHeight = 5
    local spacing = 0.5

        -- tops
    for i = 1, 7 do
        local xPos = 4 + (i - 1) * (indicatorWidth + spacing)
        local indicator = generator_indicator.GeneratorIndicator:new()
        indicator:draw(monitor, xPos, topY, indicatorWidth, indicatorHeight, modules[i])
    end

    -- bottoms
    for i = 8, 14 do
        local xPos = 4 + (i - 8) * (indicatorWidth + spacing)
        local indicator = generator_indicator.GeneratorIndicator:new()
        indicator:draw(monitor, xPos, bottomY, indicatorWidth, indicatorHeight, modules[i])
    end
end