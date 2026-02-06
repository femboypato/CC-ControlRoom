os.loadAPI("lib/utils")

Monitor = {
    w = 0,
    h = 0,
    mon = nil
}

function Monitor:new(id)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.mon = utils.getPeripheral("monitor", "monitor_"..id)
    local w, h = o.mon.getSize()
    o.w = w
    o.h = h
    return o
end

function Monitor:getW()
    return self.w
end

function Monitor:getH()
    return self.h
end

function Monitor:clear()
    self.mon.clear()
    self.mon.setBackgroundColor(colors.black)
    self.mon.setTextColor(colors.white)
end

function Monitor:drawText(x, y, text, textColor, bgColor)
    textColor = textColor or colors.white
    bgColor = bgColor or colors.black
    self.mon.setBackgroundColor(bgColor)
    self.mon.setTextColor(textColor)
    self.mon.setCursorPos(x,y)
    self.mon.write(text)
end

function Monitor:drawTextLeft(x, y, text, textColor, bgColor)
    self:drawText(x, y, text, textColor, bgColor)
end

function Monitor:drawTextCenter(paddingLeft, paddingRight, y, text, textColor, bgColor)
    local x = ((self.w-string.len(text))/2) + paddingLeft - paddingRight
    self:drawText(x, y, text, textColor, bgColor)
end

function Monitor:drawTextRight(padding, y, text, textColor, bgColor)
    self:drawText(self.w-string.len(tostring(text))-padding, y, text, textColor, bgColor)
end

function Monitor:drawHLine(x, y, length, color)
    color = color or colors.white
    if length < 0 then
      length = 0
    end

    self.mon.setBackgroundColor(color)
    self.mon.setCursorPos(x,y)
    self.mon.write(string.rep(" ", length))
end

function Monitor:drawVLine(x, y, length, color)
    color = color or colors.white
    if length < 0 then
        length = 0
    end

    self.mon.setBackgroundColor(color)
    for i=y,length do
        self.mon.setCursorPos(x, i)
        self.mon.write(" ")
    end
end

function Monitor:drawBox(x, y, width, height, color, bgColor, hasOutline)
    color = color or colors.white
    bgColor = bgColor or colors.black
    hasOutline = hasOutline or false

    -- fill
    for i = 0, height - 1 do
        self:drawHLine(x, y + i, width, bgColor)
    end

    -- outline (if enabled)
    if hasOutline then
        self:drawHLine(x, y, width, color) -- top
        self:drawHLine(x, y + height - 1, width, color) -- bottom
        self:drawVLine(x, y, height - 1, color) -- left
        self:drawVLine(x + width - 1, y, y + height - 1, color) -- right
    end
end


function Monitor:drawProgressBar(x, y, length, percent, barColor, bgColor)
    barColor = barColor or colors.blue
    bgColor = bgColor or colors.white
    self:drawHLine(x, y, length, bgColor)
    self:drawHLine(x, y, percent * length, barColor)
end
