local mon = peripheral.find("monitor")
w, h = mon.getSize()

function heading(text)
   mon.setCursorPos((w-string.len(text))/2+1, 1)
   mon.write(text)
end

function label(w, h, text)
   mon.setCursorPos(w, h)
   mon.write(text)
end

function clear()
    mon.clear()
    mon.setBackgroundColor(colors.black)
    mon.setTextColor(colors.white)
end

function drawText(x, y, text, text_color, bg_color)
    text_color = text_color or colors.white
    bg_color = bg_color or colors.black
    mon.setBackgroundColor(bg_color)
    mon.setTextColor(text_color)
    mon.setCursorPos(x,y)
    mon.write(text)
end

function drawTextLeft(x, y, text, text_color, bg_color)
    drawText(x, y, text, text_color, bg_color)
end

function drawTextCenter(paddingLeft, paddingRight, y, text, text_color, bg_color)
    local x = ((w-string.len(text))/2) + paddingLeft - paddingRight
    drawText(x, y, text, text_color, bg_color)
end

function drawTextRight(padding, y, text, text_color, bg_color)
    drawText(w-string.len(tostring(text))-padding, y, text, text_color, bg_color)
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