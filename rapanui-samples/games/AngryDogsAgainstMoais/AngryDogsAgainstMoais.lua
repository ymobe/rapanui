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
-- Angry Dogs Against Moais!
-- start simulation
RNPhysics.start()


--global vars
canMove = false
moaisDestroyed = 0
shots = 0
startX = 0
startY = 0
-- we need to set cameras Y coordinate and 
-- create a cameraXOffset since viewport:setOffset(-1, 1) -> left top corner
cameraY = 0
cameraXOffset = -64-32
--button offset is needed to keep the button in correct position with the camera
buttonOffset = 160

--camera
camera = MOAICamera2D.new ()
RNFactory.screen.layer:setCamera(camera)

dog = nil
label = nil
label2 = nil
score = nil
lev = nil
button = nil

--groups
gameGroup = RNGroup:new()
gameGroup.x = 0; gameGroup.y = 0;


--create images
background = RNFactory.createImage("rapanui-samples/games/AngryDogsAgainstMoais/grass.png")
bounding = RNFactory.createImage("rapanui-samples/games/AngryDogsAgainstMoais/grass.png"); bounding.x = 0; bounding.y = 0;
gameGroup:insert(background)
gameGroup:insert(bounding)


--create a complex body for bounding handling (and set it as invisible)
fixture1 = { shape = { -50, -50, 0, -50, 0, 530, -50, 530 }, friction = 1 }
fixture2 = { shape = { 320 + 3000, -50, 370 + 3000, -50, 370 + 3000, 530, 320 + 3000, 530 }, friction = 1 }
fixture3 = { shape = { -50, 480, 370 + 3000, 480, 370 + 3000, 530, -50, 530 }, friction = 1 }
fixture4 = { shape = { -50, -50, 370 + 3000, -50, 370 + 3000, 0, -50, 0 }, friction = 1 }
RNPhysics.createBodyFromImage(bounding, "static", fixture1, fixture2, fixture3, fixture4)
bounding.visible = false

--local collision handling of moais objects
function onMoaiCollide(self, event)
    if (event.phase == "begin") and (dog.x > 1000) then
        if self.frame < 4 then
            self.frame = self.frame + 1
        else
            self:remove()
            moaisDestroyed = moaisDestroyed + 1
            lev:setText("" .. moaisDestroyed)
        end
    end
end


function create_level()
    --creating dog
    dog = RNFactory.createImage("rapanui-samples/games/AngryDogsAgainstMoais/dog.png"); dog.x = 100; dog.y = 400;
    local dogBody = RNPhysics.createBodyFromImage(dog, { shape = "circle", restitution = 0.4 })
    dogBody:setLinearDamping(0.3)      --diminishing speed
    dogBody:setAngularDamping(0.3)

    gameGroup:insert(dog)
    dog.name = "dog"
    --starting obstacle
    local obstacle = RNFactory.createImage("rapanui-samples/games/AngryDogsAgainstMoais/obstacle.png");
    obstacle.x = 100; obstacle.y = 500; obstacle.rotation = 90
    RNPhysics.createBodyFromImage(obstacle, "static")
    gameGroup:insert(obstacle)
    obstacle.name = "obstacle"
    --creating obstacles
    for j = 1, 3, 1 do
        for i = 1, 3, 1 do
            local obstacle = RNFactory.createImage("rapanui-samples/games/AngryDogsAgainstMoais/obstacle.png");
            obstacle.x = 1000 + i * 100; obstacle.y = 500 - j * 130; obstacle.rotation = 90
            RNPhysics.createBodyFromImage(obstacle, { density = 1 })
            gameGroup:insert(obstacle)
            obstacle.name = "obstacle"
        end
        for i = 1, 2, 1 do
            local obstacle = RNFactory.createImage("rapanui-samples/games/AngryDogsAgainstMoais/obstacle.png");
            obstacle.x = 1050 + i * 100; obstacle.y = 440 - j * 130; obstacle.rotation = 0
            RNPhysics.createBodyFromImage(obstacle, { density = 1 })
            gameGroup:insert(obstacle)
            obstacle.name = "obstacle"
        end
    end
    --creating moais
    for j = 1, 3, 1 do
        for i = 1, 2, 1 do
            local moais = RNFactory.createAnim("rapanui-samples/games/AngryDogsAgainstMoais/moaianim.png", 64, 64, 0, 0, 1, 1);
            moais.x = 1050 + i * 100; moais.y = 500 - j * 130; moais.rotation = 0
            RNPhysics.createBodyFromImage(moais, { shape = { -18, -30, 18, -30, 18, 30, -18, 30 }, restitution = 0.4, density = 0.1 })
            gameGroup:insert(moais)
            moais.collision = onMoaiCollide
            moais:addEventListener("collision")
            moais.name = "moaiObject"
        end
    end

    --create texts
    label = RNFactory.createText("Shots: ", { size = 20, top = 420, left = -60, width = 200, height = 50 })
    score = RNFactory.createText("0", { size = 20, top = 420, left = 100, width = 30, height = 50 })
    label2 = RNFactory.createText("Moais Destroyed: ", { size = 20, top = 440, left = -50, width = 300, height = 50 })
    lev = RNFactory.createText("0", { size = 20, top = 440, left = 200, width = 30, height = 50 })

    --create restart button
    button = RNFactory.createImage("rapanui-samples/games/AngryDogsAgainstMoais/restButt.png"); button.x = 160;
end









--handling touch
function screen_touch(event)
    local xx = event.x
    local yy = event.y
    local fx = event.x - dog.x
    local fy = event.y - dog.y
    local distance


    if event.phase == "began" then
        --restart button
        if (event.y < 50) then
            relocateBall()
            removeAll()
            create_level()
        end
        --sets the starting touch point
        if event.y > 50 then
            startX = event.x
            startY = event.y
            print("got start point, now drag and drop")
        end
    end
    if event.phase == "ended" then
        --shot the dog
        print("drop received, shooting...go dog, go!")
        distance = math.sqrt(math.pow(event.x - startX, 2) + math.pow(event.y - startY, 2))
        if canMove == true then
            dog:applyForce(fx * 999999 / 2, fy * 999999 / 2, dog.x, dog.y)
            shots = shots + 1
            score:setText("" .. shots)
        end
    end
end

--add touch listener
RNListeners:addEventListener("touch", screen_touch)



--handling enterFrame
function Step()
    --toggle movement possibility
    if math.abs(dog.linearVelocityX) < 0.2 and math.abs(dog.linearVelocityY) < 0.2 then
        canMove = true
    else
        canMove = false
    end

    --Restart and camera setting
    if dog.x > 2500 then
        relocateBall()
    else
        if (dog.x > 110 or dog.x < 90) and canMove == true then
            relocateBall()
        else
            if dog.x  < 2200 then
				camera:setLoc(dog.x+cameraXOffset,cameraY)
				local camx,camy=camera:getLoc()
				button.x = buttonOffset + camx 
            end
        end
    end
end

--add EnterFrame listener
RNListeners:addEventListener("enterFrame", Step)



--Debud Draw it if you want
--RNPhysics.setDebugDraw(RNFactory.screen)

--bring the ball back to start
function relocateBall()
    dog.x = 100
    dog.y = 400
    dog.rotation = 0
    dog.linearVelocityX = 0
    dog.linearVelocityY = 0
    dog.angularVelocity = 0
	camera:setLoc(cameraXOffset,cameraY)
end





--remove only level objects
function removeAll()
    local blist = RNPhysics.getBodyList()
    local toRemoveList = {}
    for i = 1, table.getn(blist), 1 do
        print(blist[i].name)
        if (blist[i].name == "moaiObject") or (blist[i].name == "obstacle") or (blist[i].name == "dog") then
            toRemoveList[table.getn(toRemoveList) + 1] = blist[i]
        end
    end

    for i = 1, table.getn(toRemoveList) do
        toRemoveList[i]:remove()
    end
    moaisDestroyed = 0
    shots = 0
    label:remove()
    label2:remove()
    score:remove()
    lev:remove()
    button:remove()
end

--create starting level
create_level()
