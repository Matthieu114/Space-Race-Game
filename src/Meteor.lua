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
        self.y = math.random(VIRTUAL_WINDOW_HEIGHT - 60)

    else
        if self.x <= 0 then
            self.x = VIRTUAL_WINDOW_WIDTH
            self.y = math.random(VIRTUAL_WINDOW_HEIGHT - 60)
        end
    end

end

function Meteor:collision(rocket)

    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > rocket.x + rocket.width or rocket.x > self.x + self.width then
        return false
    end
    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > rocket.y + rocket.height or rocket.y > self.y + self.height then
        return false
    end
    -- if none above true then there is a collision as they are overlapping
    return true
end

-- reset 
function Meteor:reset()

end

function Meteor:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end
