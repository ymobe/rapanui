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

--SunGolf! MiniGolf physic based game
--start simulation
RNPhysics.start()
RNPhysics.setGravity(0, 0)

--global vars
canMove = true
canChangeLevel = false
shots = 0
level = 0

ball = nil
hole = nil
obstacle1 = nil
obstacle2 = nil
obstacle3 = nil

--add images
background = RNFactory.createImage("rapanui-samples/games/SunGolf/grass.png")
bounding = RNFactory.createImage("rapanui-samples/games/SunGolf/grass.png"); bounding.x = 0; bounding.y = 0;


--create a complex body for bounding handling (and set it as invisible)
fixture1 = { shape = { -50, -50, 0, -50, 0, 530, -50, 530 } }
fixture2 = { shape = { 320, -50, 370, -50, 370, 530, 320, 530 } }
fixture3 = { shape = { -50, 480, 370, 480, 370, 530, -50, 530 } }
fixture4 = { shape = { -50, -50, 370, -50, 370, 0, -50, 0 } }
RNPhysics.createBodyFromImage(bounding, "static", fixture1, fixture2, fixture3, fixture4)
bounding.visible = false



--create random level
function create_level()
    --add a level
    level = level + 1
    lev:setText("" .. level)
    canChangeLevel = true
    --create images
    hole = RNFactory.createImage("rapanui-samples/games/SunGolf/hole.png");
    hole.x = math.random() * 120 + 100; hole.y = 100
    ball = RNFactory.createImage("rapanui-samples/games/SunGolf/gball.png"); ball.x = 240; ball.y = 400;
    obstacle1 = RNFactory.createImage("rapanui-samples/games/SunGolf/obstacle.png");
    obstacle1.x = math.random() * 100 - 20; obstacle1.y = 140 + math.random() * 150; obstacle1.rotation = math.random() * 360;
    obstacle2 = RNFactory.createImage("rapanui-samples/games/SunGolf/obstacle.png");
    obstacle2.x = 160; obstacle2.y = 140 + math.random() * 150; obstacle2.rotation = math.random() * 360;
    obstacle3 = RNFactory.createImage("rapanui-samples/games/SunGolf/obstacle.png");
    obstacle3.x = math.random() * 100 + 280; obstacle3.y = 140 + math.random() * 150; obstacle3.rotation = math.random() * 360;

    --add physics bodies
    RNPhysics.createBodyFromImage(ball, { shape = "circle", restitution = 0.4 })
    RNPhysics.createBodyFromImage(obstacle1, "static")
    RNPhysics.createBodyFromImage(obstacle2, "static")
    RNPhysics.createBodyFromImage(obstacle3, "static")

    print("hole x:y: ", hole.x, hole.y)
end

trn = RNTransition:new()
function goNextLevel()
    --transition to before changing level
    trn:run(ball, { type = "scale", xScale = -1, yScale = -1, time = 800, onComplete = newLevel })
    trn:run(ball, { type = "alpha", alpha = 0, time = 800 })
end

function newLevel()
    --change level
    ball:remove()
    hole:remove()
    obstacle1:remove()
    obstacle2:remove()
    obstacle3:remove()
    create_level()
end


--Debud Draw it if you want
--RNPhysics.setDebugDraw(RNFactory.screen)


--handling touch
function screen_touch(event)
    if event.phase == "began" then
        local xx = event.x
        local yy = event.y
        local fx = event.x - ball.x
        local fy = event.y - ball.y
        local distance

        distance = math.sqrt(math.pow(event.x - ball.x, 2) + math.pow(event.y - ball.y, 2))
        if canMove == true then
            ball:applyForce(fx * 99999 * 2, fy * 99999 * 2, ball.x, ball.y)
            shots = shots + 1
            score:setText("" .. shots)
        end
    end
end

--add touch listener
RNListeners:addEventListener("touch", screen_touch)



--handling enterFrame
function Step()
    --diminishing speed
    if ball.linearVelocityX > 0 then
        ball.linearVelocityX = ball.linearVelocityX - 1
    end
    if ball.linearVelocityY > 0 then
        ball.linearVelocityY = ball.linearVelocityY - 1
    end

    if ball.linearVelocityX < 0 then
        ball.linearVelocityX = ball.linearVelocityX + 1
    end
    if ball.linearVelocityY < 0 then
        ball.linearVelocityY = ball.linearVelocityY + 1
    end
    if ball.angularVelocity > 0 then
        ball.angularVelocity = ball.angularVelocity - 1
    end
    if ball.angularVelocity < 0 then
        ball.angularVelocity = ball.angularVelocity + 1
    end
    if (ball.linearVelocityX > 0 and ball.linearVelocityX < 1) or (ball.linearVelocityX > -1 and ball.linearVelocityX < 0) then
        ball.linearVelocityX = 0
    end
    if (ball.linearVelocityY > 0 and ball.linearVelocityY < 1) or (ball.linearVelocityY > -1 and ball.linearVelocityY < 0) then
        ball.linearVelocityY = 0
    end
    --toggle movement possibility
    if ball.linearVelocityX > -1 and ball.linearVelocityX < 1 and ball.linearVelocityY > -1 and ball.linearVelocityY < 1 then
        canMove = true
    else
        canMove = false
    end
    --end level check
    local distance = math.sqrt(math.pow(hole.x - ball.x, 2) + math.pow(hole.y - ball.y, 2))
    if distance < 25 and canMove == true and canChangeLevel == true then
        goNextLevel()
        canChangeLevel = false
    end
end

--add EnterFrame listener
RNListeners:addEventListener("enterFrame", Step)



--create texts
label = RNFactory.createText("Shots: ", { size = 20, top = 420, left = -60, width = 200, height = 50 })
score = RNFactory.createText("0", { size = 20, top = 420, left = 100, width = 30, height = 50 })
label2 = RNFactory.createText("Level: ", { size = 20, top = 440, left = -60, width = 200, height = 50 })
lev = RNFactory.createText("1", { size = 20, top = 440, left = 100, width = 30, height = 50 })


--create starting level
create_level()