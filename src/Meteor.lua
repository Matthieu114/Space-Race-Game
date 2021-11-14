Meteor = Class {}

function Meteor:init(x, y, width, height, dx)
    self.x = x;
    self.y = y;
    self.width = width;
    self.height = height;
    self.dx = dx;
end

function Meteor:update(dt)

    self.x = self.x + self.dx * dt

    if self.x >= VIRTUAL_WINDOW_WIDTH then
        self.x = 0
        self.y = math.random(VIRTUAL_WINDOW_HEIGHT - 40)

    else
        if self.x <= 0 then
            self.x = VIRTUAL_WINDOW_WIDTH
            self.y = math.random(VIRTUAL_WINDOW_HEIGHT - 40)
        end
    end

end

function Meteor:collision(rocket)

    if self.x > rocket.x + rocket.width or rocket.x > self.x + self.width then
        return false
    end
    if self.y > rocket.y + rocket.height or rocket.y > self.y + self.height then
        return false
    end

    print(rocket.height)
    print(rocket.width)
    print(rocket.x)
    print(rocket.y)

    return true
end

-- reset 
function Meteor:reset()

end

function Meteor:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
