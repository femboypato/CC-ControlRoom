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
    
    GeneratorIndicator1 = GeneratorIndicator:new()
    GeneratorIndicator1:draw(monitor1, 6, 4, 20, 15, module1)
    -- monitor1:drawText(4, 4, "Module 1 - Generation: "
    --     ..module1:getRawTotal()
    --     .."su Usage: "
    --     ..module1:getRawUsage()
    --     .. " ("
    --     ..utils.formatPercent(module1:getUsagePercent())
    --     ..")"
    -- )

    monitor1:drawText(4, 5, "Module 2 - Generation: "
        ..module2:getRawTotal()
        .."su Usage: "
        ..module2:getRawUsage()
        .. " ("
        ..utils.formatPercent(module2:getUsagePercent())
        ..")"
    )

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