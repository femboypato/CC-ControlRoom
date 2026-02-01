os.loadAPI("lib/button")

function getClick()
    local event, side, x, y = os.pullEvent("monitor_touch")
    return x,y,side
end

function main()
    button.clearTable()
    m.setBackgroundColor(colors.black)
    m.clear()
    m.setTextColor(colors.white)
    m.setCursorPos(1,1)
    button.label(7,1,"Reactor Control")
    button.screen()
end

function waitInput()
    x,y = getClick()
    if button.checkxy(x,y) then return true end
end

main()
while true do waitInput() end