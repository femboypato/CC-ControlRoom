os.loadAPI("lib/button")
os.loadAPI("lib/utils")
os.loadAPI("lib/reactor_module")
os.loadAPI("lib/monitor")
-- monitor size 71 x 26
local module1 = reactor_module.ReactorModule:new(1, 1)
local module2 = reactor_module.ReactorModule:new(2, 2)

function init()
    button.clearTable()
    monitor.clear()
    monitor.drawTextCenter(0, 0, monitor.h / 2 - 1, "Loading...")

    -- cache initial data
    for i=1,20 do
        monitor.drawProgressBar(monitor.w / 4, monitor.h / 2, monitor.w / 2, i / 20)
        module1:refresh()
        module2:refresh()
        sleep(0.2)
    end
end

function screen()
    button.screen()
    monitor.clear()
    monitor.drawHLine(2, 2, monitor.w - 2)
    monitor.drawHLine(2, monitor.h - 1, monitor.w - 2)
    monitor.drawVLine(2, 2, monitor.h - 1)
    monitor.drawVLine(monitor.w - 1, 2, monitor.h - 2)
    monitor.drawTextCenter(0, 0, 2, " Reactor Control ", colors.red)
    
    monitor.drawText(4, 4, "Module 1 - Generation: "
        ..module1:getRawTotal()
        .."su Usage: "
        ..module1:getRawUsage()
        .. "su ("
        ..(module1:getUsagePercent()*100)
        ..")"
    )

    monitor.drawText(4, 5, "Module 2 - Generation: "
        ..module2:getRawTotal()
        .."su Usage: "
        ..module2:getRawUsage()
        .. "su ("
        ..(module2:getUsagePercent()*100)
        ..")"
    )
end

function mainLoop()
    init()

    while true do
        screen()
        sleep(0.5)
    end
end

parallel.waitForAny(mainLoop, button.clickEvent)