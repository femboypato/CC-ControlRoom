os.loadAPI("lib/button")
os.loadAPI("lib/utils")
os.loadAPI("lib/reactor_module")
os.loadAPI("lib/monitor")
-- monitor size 71 x 26
local module1 = reactor_module.ReactorModule:new(1, 1)
local module2 = reactor_module.ReactorModule:new(1, 2)

function init()
    button.clearTable()
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
        ..module1:getTotal()
        .."su Usage: "
        ..module1:getUsage()
        .. "su ("
        ..(module1:getUsagePercent()*100)
        ..")"
    )

    monitor.drawText(4, 5, "Module 2 - Generation: "
        ..module2:getTotal()
        .."su Usage: "
        ..module2:getUsage()
        .. "su ("
        ..(module2:getUsagePercent()*100)
        ..")"
    )
end

function mainLoop()
    init()

    while true do
        screen()
        sleep(2)
    end
end

parallel.waitForAny(mainLoop, button.clickEvent)