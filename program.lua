-- Reactor Control
os.loadAPI("lib/button")
os.loadAPI("lib/utils")
os.loadAPI("lib/reactor_module")
os.loadAPI("lib/monitor")
-- UI Elements
os.loadAPI("ui/components/generator_indicator")

-- monitor size 71 x 26
local module1 = reactor_module.ReactorModule:new("Module 1", 1, 1)
local module2 = reactor_module.ReactorModule:new("Module 2", 2, 2)
local monitor1 = monitor.Monitor:new(3)
local monitor2 = monitor.Monitor:new(4)

function init()
    button.clearTable()
    monitor1:clear()
    monitor1:drawTextCenter(0, 0, monitor1:getW() / 2 - 1, "Loading...")
    print("Created "..module1:getName().." with target: "..module1:getTarget():getId())
    print("Created "..module2:getName().." with target: "..module2:getTarget():getId())

    -- cache initial data
    for i=1,20 do
        monitor1:drawProgressBar(monitor1:getW() / 4, monitor1:getH() / 2, monitor1:getW() / 2, i / 20)
        module1:refresh()
        module2:refresh()
        sleep(0.2)
    end
end

function screen()
    monitor1:clear()
    monitor1:drawHLine(2, 2, monitor1:getW() - 2)
    monitor1:drawHLine(2, monitor1:getH() - 1, monitor1:getW() - 2)
    monitor1:drawVLine(2, 2, monitor1:getH() - 1)
    monitor1:drawVLine(monitor1:getW() - 1, 2, monitor1:getH() - 2)
    monitor1:drawTextCenter(0, 0, 2, " Reactor Control ", colors.red)

    -- modules
    local modules = {}
    for i = 1, 14 do
        modules[i] = reactor_module.ReactorModule:new("Module " .. i, i, i)
    end

    -- Indicators config
    local topY = 4 -- top row starts at 4
    local bottomY = 15 -- bottom row starts at 15
    local indicatorWidth = 10
    local indicatorHeight = 6
    local spacing = 1

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

    monitor2:clear()
    monitor2:drawHLine(2, 2, monitor1:getW() - 2)
    monitor2:drawHLine(2, monitor1:getH() - 1, monitor1:getW() - 2)
    monitor2:drawVLine(2, 2, monitor1:getH() - 1)
    monitor2:drawVLine(monitor1:getW() - 1, 2, monitor1:getH() - 2)
    monitor2:drawTextCenter(0, 0, 2, " Reactor Control ", colors.red)
end

function mainLoop()
    init()

    while true do
        screen()
        sleep(0.5)
    end
end

parallel.waitForAny(mainLoop, button.clickEvent)