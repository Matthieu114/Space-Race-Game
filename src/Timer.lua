Timer = Class {}

function Timer:init(x, y, width, timerLength)
    self.x = x
    self.y = y
    self.width = width
    self.timerLength = timerLength
end

function Timer:render()
    love.graphics
        .rectangle('fill', self.x, self.y, self.width, self.timerLength)
    -- function Timer:update() self.timerLength = self.timerLength + 1 end
end

