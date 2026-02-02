os.loadAPI("lib/button")
os.loadAPI("lib/utils")
os.loadAPI("lib/create_target")
local monitor = peripheral.find("monitor")
local testTarget = create_target.CreateTarget:new(nil, "create_target_0", 1)

function init()
    button.clearTable()
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    button.label(7,1,"Reactor Control")
end

function screen()
    button.screen()
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(1,1)
    testTarget:update()
    button.label(7, 2, testTarget:getData(1))
end

function mainLoop()
    init()

    while true do
        screen()
        sleep(2)
    end
end

parallel.waitForAny(screen, button.clickEvent)