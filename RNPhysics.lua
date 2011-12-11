------------------------------------------------------------------------------------------------------------------------
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
--
------------------------------------------------------------------------------------------------------------------------
module(..., package.seeall)

require("RNBody")
require("RNJoint")
require("RNFixture")


world = nil
units = nil
bodylist = {}
jointlist = {}
--if a collision listeners exists
--with this we can decide whether a fixture should be set for giving callback for collision
--if during his creation (true) or when the user sets a listener(see addEventListener function)
collisionListenerExists = false
--collision funcion's name
collisionHandlerName = nil









-----------------------------------------------------------------------
-- world settings-------------------------------------------------------
function start(value)
    if value ~= nil then
        print("noSleep not available at the moment")
    end
    world = MOAIBox2DWorld.new()
    world:setGravity(0, 10)
    world:start()
    world:setUnitsToMeters(0.06)
end

 	
function setTimeToSleep(value)
	if value~=nil then world:setTimeToSleep(value) else world:setTimeToSleep() end
end




function setLinearSleepTolerance()
	if value~=nil then world:setLinearSleepTolerance(value) else world:setLinearSleepTolerance() end
end




function setAngularSleepTolerance()
	if value~=nil then world:setAngularSleepTolerance(value) else world:setAngularSleepTolerance() end
end




function getAngularSleepTolerance()
	return world:getAngularSleepTolerance()
end




function getLinearSleepTolerance()
	return world:getAngularSleepTolerance()
end




function getTimeToSleep()
	return world:getAngularSleepTolerance()
end





function stop()
    world:stop()
end


function setGravity(xx, yy)
    world:setGravity(xx, yy)
end

function getGravity()
    local x, y = world:getGravity()
    return x, y
end

--change this after initialization won't fit sprites to bodies
function setMeters(meters)
    world:setUnitsToMeters(meters / 1000)
    units = meters
end


function setIterations(velocity, position)
    world:setIterations(velocity, position)
end

function getMeters()
    return units
end

function setAutoClearForces(boolean)
    world:setAutoClearForces(boolean)
end

function getAutoClearForces()
    return world:getAutoClearForces()
end


function getBodyList()
    return bodylist
end

-------------------------------------------------------------------
-- bodies section---------------------------------------------------
function createBodyFromImage(image, ...)

    --[[ We need x,y,h,w,name and prop from image . The name and image are stored
         in RNBody and the prop is used in RNBody:removeSelf()
         Just keep it in mind for future changes to rapanui or/and RapaNui
    --]]

    local Type, typeGiven, fixturesReceived --type,if type is given as first optional argumen,how many fixtures have been received
    local firstFixtureArgument --what is the first fixture/table arguments in the optional received
    --(it represents the first argument that is a fixture/table)

    --if there aren't any optional arguments
    if (arg.n == 0) then
        Type = "dynamic"
        firstFixtureArgument = nil
        typeGiven = false
    end

    --if there are
    if (arg.n > 0) then
        --if the first optional argument is the type
        if (arg[1] == "static") or (arg[1] == "dynamic") or (arg[1] == "kinematic") then
            Type = arg[1]
            firstFixtureArgument = 2
            typeGiven = true
            --if not
        else
            Type = "dynamic"
            firstFixtureArgument = 1
            typeGiven = false
        end
    end

    --how many fixtures have been received? (according to if the type has been received)
    if (typeGiven == true) then fixturesReceived = arg.n - 1 else fixturesReceived = arg.n end


    --adds bodies to the world
    local body

    --[[ Objects are created at 0,0 and then translated to the right position, over
  the image. --]]

    --checks for body type
    if (Type == "dynamic") then body = world:addBody(MOAIBox2DBody.DYNAMIC) end
    if (Type == "static") then body = world:addBody(MOAIBox2DBody.STATIC) end
    if (Type == "kinematic") then body = world:addBody(MOAIBox2DBody.KINEMATIC) end


    --get some image proprieties
    local xx, yy = image:getLocation()
    local h = image:getOriginalHeight()
    local w = image:getOriginalWidth()
    local bprop = image:getProp()
    local angle = image.rotation


    --creates the RNPhysics object
    local RNBody = RNBody:new()

    --brings the image to the origin in centered mode
    image:setX(0)
    image:setY(0)
    image.rotation = 0


    local fixture

    --Checks for fixtures received as additional arguments
    if (fixturesReceived ~= 0) then
        --for each  fixture/table received, starting with the first argument that is a table
        --we can make a for cycle until the last argumet (if the type has been specified, it has been
        --specified as first optional argument so the others until arg.n are all fixture/tables)
        for i = firstFixtureArgument, arg.n, 1 do
            --we create a fixture (a table) with the fixture/table received
            local tempFixture = RNFixture:new(arg[i])
            --sets default parameters if they aren't given
            if (tempFixture.density == nil) then tempFixture.density = 1 end
            if (tempFixture.friction == nil) then tempFixture.friction = 0.3 end
            if (tempFixture.restitution == nil) then tempFixture.restitution = 0 end
            if (tempFixture.filter == nil) then tempFixture.filter = { categoryBits = nil, maskBits = nil, groupIndex = nil } end
            if (tempFixture.sensor == nil) then tempFixture.sensor = false end
            if (tempFixture.shape == nil) and (tempFixture.radius == nil) then tempFixture.shape = "rectangle" elseif (tempFixture.shape == nil) and (tempFixture.radius ~= nil) then tempFixture.shape = "circle" end
            if (tempFixture.filter.categoryBits == nil) then tempFixture.filter.categoryBits = 1 end
            if (tempFixture.radius == nil) then tempFixture.radius = h / 2 end
            --adds the fixture shape to the body
            if (tempFixture.shape == "circle") then
                fixture = body:addCircle(0, 0,tempFixture.radius)
            elseif (tempFixture.shape == "rectangle") then
                fixture = body:addRect(-w / 2, -h / 2, w / 2, h / 2)
            else
                fixture = body:addPolygon(tempFixture.shape)
            end

            --sets the real box2d fixture as above
            fixture:setDensity(tempFixture.density)
            fixture:setFriction(tempFixture.friction)
            fixture:setRestitution(tempFixture.restitution)
            fixture:setSensor(tempFixture.sensor)
            fixture:setFilter(tempFixture.filter.categoryBits, tempFixture.filter.maskBits, tempFixture.filter.groupIndex)


            --gives RNFixture a name
            tempFixture.name = image.name

            --the fixture now stores the body which is connect+ed to
            tempFixture.parentBody = RNBody
            --this fixture should stay in the i place in the fixturelist (or in the i-1 place if the Type
            --has been specified). ex: if this is the first fixture received if typeGiven is false -->i=1
            --But  if typeGiven is true --> i=2! But this fixture is the first, so it should be the first
            --in the list. and so this fixture will be the
            --number i in the list if typeGiven is false and the number i-1 if it's true.
            if (typeGiven == true) then tempFixture.indexinlist = i - 1 else tempFixture.indexinlist = i end
            --and its native box2d fixture
            tempFixture.fixture = fixture
            --update the RNBody.fixturelist (check the comment 4 lines above)
            if (typeGiven == true) then RNBody.fixturelist[i - 1] = tempFixture else RNBody.fixturelist[i] = tempFixture end

            --if has been set a listener for collision(so the other fixtures have been set for
            --collision callbacks) also new fixtures should give a callback for collision!
            if (collisionListenerExists == true) then fixture:setCollisionHandler(CollisionHandling, MOAIBox2DArbiter.ALL) end
        end --end arg for

    elseif (fixturesReceived == 0) then --else arg[1]~=nil
        --if there aren't additional arguments
        --a default physic body is created
        fixture = body:addRect(-w / 2, -h / 2, w / 2, h / 2)
        fixture:setDensity(1)
        fixture:setFriction(0.3)
        fixture:setRestitution(0.0)
        fixture:setSensor(false)
        --default proprieties are given to the tempFixture table too
        local proprieties = { fixture = fixture, density = 1, friction = 0.3, restitution = 0, filter = { categoryBits = 1, maskBits = nil, groupIndex = nil }, sensor = false, shape = "rectangle" }
        --and to its filter
        tempFixture = RNFixture:new(proprieties)
        fixture:setFilter(tempFixture.filter.categoryBits, tempFixture.filter.maskBits, tempFixture.filter.groupIndex)
        --stores in the tempFixture table the RNBody which is connected to
        tempFixture.parentBody = RNBody
        tempFixture.indexinlist = 1
        --and update this RNBody.fixturelist (1 because this will be the
        --only whon fixture in this RNBody)
        RNBody.fixturelist[1] = tempFixture

        --gives RNFixture a name
        tempFixture.name = image.name


        --if has been set a listener for collision(so the other fixtures have been set for
        --collision callbacks) also new fixtures should give a callback for collision!
        if (collisionListenerExists == true) then fixture:setCollisionHandler(CollisionHandling, MOAIBox2DArbiter.ALL) end
    end --end if arg>0




    --adds the body to the bodylist
    len = table.getn(bodylist)
    bodylist[len + 1] = RNBody
    RNBody.indexinlist = len + 1



    --it resets the body mass
    body:resetMassData()





    --binds the image's prop to our body.
    bprop:setParent(body)

    --stores proprieties in RNPhysics object
    RNBody.sprite = image
    RNBody.body = body
    RNBody.type = Type
    RNBody.name = image.name
    RNBody.parentList = bodylist
    RNBody.collision = nil


    --traslate body to sprite position
    RNBody.x = xx
    RNBody.y = yy
    RNBody.rotation = angle


    --sets display object physic fields

    image.isPhysical = true
    image.physicObject = RNBody
    image.fixture = RNBody.fixturelist



    return RNBody
end







function createBodyFromMapObject(mapObject, ...)


    local Type, typeGiven, fixturesReceived --type,if type is given as first optional argumen,how many fixtures have been received
    local firstFixtureArgument --what is the first fixture/table arguments in the optional received
    --(it represents the first argument that is a fixture/table)

    --if there aren't any optional arguments
    if (arg.n == 0) then
        Type = "dynamic"
        firstFixtureArgument = nil
        typeGiven = false
    end

    --if there are
    if (arg.n > 0) then
        --if the first optional argument is the type
        if (arg[1] == "static") or (arg[1] == "dynamic") or (arg[1] == "kinematic") then
            Type = arg[1]
            firstFixtureArgument = 2
            typeGiven = true
            --if not
        else
            Type = "dynamic"
            firstFixtureArgument = 1
            typeGiven = false
        end
    end

    --how many fixtures have been received? (according to if the type has been received)
    if (typeGiven == true) then fixturesReceived = arg.n - 1 else fixturesReceived = arg.n end


    --adds bodies to the world
    local body

    --[[ Objects are created at 0,0 and then translated to the right position, over
  the image. --]]

    --checks for body type
    if (Type == "dynamic") then body = world:addBody(MOAIBox2DBody.DYNAMIC) end
    if (Type == "static") then body = world:addBody(MOAIBox2DBody.STATIC) end
    if (Type == "kinematic") then body = world:addBody(MOAIBox2DBody.KINEMATIC) end


    --get some image proprieties
    local xx=mapObject.x
    local yy=mapObject.y
    local h = mapObject.height
    local w = mapObject.width


    --creates the RNPhysics object
    local RNBody = RNBody:new()



    local fixture

    --Checks for fixtures received as additional arguments
    if (fixturesReceived ~= 0) then
        --for each  fixture/table received, starting with the first argument that is a table
        --we can make a for cycle until the last argumet (if the type has been specified, it has been
        --specified as first optional argument so the others until arg.n are all fixture/tables)
        for i = firstFixtureArgument, arg.n, 1 do
            --we create a fixture (a table) with the fixture/table received
            local tempFixture = RNFixture:new(arg[i])
            --sets default parameters if they aren't given
            if (tempFixture.density == nil) then tempFixture.density = 1 end
            if (tempFixture.friction == nil) then tempFixture.friction = 0.3 end
            if (tempFixture.restitution == nil) then tempFixture.restitution = 0 end
            if (tempFixture.filter == nil) then tempFixture.filter = { categoryBits = nil, maskBits = nil, groupIndex = nil } end
            if (tempFixture.sensor == nil) then tempFixture.sensor = false end
            if (tempFixture.shape == nil) and (tempFixture.radius == nil) then tempFixture.shape = "rectangle" elseif (tempFixture.shape == nil) and (tempFixture.radius ~= nil) then tempFixture.shape = "circle" end
            if (tempFixture.filter.categoryBits == nil) then tempFixture.filter.categoryBits = 1 end
            if (tempFixture.radius == nil) then tempFixture.radius = h / 2 end
            --adds the fixture shape to the body
            if (tempFixture.shape == "circle") then
                fixture = body:addCircle(0, 0,tempFixture.radius)
            elseif (tempFixture.shape == "rectangle") then
                fixture = body:addRect(-w / 2, -h / 2, w / 2, h / 2)
            else
                fixture = body:addPolygon(tempFixture.shape)
            end

            --sets the real box2d fixture as above
            fixture:setDensity(tempFixture.density)
            fixture:setFriction(tempFixture.friction)
            fixture:setRestitution(tempFixture.restitution)
            fixture:setSensor(tempFixture.sensor)
            fixture:setFilter(tempFixture.filter.categoryBits, tempFixture.filter.maskBits, tempFixture.filter.groupIndex)


            --gives RNFixture a name
            tempFixture.name = mapObject.name

            --the fixture now stores the body which is connect+ed to
            tempFixture.parentBody = RNBody
            --this fixture should stay in the i place in the fixturelist (or in the i-1 place if the Type
            --has been specified). ex: if this is the first fixture received if typeGiven is false -->i=1
            --But  if typeGiven is true --> i=2! But this fixture is the first, so it should be the first
            --in the list. and so this fixture will be the
            --number i in the list if typeGiven is false and the number i-1 if it's true.
            if (typeGiven == true) then tempFixture.indexinlist = i - 1 else tempFixture.indexinlist = i end
            --and its native box2d fixture
            tempFixture.fixture = fixture
            --update the RNBody.fixturelist (check the comment 4 lines above)
            if (typeGiven == true) then RNBody.fixturelist[i - 1] = tempFixture else RNBody.fixturelist[i] = tempFixture end

            --if has been set a listener for collision(so the other fixtures have been set for
            --collision callbacks) also new fixtures should give a callback for collision!
            if (collisionListenerExists == true) then fixture:setCollisionHandler(CollisionHandling, MOAIBox2DArbiter.ALL) end
        end --end arg for

    elseif (fixturesReceived == 0) then --else arg[1]~=nil
        --if there aren't additional arguments
        --a default physic body is created
        fixture = body:addRect(-w / 2, -h / 2, w / 2, h / 2)
        fixture:setDensity(1)
        fixture:setFriction(0.3)
        fixture:setRestitution(0.0)
        fixture:setSensor(false)
        --default proprieties are given to the tempFixture table too
        local proprieties = { fixture = fixture, density = 1, friction = 0.3, restitution = 0, filter = { categoryBits = 1, maskBits = nil, groupIndex = nil }, sensor = false, shape = "rectangle" }
        --and to its filter
        tempFixture = RNFixture:new(proprieties)
        fixture:setFilter(tempFixture.filter.categoryBits, tempFixture.filter.maskBits, tempFixture.filter.groupIndex)
        --stores in the tempFixture table the RNBody which is connected to
        tempFixture.parentBody = RNBody
        tempFixture.indexinlist = 1
        --and update this RNBody.fixturelist (1 because this will be the
        --only whon fixture in this RNBody)
        RNBody.fixturelist[1] = tempFixture

        --gives RNFixture a name
        tempFixture.name = mapObject.name


        --if has been set a listener for collision(so the other fixtures have been set for
        --collision callbacks) also new fixtures should give a callback for collision!
        if (collisionListenerExists == true) then fixture:setCollisionHandler(CollisionHandling, MOAIBox2DArbiter.ALL) end
    end --end if arg>0




    --adds the body to the bodylist
    len = table.getn(bodylist)
    bodylist[len + 1] = RNBody
    RNBody.indexinlist = len + 1



    --it resets the body mass
    body:resetMassData()



    --stores proprieties in RNPhysics object
    RNBody.body = body
    RNBody.type = Type
    RNBody.name = mapObject.name
    RNBody.parentList = bodylist
    RNBody.collision = nil


    --traslate body to sprite position
    RNBody.x = xx+w/2
    RNBody.y = yy+h/2




    return RNBody
end















------------------------------------------------------------------
-- debug draw section----------------------------------------------


--we need the layer from RNScene received
--keep it in mind for future changes
function setDebugDraw(screen)

    local layerfordebug = screen.layer
    len = table.getn(screen.sprites)
    for i = 1, len, 1 do
        screen.sprites[i].visible = false
    end
    layerfordebug:setBox2DWorld(world)
end















---------------------------------------------------------------------

----------------------- COLLISION HANDLER-----------------------------------------
function addEventListener(Type, funct)
    if (Type == "collision") then
        collisionHandlerName = funct
        --
        blist = bodylist
        len = table.getn(blist)
        --for each body in bodylist
        for i = 1, len, 1 do
            currentbody = blist[i]
            --and for each fixture in that body
            flist = currentbody.fixturelist
            flistlen = table.getn(flist)
            for k = 1, flistlen, 1 do
                --sets the fixture for callbacks
                currentfixture = flist[k].fixture
                currentfixture:setCollisionHandler(CollisionHandling, MOAIBox2DArbiter.ALL)
            end
        end
        collisionListenerExists = true
    end
end






---------------------------------- GLOBAL COLLISION HANDLER------------------------------------------------
function CollisionHandling(phase, fixtureA, fixtureB, arbiter)


    local blist, len, flist, flistlen, currentbody, currentfixture, body1, body2, currentphase, fixture1, fixture2, currentEvent
    --creates an event table(that will be passed to the callback function)
    currentEvent = { object1 = nil, object2 = nil, fixture1 = nil, fixture2 = nil, force = nil, friction = nil, phase = nil }
    --sets the received friction and force =~0 only in presolve and postsolve
    currentEvent.force = arbiter:getNormalImpulse()
    currentEvent.friction = arbiter:getNormalImpulse()

    --check for current phase
    if phase == MOAIBox2DArbiter.BEGIN then
        currentphase = "begin"
    end
    if phase == MOAIBox2DArbiter.END then
        currentphase = "end"
    end
    if phase == MOAIBox2DArbiter.PRE_SOLVE then
        currentphase = "pre_solve"
    end
    if phase == MOAIBox2DArbiter.POST_SOLVE then
        currentphase = "post_solve"
    end

    --checks for which fixtures in which bodies are colliding
    blist = bodylist
    len = table.getn(blist)
    --finds fixtureA name:
    --for each body in bodylist
    for i = 1, len, 1 do
        currentbody = blist[i]
        --and for each fixture in that body
        flist = currentbody.fixturelist
        flistlen = table.getn(flist)
        for k = 1, flistlen, 1 do
            currentfixture = flist[k].fixture
            --if the fixture is the right one envolved in this collision
            --stores in body1 the envolved fixture's parent RNBody.
            --and in fixture1 the tempFixture table of the fixture envolved.
            if (fixtureA == currentfixture) then body1 = currentbody fixture1 = flist[k] end
        end
    end

    --finds fixtureB name:
    --for each body in bodylist
    for i = 1, len, 1 do
        currentbody = blist[i]
        --and for each fixture in that body
        flist = currentbody.fixturelist
        flistlen = table.getn(flist)
        for k = 1, flistlen, 1 do
            currentfixture = flist[k].fixture
            --if the fixture is the right one envolved in this collision
            --stores in body2 the envolved fixture's parent RNBody.
            --and in fixture2 the tempFixture table of the fixture envolved.
            if (fixtureB == currentfixture) then body2 = currentbody fixture2 = flist[k] end
        end
    end

    --stores in the event table some things to pass to callback funcions
    currentEvent.phase = currentphase
    currentEvent.fixture1 = fixture1
    currentEvent.fixture2 = fixture2




    --if there is a function set for callback we sent it the event table
    --and if objects aren't nil
    if (body1 ~= nil) and (body2 ~= nil) then
        currentEvent.object1 = body1.sprite
        currentEvent.object2 = body2.sprite
        if (collisionHandlerName ~= nil) then
            local funct = collisionHandlerName
            if (funct ~= nil) then funct(currentEvent) end
        end
    end
end



------------------------- LOCAL COLLISION HANDLER-------------------------------------------------------
function LocalCollisionHandling(phase, fixtureA, fixtureB, arbiter)


    local blist, len, flist, flistlen, currentbody, currentfixture, body1, body2, currentphase, fixture1, fixture2, currentEvent
    --creates an event table(that will be passed to the callback function)
    currentEvent = { object1 = nil, object2 = nil, fixture1 = nil, fixture2 = nil, force = nil, friction = nil, phase = nil }
    --sets the received friction and force =~0 only in presolve and postsolve
    currentEvent.force = arbiter:getNormalImpulse()
    currentEvent.friction = arbiter:getNormalImpulse()

    --check for current phase
    if phase == MOAIBox2DArbiter.BEGIN then
        currentphase = "begin"
    end
    if phase == MOAIBox2DArbiter.END then
        currentphase = "end"
    end
    if phase == MOAIBox2DArbiter.PRE_SOLVE then
        currentphase = "pre_solve"
    end
    if phase == MOAIBox2DArbiter.POST_SOLVE then
        currentphase = "post_solve"
    end

    --checks for which fixtures in which bodies are colliding
    blist = bodylist
    len = table.getn(blist)
    --finds fixtureA name:
    --for each body in bodylist
    for i = 1, len, 1 do
        currentbody = blist[i]
        --and for each fixture in that body
        flist = currentbody.fixturelist
        flistlen = table.getn(flist)
        for k = 1, flistlen, 1 do
            currentfixture = flist[k].fixture
            --if the fixture is the right one envolved in this collision
            --stores in body1 the envolved fixture's parent RNBody.
            --and in fixture1 the tempFixture table of the fixture envolved.
            if (fixtureA == currentfixture) then body1 = currentbody fixture1 = flist[k] end
        end
    end

    --finds fixtureB name:
    --for each body in bodylist
    for i = 1, len, 1 do
        currentbody = blist[i]
        --and for each fixture in that body
        flist = currentbody.fixturelist
        flistlen = table.getn(flist)
        for k = 1, flistlen, 1 do
            currentfixture = flist[k].fixture
            --if the fixture is the right one envolved in this collision
            --stores in body2 the envolved fixture's parent RNBody.
            --and in fixture2 the tempFixture table of the fixture envolved.
            if (fixtureB == currentfixture) then body2 = currentbody fixture2 = flist[k] end
        end
    end

    --stores in the event table some things to pass to callback funcions
    currentEvent.phase = currentphase
    if body1 ~= nil then currentEvent.object1 = body1.sprite end
    if body2 ~= nil then currentEvent.object2 = body2.sprite end
    currentEvent.fixture1 = fixture1
    currentEvent.fixture2 = fixture2
    --we check the bodies for local collision handling set
    blist = bodylist
    len = table.getn(blist)
    --we create the event to send to the function stored in RNBody.collision
    localEvent = { phase = currentphase, self = nil, other = nil, selfFixture = nil, otherFixture = nil, force = currentEvent.force, friction = currentEvent.friction }
    --for each body in bodylist
    for i = 1, len, 1 do
        --if the body is involved in this collision
        if (blist[i] == body1) then
            --if collision is set and there aren't any nils
            if (blist[i].collision ~= nil) and (body1 ~= nil) and (body2 ~= nil) then
                localEvent.self = body1.sprite
                localEvent.other = body2.sprite
                localEvent.selfFixture = fixture1
                localEvent.otherFixture = fixture2
                blist[i].collision(localEvent.self, localEvent) --we call the function
            end

        elseif (blist[i] == body2) then
            if (blist[i].collision ~= nil) and (body1 ~= nil) and (body2 ~= nil) then
                localEvent.self = body2.sprite
                localEvent.other = body1.sprite
                localEvent.selfFixture = fixture2
                localEvent.otherFixture = fixture1
                blist[i].collision(localEvent.self, localEvent)
            end
        end
    end
end








------------------------------------------------------------------------------------
---------------------------- JOINTS------------------------------------------------
function createJoint(type, ...)

    local joint, bodyA, bodyB, anchorX, anchorY, anchorA_X, anchorA_Y, anchorB_X, anchorB_Y, axisA, axisB, groundAnchorA_X, groundAnchorA_Y, groundAnchorB_X, groundAnchorB_Y, ratio, targetX, targetY, frequency, damping, maxForce, maxTorque, maxLengthA, maxLengthB, jointA, jointB, frequencyHz, dampingRatio

    --revolute joint
    --(type,bodyA,bodyB,anchorX,anchorY)
    if (type == "revolute") then
        bodyA = arg[1].physicObject
        bodyB = arg[2].physicObject
        anchorX = arg[3]
        anchorY = arg[4]
        joint = world:addRevoluteJoint(bodyA.body, bodyB.body, anchorX, anchorY)
    end

    --distance joint
    --(type,bodyA,bodyB,anchorA_X.anchorA_Y,anchorB_X,anchorB_Y[,frequencyHz,dampingRatio])
    if (type == "distance") then
        bodyA = arg[1].physicObject
        bodyB = arg[2].physicObject
        anchorA_X = arg[3]
        anchorA_Y = arg[4]
        anchorB_X = arg[5]
        anchorB_Y = arg[6]
        frequency = arg[7]
        damping = arg[8]
        if (frequency == nil) then frequency = 30 end
        if (damping == nil) then damping = 0 end
        joint = world:addDistanceJoint(bodyA.body, bodyB.body, anchorA_X, anchorA_Y, anchorB_X, anchorB_Y, frequency, damping)
    end

    --prismatic joint
    --(type,bodyA,bodyB,anchorA_X,anchorA_Y,axisA,axisB)
    if (type == "prismatic") then
        bodyA = arg[1].physicObject
        bodyB = arg[2].physicObject
        anchorA_X = arg[3]
        anchorA_Y = arg[4]
        axisA = arg[5]
        axisB = arg[6]
        joint = world:addPrismaticJoint(bodyA.body, bodyB.body, anchorA_X, anchorA_Y, axisA, axisB)
    end

    --friction joint
    --(type,bodyA,bodyB,anchorX,anchorY[, number maxForce, number maxTorque ] )
    if (type == "friction") then
        bodyA = arg[1].physicObject
        bodyB = arg[2].physicObject
        anchorX = arg[3]
        anchorY = arg[4]
        maxForce = arg[5]
        maxTorque = arg[6]
        if (maxForce == nil) then maxForce = 1000000 end
        if (maxTorque == nil) then maxTorque = 1000000 end
        joint = world:addFrictionJoint(bodyA.body, bodyB.body, anchorX, anchorY, maxForce, maxTorque)
    end

    --weld joint
    --(type,bodyA,bodyB,anchorX,anchorY)
    if (type == "weld") then
        bodyA = arg[1].physicObject
        bodyB = arg[2].physicObject
        anchorX = arg[3]
        anchorY = arg[4]
        joint = world:addWeldJoint(bodyA.body, bodyB.body, anchorX, anchorY)
    end

    --wheel joint
    --(type,bodyA,bodyB,anchorX,anchorY,axisX,axisY)
    if (type == "wheel") then
        bodyA = arg[1].physicObject
        bodyB = arg[2].physicObject
        anchorX = arg[3]
        anchorY = arg[4]
        axisX = arg[5]
        axisY = arg[6]
        joint = world:addWheelJoint(bodyA.body, bodyB.body, anchorX, anchorY, axisX, axisY)
    end

    --pulley joint
    --(type,bodyA,bodyB,groundAnchorA_X,groundAnchorA_Y,groundAnchorB_X,groundAnchorB_Y,anchorA_X,anchorA_Y,anchorB_X,anchorB_Y,ratio,number maxLengthA, number maxLengthB )
    if (type == "pulley") then
        bodyA = arg[1].physicObject
        bodyB = arg[2].physicObject
        groundAnchorA_X = arg[3]
        groundAnchorA_Y = arg[4]
        groundAnchorB_X = arg[5]
        groundAnchorB_Y = arg[6]
        anchorA_X = arg[7]
        anchorA_Y = arg[8]
        anchorB_X = arg[9]
        anchorB_Y = arg[10]
        ratio = arg[11]
        maxLengthA = arg[12]
        maxLengthB = arg[13]
        if (maxLengthA == nil) then maxLengthA = 100 end
        if (maxLengthB == nil) then maxLengthB = 100 end
        joint = world:addPulleyJoint(bodyA.body, bodyB.body, groundAnchorA_X, groundAnchorA_Y, groundAnchorB_X, groundAnchorB_Y, anchorA_X, anchorA_Y, anchorB_X, anchorB_Y, ratio, maxLengthA, maxLengthB)
        
    end

    --gear joint
    --(type,jointA,jointB,ratio)
    if (type == "gear") then
        jointA = arg[1],joint
        jointB = arg[2].joint
        ratio = arg[3]
        joint = world:addGearJoint(jointA, jointB, ratio)
    end

    --mouse joint
    --(type,bodyA,bodyB,targetX,targetY,maxForce [,frequencyHz,dampingRatio ] )
    if (type == "mouse") then
        bodyA = arg[1].physicObject
        bodyB = arg[2].physicObject
        targetX = arg[3]
        targetY = arg[4]
        maxForce = arg[5]
        frequency = arg[6]
        dampingRatio = arg[7]
        if (frequency == nil) then frequency = 30 end
        if (dampingRatio == nil) then dampingRatio = 0.2 end

        joint = world:addMouseJoint(bodyA.body,bodyB.body, world, targetX, targetY, maxForce, frequencyHz, dampingRatio)
    end
    
    
    --rope joint
    --(type,bodyA,bodyB,maxLength,[,anchorAX,anchorAY,anchorBX,anchorBY])
    --function addRopeJoint ( MOAIBox2DWorld self, MOAIBox2DBody bodyA, MOAIBox2DBody bodyB, number maxLength [, number anchorAX, number anchorAY, number anchorBX, number anchorBY ] )
	if (type=="rope") then
	    bodyA=arg[1].physicObject
	    bodyB=arg[2].physicObject
	    maxLength=arg[3]
	    anchorAX=arg[4]
	    anchorAY=arg[5]
	    anchorBX=arg[6]
	    anchorBY=arg[7]
	    if (anchorAX==nil) then anchorAX=bodyA.x end
	    if (anchorAY==nil) then anchorAY=bodyA.y end
	    if (anchorBX==nil) then anchorBX=bodyB.x end
	    if (anchorBY==nil) then anchorBY=bodyB.y end
	
	    joint = world:addRopeJoint(bodyA,bodyB,maxLength,anchorAX,anchorAY,anchorBX,anchorBY)

	end

    --set RNJoint
    local RNJoint = RNJoint:new()
    RNJoint.joint = joint
    RNJoint.type = type
    RNJoint.bodyA = bodyA
    RNJoint.bodyB = bodyB
    RNJoint.parentList = jointlist
    --set specific proprieties for specific types of joint
    if (type == "pulley") then
        RNJoint.ratio = ratio
        RNJoint.anchorA_X = anchorA_X
        RNJoint.anchorA_Y = anchorA_Y
        RNJoint.anchorB_X = anchorB_X
        RNJoint.anchorB_Y = anchorB_Y
    end
    

    --add RNJoint to RNPhysics jointlist
    len = table.getn(jointlist)
    jointlist[len + 1] = RNJoint
    RNJoint.indexingloballist = len + 1

    if type ~= "gear" then
        --add RNJoint to bodyA.jointlist
        len = table.getn(bodyA.jointlist)
        bodyA.jointlist[len + 1] = RNJoint
        RNJoint.indexinbodyAlist = len + 1
        
		if type~= "mouse" then
        	--add RNJoint to bodyB.jointlist
        	len = table.getn(bodyB.jointlist)
        	bodyB.jointlist[len + 1] = RNJoint
        	RNJoint.indexinbodyBlist = len + 1
        end
    end
    

    return RNJoint
end

