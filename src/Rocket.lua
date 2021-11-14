Rocket = Class {}

function Rocket:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0

end

function Rocket:render(image)
    -- love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.draw(image, self.x, self.y, 0, 0.3, 0.3)
end

-- reset rocket to initial position if there is a colision with a meteor
function Rocket:resetPlayer1()
    self.x = VIRTUAL_WINDOW_WIDTH / 2 + 30
    self.y = VIRTUAL_WINDOW_HEIGHT - 20
end

function Rocket:resetPlayer2()
    self.x = VIRTUAL_WINDOW_WIDTH / 2 - 30
    self.y = VIRTUAL_WINDOW_HEIGHT - 20
end

function Rocket:update(dt)
    if self.dy < 0 then
        self.y = self.y + self.dy * dt

    else
        if self.dy > 0 then
            self.y = math.min(VIRTUAL_WINDOW_HEIGHT - self.height, self.y + self.dy * dt)
        end
    end

end
