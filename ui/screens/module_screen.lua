os.loadAPI("ui/components/generator_indicator")
os.loadAPI("ui/componnents/base_screen")

ReactorScreen = {}

function ReactorScreen:new(monitor, title)
    local self = base_screen.BaseScreen:new(monitor, title)
    setmetatable(self, ReactorScreen)

    return self
end

function ReactorScreen:render(modules)
    self:clear()
    self:drawBorder()

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
        indicator:draw(monitor1, xPos, topY, indicatorWidth, indicatorHeight, modules[i])
    end

    -- bottoms
    for i = 8, 14 do
        local xPos = 4 + (i - 8) * (indicatorWidth + spacing)
        local indicator = generator_indicator.GeneratorIndicator:new()
        indicator:draw(monitor1, xPos, bottomY, indicatorWidth, indicatorHeight, modules[i])
    end
end