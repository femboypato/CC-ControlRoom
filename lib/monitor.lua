local mon = peripheral.find("monitor")
w, h = mon.getSize()

function clear()
    mon.clear()
    mon.setBackgroundColor(colors.black)
    mon.setTextColor(colors.white)
end

function drawText(x, y, text, textColor, bgColor)
    textColor = textColor or colors.white
    bgColor = bgColor or colors.black
    mon.setBackgroundColor(bgColor)
    mon.setTextColor(textColor)
    mon.setCursorPos(x,y)
    mon.write(text)
end

function drawTextLeft(x, y, text, textColor, bgColor)
    drawText(x, y, text, textColor, bgColor)
end

function drawTextCenter(paddingLeft, paddingRight, y, text, textColor, bgColor)
    local x = ((w-string.len(text))/2) + paddingLeft - paddingRight
    drawText(x, y, text, textColor, bgColor)
end

function drawTextRight(padding, y, text, textColor, bgColor)
    drawText(w-string.len(tostring(text))-padding, y, text, textColor, bgColor)
end

function drawHLine(x, y, length, color)
    color = color or colors.white
    if length < 0 then
      length = 0
    end

    mon.setBackgroundColor(color)
    mon.setCursorPos(x,y)
    mon.write(string.rep(" ", length))
end

function drawVLine(x, y, length, color)
    color = color or colors.white
    if length < 0 then
        length = 0
    end

    mon.setBackgroundColor(color)
    for i=y,length do
        mon.setCursorPos(x, i)
        mon.write(" ")
    end
end

function drawProgressBar(x, y, length, percent, barColor, bgColor)
    barColor = barColor or colors.blue
    bgColor = bgColor or colors.white
    drawHLine(x, y, length, bgColor)
    drawHLine(x, y, percent * length, barColor)
end
