os.loadAPI("lib/button")
os.loadAPI("lib/utils")
os.loadAPI("lib/create_target")
os.loadAPI("lib/redstone_relay")
os.loadAPI("lib/monitor")
-- monitor size 71 x 26
local testTarget = create_target.CreateTarget:new(nil, "0", 1)
local testRelay = redstone_relay.RedstoneRelay:new(nil, "2", 1)

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
    monitor.drawText(4, 4, "Stress Units: "..testTarget:getLine(1))
    monitor.drawText(4, 6, "Status: "..testRelay:getInputStr("top"))
end

function mainLoop()
    init()

    while true do
        screen()
        sleep(2)
    end
end

parallel.waitForAny(mainLoop, button.clickEvent)