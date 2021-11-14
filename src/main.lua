Push = require "push" -- require the library
Class = require "class"
require "Rocket"
require "Meteor"
require 'Timer'
require 'os'
require 'table'
require 'math'

local START_TIME = os.time()
local END_TIME = START_TIME + 90

WINDOW_WIDTH = 1280;
WINDOW_HEIGHT = 720;

VIRTUAL_WINDOW_WIDTH = 243;
VIRTUAL_WINDOW_HEIGHT = 432;

ROCKET_SPEED = 150
TIMER_START = -150

-- function to initialise the canvas and game units
function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest');

    smallFont = love.graphics.newFont('font.ttf', 8)
    bigFont = love.graphics.newFont('font.ttf', 14)

    newImage = love.graphics.newImage('spaceship.png', {
        dpiscale = 1,
        linear = true
    })

    love.graphics.setFont(smallFont)

    Push:setupScreen(VIRTUAL_WINDOW_WIDTH, VIRTUAL_WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })

    player1 = Rocket(VIRTUAL_WINDOW_WIDTH / 2 + 30, VIRTUAL_WINDOW_HEIGHT - 20, 10, 40)
    player2 = Rocket(VIRTUAL_WINDOW_WIDTH / 2 - 30, VIRTUAL_WINDOW_HEIGHT - 20, 10, 40)

    Timer = Timer(VIRTUAL_WINDOW_WIDTH / 2, VIRTUAL_WINDOW_HEIGHT, 2, TIMER_START)

    gameState = 'start'

    meteors = {}

    for i = 1, 2, 1 do
        local meteorPosition = math.random(2)
        local METEOR_SPEED = math.random(30, 50)

        if meteorPosition == 1 then
            meteors[i] = Meteor(0, math.random(VIRTUAL_WINDOW_HEIGHT - 40), 2, 2, METEOR_SPEED)
        else
            if meteorPosition == 2 then
                meteors[i] = Meteor(VIRTUAL_WINDOW_WIDTH, math.random(VIRTUAL_WINDOW_HEIGHT - 40), 2, 2, -METEOR_SPEED)
            end
        end
    end

end

-- resize function
function love.resize(w, h)
    Push:resize(w, h)
end

-- function that calculates all changes in the game
function love.update(dt)
    if love.keyboard.isDown('up') then
        player1.dy = -ROCKET_SPEED
    else
        if love.keyboard.isDown('down') then
            player1.dy = ROCKET_SPEED
        else
            player1.dy = 0
        end
    end

    if love.keyboard.isDown('a') then
        player2.dy = -ROCKET_SPEED
    else
        if love.keyboard.isDown('z') then
            player2.dy = ROCKET_SPEED
        else
            player2.dy = 0
        end
    end

    if gameState == 'play' then

        



        for i = 1, #(meteors), 1 do
            meteors[i]:update(dt)

            if meteors[i]:collision(player1) then
                player1:resetPlayer1()
            end
            if meteors[i]:collision(player2) then
                player2:resetPlayer2()
            end

        end
        player1:update(dt)
        player2:update(dt)

    end

end

-- checks for game starting and ending inputs
function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'

        else
            gameState = 'start'
        end
    end

end

-- display all the games items and texts
function love.draw()
    Push:start()

    love.graphics.clear(40, 45, 52, 255)
    if gameState == 'start' then
        love.graphics.printf('Welcome to the Space Race!', 0, 20, VIRTUAL_WINDOW_WIDTH, 'center')
        love.graphics.printf("Press enter to start the game !", 0, 30, VIRTUAL_WINDOW_WIDTH, 'center')
    else
        if gameState == 'play' then
        end
    end

    player1:render(newImage)
    player2:render(newImage)

    if gameState == 'play' then
        for i = 1, #(meteors), 1 do
            meteors[i]:render()
        end
    end
    -- Timer:render()
    Push:finish()
end
