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
    love.window.setTitle('Space Race')

    smallFont = love.graphics.newFont('font.ttf', 8)
    bigFont = love.graphics.newFont('font.ttf', 14)
    scoreFont = love.graphics.newFont('font.ttf', 30)

    -- create the rocket image 
    newImage = love.graphics.newImage('spaceship.png', {
        dpiscale = 1,
        linear = true
    })

    love.graphics.setFont(smallFont)

    Push:setupScreen(VIRTUAL_WINDOW_WIDTH, VIRTUAL_WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true,
        resizable = true,
        vsync = true,
        canvas = false
    })

    -- create the rocket objects for the two players
    player1 = Rocket(VIRTUAL_WINDOW_WIDTH / 2 - 30, VIRTUAL_WINDOW_HEIGHT - 20)
    player2 = Rocket(VIRTUAL_WINDOW_WIDTH / 2 + 30, VIRTUAL_WINDOW_HEIGHT - 20)

    playerScore1 = 0
    playerScore2 = 0

    Timer = Timer(VIRTUAL_WINDOW_WIDTH / 2, VIRTUAL_WINDOW_HEIGHT, 2, TIMER_START)

    -- array thats gonna hold all the meteor objects
    meteors = {}

    -- for loop decides how many meteorites you want to have on the screen
    for i = 1, 30, 1 do
        local meteorPosition = math.random(2) -- decides if the meteorites are gonna come from the left or from the right
        local METEOR_SPEED = math.random(30, 50) -- assign random meteor speeds 

        if meteorPosition == 1 then -- they come from the left (spawn them at x=0 )
            -- these meteor objects spawn at a random height 
            meteors[i] = Meteor(0, math.random(VIRTUAL_WINDOW_HEIGHT - 60), math.random(2, 4), math.random(2, 4),
                METEOR_SPEED) -- create meteor objects that we store in an array
        else
            if meteorPosition == 2 then -- they come from the right (spawn them at x = screenwidth)
                meteors[i] = Meteor(VIRTUAL_WINDOW_WIDTH, math.random(VIRTUAL_WINDOW_HEIGHT - 60), math.random(2, 4),
                    math.random(2, 4), -METEOR_SPEED)
            end
        end
    end

    gameState = 'start'

end

-- resize function
function love.resize(w, h)
    Push:resize(w, h)
end

-- function that calculates all changes in the game
function love.update(dt)
    -- rocket movement player1 
    if love.keyboard.isDown('a') then
        player1.dy = -ROCKET_SPEED
    else
        if love.keyboard.isDown('z') then
            player1.dy = ROCKET_SPEED
        else
            player1.dy = 0
        end
    end
    -- rocket movement player 2
    if love.keyboard.isDown('up') then
        player2.dy = -ROCKET_SPEED
    else
        if love.keyboard.isDown('down') then
            player2.dy = ROCKET_SPEED
        else
            player2.dy = 0
        end
    end

    if gameState == 'play' then

        for i = 1, #(meteors), 1 do
            -- for each meteor  call the update function that gives them their speed
            meteors[i]:update(dt)

            -- for each meteor check if they collide with one of the rockets
            if meteors[i]:collision(player1) then
                player1:resetPlayer1()
            end
            if meteors[i]:collision(player2) then
                player2:resetPlayer2()
            end

        end
        -- continually update the rockets positions
        player1:update(dt)
        player2:update(dt)

        -- if statements to check who wins
        -- if leaves screen we consider that you win and score increments by 1
        if player2.y + 5 <= 0 then
            playerScore2 = playerScore2 + 1
            -- reset the player to his original position once he wins
            player2:resetPlayer2()
        end
        if player1.y + 5 <= 0 then
            playerScore1 = playerScore1 + 1
            player1:resetPlayer1()
        end

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
            love.graphics.setFont(smallFont)
        end
    end

end

-- display all the games items and texts
function love.draw()
    Push:start()

    love.graphics.clear(40, 45, 52, 255)
    if gameState == 'start' then
        love.graphics.printf('Welcome to the Space Race!', 0, 20, VIRTUAL_WINDOW_WIDTH, 'center')
        love.graphics.printf("Press enter to start the game !", 0, VIRTUAL_WINDOW_HEIGHT / 2, VIRTUAL_WINDOW_WIDTH,
            'center')

    end
    if gameState == 'play' then
        -- render all the meteors that have been created in the array on the screen 
        for i = 1, #(meteors), 1 do
            meteors[i]:render()
        end

        displayScore()
        -- render the rocket png for the players
        player1:render(newImage)
        player2:render(newImage)
    end

    Push:finish()
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.setColor(0, 255, 255, 255)
    love.graphics.print(tostring(playerScore1), 5, VIRTUAL_WINDOW_HEIGHT - 40)
    love.graphics.print(tostring(playerScore2), VIRTUAL_WINDOW_WIDTH - 23, VIRTUAL_WINDOW_HEIGHT - 40)

end
