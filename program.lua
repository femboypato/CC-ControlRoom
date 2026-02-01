os.loadAPI("lib/button")
local monitor = peripheral.find("monitor")

function getClick()
    local event, side, x, y = os.pullEvent("monitor_touch")
    return x,y,side
end

function main()
    button.clearTable()
    monitor.setBackgroundColor(colors.black)
    monitor.clear()
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(1,1)
    button.label(7,1,"Reactor Control")
    button.screen()
end

function waitInput()
    x,y = getClick()
    if button.checkxy(x,y) then return true end
end

main()
while true do waitInput() end