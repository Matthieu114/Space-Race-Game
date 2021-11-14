Rocket = Class {}

function Rocket:init(x, y)
    self.x = x
    self.y = y
    self.width = 55 * 0.3
    self.height = 52 * 0.3
    self.dy = 0

end

function Rocket:render(image)
    love.graphics.draw(image, self.x, self.y, 0, 0.3, 0.3) -- 55 by 52 pixels
end

-- reset rocket to initial position if there is a colision with a meteor
function Rocket:resetPlayer1()
    self.x = VIRTUAL_WINDOW_WIDTH / 2 - 30
    self.y = VIRTUAL_WINDOW_HEIGHT - 20
end

function Rocket:resetPlayer2()
    self.x = VIRTUAL_WINDOW_WIDTH / 2 + 30
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
