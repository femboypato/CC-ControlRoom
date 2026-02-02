os.loadAPI("lib/button")
os.loadAPI("lib/utils")
os.loadAPI("lib/create_target")
os.loadAPI("lib/redstone_rela")
os.loadAPI("lib/monitor")
-- monitor size 71 x 26
local testTarget = create_target.CreateTarget:new(nil, "0", 1)
local testRelay = redstone_relay.RedstoneRelay:new(nil, "2", 1)

function init()
    button.clearTable()
    button.label(7,1,"Reactor Control")
end

function screen()
    button.screen()
    testTarget:update()
    monitor.drawHLine(2, 2, monitor.w - 4)
    monitor.drawHLine(2, monitor.h - 2, monitor.w - 4)
    monitor.drawVLine(2, 2, monitor.h - 4)
    monitor.drawVLine(monitor-w - 2, 2, monitor.h - 4)
    monitor.drawTextCenter(0, 0, 2, "Reactor Control")
    monitor.drawText(4, 4, "Stress Units: "..testTarget:getData(1))
    monitor.drawText(6, 4, "Status: "..testRelay:getInput("top"))
end

function mainLoop()
    init()

    while true do
        screen()
        sleep(2)
    end
end

parallel.waitForAny(screen, button.clickEvent)