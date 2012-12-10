--[[
--
-- RapaNui
--
-- by Ymobe ltd  (http://ymobe.co.uk)
--
-- LICENSE:
--
-- RapaNui uses the Common Public Attribution License Version 1.0 (CPAL) http://www.opensource.org/licenses/cpal_1.0.
-- CPAL is an Open Source Initiative approved
-- license based on the Mozilla Public License, with the added requirement that you attribute
-- Moai (http://getmoai.com/) and RapaNui in the credits of your program.
]]

BALL_START_X = 50
BALL_START_Y = 200

paddle = RNFactory.createImage("rapanui-samples/games/brick2d/paddle.png")
paddle.y = 400

ball = RNFactory.createImage("rapanui-samples/games/brick2d/ball.png")
ball.x = BALL_START_X
ball.y = BALL_START_Y

back = RNFactory.createImage("images/background-purple.png")
back:sendToBottom()

bricks = {}

bricksInGame = 0

bricksBroken = 0

label = RNFactory.createText("Bricks broken: ", { size = 20, top = 440, left = 5, width = 200, height = 50 })
score = RNFactory.createText("", { size = 20, top = 440, left = 210, width = 30, height = 50 })

dir = nil
angle = nil

function init()
    dir = round(math.random() * 1);
    ball.speed = 2;

    if (dir == 1) then
        angle = 45;
    else
        angle = 135;
    end

    ball.xspeed = ball.speed * math.cos((angle) * math.pi / 180);
    ball.yspeed = ball.speed * math.sin((angle) * math.pi / 180);
end

function initBricks()
    local padding = 10
    local color = 1

    for col = 0, 5, 1 do
        for row = 0, 4, 1 do
            local aBrick = RNFactory.createImage("rapanui-samples/games/brick2d/brick" .. color .. ".png")
            aBrick.y = 50 + padding + (row * 10 + padding * row)
            aBrick.x = 25 + padding + (col * 40 + padding * col)
            bricks[string.format("%s%s", row, col)] = aBrick
            bricksInGame = bricksInGame + 1
        end
        color = color + 1
        if (color > 3) then
            color = 1
        end
    end
end

trn = RNTransition:new()

function collideBricks()
    local padding = 10
    for col = 0, 5, 1 do
        for row = 0, 4, 1 do
            local brick = bricks[string.format("%s%s", row, col)]
            if (brick ~= nil) then
                if (ball.y + 8 >= brick.y - 5 and ball.y - 8 <= brick.y + 5) and
                        (ball.x + 8 >= brick.x - 20 and ball.x - 8 <= brick.x + 20)
                then
                    bricks[string.format("%s%s", row, col)] = nil
                    trn:run(brick, { type = "scale", xScale = -1, yScale = -1, time = 500, onComplete = function() brick:remove() end })
                    trn:run(brick, { type = "alpha", alpha = 0, time = 400 })
                    bricksInGame = bricksInGame - 1
                    bricksBroken = bricksBroken + 1
                    score:setText("" .. bricksBroken)
                    return true
                end
            end
        end
    end

    if (bricksInGame == 0) then
        initBricks()
    end
end


function collidePad()

    if (ball.y >= paddle.y - 10 and ball.y <= paddle.y) and
            (ball.x >= paddle.x - 20 and ball.x <= paddle.x + 20)
    then
        return true
    end

    return false
end

function update(enterFrame)

    ball.x = ball.x + ball.xspeed;
    ball.y = ball.y + ball.yspeed;

    if ((ball.x <= 5) or (ball.x >= 320)) then
        ball.xspeed = -ball.xspeed;
    end

    if (collideBricks()) then
        ball.yspeed = -ball.yspeed;
    end

    if ((ball.y <= 5) or (collidePad())) then
        ball.yspeed = -ball.yspeed;
    end

    if (ball.y > paddle.y + 20) then
        trn:run(ball, { type = "alpha", alpha = 0, time = 500 })
    end

    if (ball.y > 480) then
        ball:setAlpha(1)
        ball.x = BALL_START_X;
        ball.y = BALL_START_Y;


        dir = round(math.random() * 1);
        speed = 2;
        if (dir == 1) then
            angle = 45;
        else
            angle = 135;
        end

        ball.xspeed = speed * math.cos((angle) * math.pi / 180);
        ball.yspeed = speed * math.sin((angle) * math.pi / 180);
    end
end


function round(num)
    if num >= 0 then
        return math.floor(num + .5)
    else
        return math.ceil(num - .5)
    end
end

function onTouchEvent(event)

    if event.phase == "began" then
        paddle.x = event.x
    end

    if event.phase == "moved" then
        paddle.x = event.x
    end
end

init()
initBricks()

RNListeners:addEventListener("enterFrame", update)
RNListeners:addEventListener("touch", onTouchEvent)


