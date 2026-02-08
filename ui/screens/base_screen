BaseScreen = {}

function BaseScreen:new(monitor, title)
    local self = setmetatable({}, title)
    self.monitor = monitor
    self.title = title or "Screen"
    return self
end

function BaseScreen:drawBorder()
    local m = self.monitor
    m:drawHLine(2, 2, m:getW() - 2)
    m:drawHLine(2, m:getH() - 1, m:getW() - 2)
    m:drawVLine(2, 2, m:getH() - 1)
    m:drawVLine(m:getW() - 1, 2, m:getH() - 2)
    m:drawTextCenter(0, 0, 2," " .. self.title .. " ", colors.red)
end

function BaseScreen:clear()
    self.monitor:clear()
end

function BaseScreen:draw()
    self:clear()
    self:drawBorder()
end
