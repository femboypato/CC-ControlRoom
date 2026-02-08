-- Reactor Control
os.loadAPI("lib/button")
os.loadAPI("lib/utils")
os.loadAPI("lib/reactor_module")
os.loadAPI("lib/monitor")
-- UI Elements
os.loadAPI("ui/screens/reactor_screen")

-- monitor size 71 x 26
local monitor1 = monitor.Monitor:new(3)
local monitor2 = monitor.Monitor:new(4)

-- girame unos modules
local modules = {}
for i = 1, 14 do
    modules[i] = reactor_module.ReactorModule:new("Module " .. i, i, i)
end

-- screens
local reactorScreen = reactor_screen.ReactorScreen:new(monitor1, "Reactor Control")


function init()
    button.clearTable()
    monitor1:clear()
    monitor1:drawTextCenter(0, 0, monitor1:getW() / 2 - 1, "Loading...")
    for i = 1, 14 do
        local target = modules[i]:getTarget()
        local targetInfo = target:getId() or "No target"
        print("Created " .. modules[i]:getName() .. " with target: " .. targetInfo)
    end

    -- cache initial data
    for i = 1, 20 do
        monitor1:drawProgressBar(monitor1:getW() / 4, monitor1:getH() / 2, monitor1:getW() / 2, i / 20)
        for o = 1, #modules do
            modules[o]:refresh()
        end
        sleep(0.2)
    end
end

function screen()
    -- huh???? data for the modules is still wrong here (no usage values)
    -- print("Module info:")
    -- for i = 1, #modules do
    --     print("Module " .. i .. ": " .. modules[i]:getName() .. " - Usage: " .. modules[i]:getRawUsage() .. ", Total: " .. modules[i]:getRawTotal())
    -- end
    reactorScreen:render(modules)

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
        for i = 1, #modules do
            modules[i]:refresh()
        end

        screen()
        sleep(0.5)
    end
end

parallel.waitForAny(mainLoop, button.clickEvent)
