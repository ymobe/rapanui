--[[

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

RNPhysics = {}

RNPhysics.world = nil
RNPhysics.units = nil
RNPhysics.bodylist = {}
RNPhysics.jointlist = {}
--if a collision listeners exists
--with this we can decide whether a fixture should be set for giving callback for collision
--if during his creation (true) or when the user sets a listener(see addEventListener function)
RNPhysics.collisionListenerExists = false
--collision funcion's name
RNPhysics.collisionHandlerName = nil
--collision types allowed
RNPhysics.collisionTypeAllowed = MOAIBox2DArbiter.ALL


--- starts physics simulation
-- @param value boolean:optional value not available at the moment
function RNPhysics.start(value)
    if value ~= nil then
        print("noSleep not available at the moment")
    end
    RNPhysics.world = MOAIBox2DWorld.new()
    RNPhysics.world:setGravity(0, 10)
    RNPhysics.world:start()
    RNPhysics.world:setUnitsToMeters(0.06)
end

--- sets the sleeping time of physics objects
-- @param value number: time to sleep
function RNPhysics.setTimeToSleep(value)
    if value ~= nil then RNPhysics.world:setTimeToSleep(value) else RNPhysics.world:setTimeToSleep()
    end
end

--- sets the linear sleep tolerance
function RNPhysics.setLinearSleepTolerance()
    if value ~= nil then RNPhysics.world:setLinearSleepTolerance(value) else RNPhysics.world:setLinearSleepTolerance()
    end
end

--- sets the angular sleep tolerance
function RNPhysics.setAngularSleepTolerance()
    if value ~= nil then RNPhysics.world:setAngularSleepTolerance(value) else RNPhysics.world:setAngularSleepTolerance()
    end
end

--- gets the angular sleep tolerance
function RNPhysics.getAngularSleepTolerance()
    return RNPhysics.world:getAngularSleepTolerance()
end

--- gets the linear sleep tolerance
function RNPhysics.getLinearSleepTolerance()
    return RNPhysics.world:getAngularSleepTolerance()
end

--- gets the sleeping time
function RNPhysics.getTimeToSleep()
    return RNPhysics.world:getAngularSleepTolerance()
end

--- stops the physics simulation
function RNPhysics.stop()
    RNPhysics.world:stop()
end

--- sets the gravity
-- @param xx float: x axis gravity
-- @param yy float: y axis gravity
function RNPhysics.setGravity(xx, yy)
    RNPhysics.world:setGravity(xx, yy)
end

--- gets the gravity
-- @return table: x and y
function RNPhysics.getGravity()
    local x, y = RNPhysics.world:getGravity()
    return x, y
end

--change this after initialization won't fit sprites to bodies
--- sets meters to units
-- @param meters float: meters per box2d units
function RNPhysics.setMeters(meters)
    RNPhysics.world:setUnitsToMeters(meters / 1000)
    RNPhysics.units = meters
end

--- sets physics iterations (see box2d docs)
-- @param velocity float
-- @param position float
function RNPhysics.setIterations(velocity, position)
    RNPhysics.world:setIterations(velocity, position)
end

--- gets meters per units
-- @return units float
function RNPhysics.getMeters()
    return RNPhysics.units
end

--- see box2d docs
-- @param boolean boolean
function RNPhysics.setAutoClearForces(boolean)
    RNPhysics.world:setAutoClearForces(boolean)
end

--- see box2d docs
-- @return value
function RNPhysics.getAutoClearForces()
    return RNPhysics.world:getAutoClearForces()
end

--- gets the table list of the bodies in the physics world
-- @return table
function RNPhysics.getBodyList()
    return RNPhysics.bodylist
end


-- bodies section
--- creates a physics body from the given RNObject
-- @param image RNObject
-- @param ... additional properties: here you can specify the object's type<br>
-- and give tables for fixture's properties or just give tables for fixture's properties<br>
-- but the type should be given as first attribute.<br>
-- Example:<code> RNPhysics.createBodyFromImage(image,"dynamic",{restitution=0},{restitution=0.2},...)</code> or <br>
-- <code> RNPhysics.createBodyFromImage(image,{restitution=0},{restitution=2},...)</code>  <br>
-- image should be an RNObject,<br>
-- type can be "static","dynamic" or "kinematic" ("dynamic" by default) <br>
-- a property table should be like this:<br>
-- <code>{ density=1, friction =0.3, restitution = 0, filter ={groupIndex=1}, sensor=false,radius=1 shape = "rectangle" }</code> <br>
-- in which filter specifies categoryBits,maskBits,groupIndex like this:<br>
-- <code>filter={categoryBits=1,maskBits=1,groupIndex=1}</code> <br>
-- and shape can be <br>
-- <code>shape = "circle" , shape = "rectangle"</code> or a table of vertex in clockwise order like:<br>
-- <code>shape = { -32, 32 - 100, 32, 32 - 100, 0, 64 - 100 }</code> <br>
-- but usually we don't need to specify everything!
-- @usage <code> RNPhysics.createBodyFromImage(floor, "static", { density = 1, friction = 0.3, restitution = 0, sensor = false, shape = { -128, -16, 128, -16, 128, 16, -128, 16 } }, { density = 1, friction = 0.3, restitution = 0.5, sensor = false, shape = { -32, 32, 32, 32, 0, 64 } })<br>
-- RNPhysics.createBodyFromImage(box, "kinematic")<br>
-- RNPhysics.createBodyFromImage(box)<br>
-- RNPhysics.createBodyFromImage(ball, "dynamic", { density = 1, friction = 0.3, restitution = 0.8, sensor = false, radius = 21 })<br>
-- RNPhysics.createBodyFromImage(box,{ density = 1,restitution = 0.3})</code> <br>
-- by default values are: <br>
-- type="dynamic"<br>
-- density=1<br>
-- friction=0.3 <br>
-- restitution=0<br>
-- sensor=false <br>
-- radius= half of image size in box2d units<br>
-- shape="rectangle"<br>
-- filter={groupIndex=nil,categoryBits=1,maskBits=nil}<br>
function RNPhysics.createBodyFromImage(image, ...)

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
    if (typeGiven == true) then fixturesReceived = arg.n - 1 else fixturesReceived = arg.n
    end


    --adds bodies to the world
    local body

    --[[ Objects are created at 0,0 and then translated to the right position, over
  the image. --]]

    --checks for body type
    if (Type == "dynamic") then body = RNPhysics.world:addBody(MOAIBox2DBody.DYNAMIC)
    end
    if (Type == "static") then body = RNPhysics.world:addBody(MOAIBox2DBody.STATIC)
    end
    if (Type == "kinematic") then body = RNPhysics.world:addBody(MOAIBox2DBody.KINEMATIC)
    end


    --get some image proprieties
    local xx, yy = image:getLocation()
    local h = image:getOriginalHeight()
    local w = image:getOriginalWidth()
    local bprop = image:getProp()
    local angle = image.rotation


    --creates the RNPhysics object
    local aRNBody = RNBody:new()

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
            if (tempFixture.density == nil) then tempFixture.density = 1
            end
            if (tempFixture.friction == nil) then tempFixture.friction = 0.3
            end
            if (tempFixture.restitution == nil) then tempFixture.restitution = 0
            end
            if (tempFixture.filter == nil) then tempFixture.filter = { categoryBits = nil, maskBits = nil, groupIndex = nil }
            end
            if (tempFixture.sensor == nil) then tempFixture.sensor = false
            end
            if (tempFixture.shape == nil) and (tempFixture.radius == nil) then tempFixture.shape = "rectangle" elseif (tempFixture.shape == nil) and (tempFixture.radius ~= nil) then tempFixture.shape = "circle"
            end
            if (tempFixture.filter.categoryBits == nil) then tempFixture.filter.categoryBits = 1
            end
            if (tempFixture.radius == nil) then tempFixture.radius = h / 2
            end
            if (tempFixture.center == nil) then tempFixture.center = { x = 0, y = 0 }
            end

            --adds the fixture shape to the body
            if (tempFixture.shape == "circle") then
                fixture = body:addCircle(tempFixture.center.x, tempFixture.center.y, tempFixture.radius)
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
            if tempFixture.pe_fixture_id == nil then tempFixture.name = image.name else tempFixture.name = tempFixture.pe_fixture_id
            end

            --the fixture now stores the body which is connect+ed to
            tempFixture.parentBody = aRNBody
            fixture.parentBody = aRNBody
            --this fixture should stay in the i place in the fixturelist (or in the i-1 place if the Type
            --has been specified). ex: if this is the first fixture received if typeGiven is false -->i=1
            --But  if typeGiven is true --> i=2! But this fixture is the first, so it should be the first
            --in the list. and so this fixture will be the
            --number i in the list if typeGiven is false and the number i-1 if it's true.
            if (typeGiven == true) then tempFixture.indexinlist = i - 1 else tempFixture.indexinlist = i
            end
            --and its native box2d fixture
            tempFixture.fixture = fixture
            fixture.parentBody = aRNBody
            fixture.indexinlist = tempFixture.indexinlist
            --update the RNBody.fixturelist (check the comment 4 lines above)
            if (typeGiven == true) then aRNBody.fixturelist[i - 1] = tempFixture else aRNBody.fixturelist[i] = tempFixture
            end

            --if has been set a listener for collision(so the other fixtures have been set for
            --collision callbacks) also new fixtures should give a callback for collision!
            if (RNPhysics.collisionListenerExists == true) then fixture:setCollisionHandler(RNPhysics.CollisionHandling, RNPhysics.collisionTypeAllowed)
            end
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
        local tempFixture = RNFixture:new(proprieties)
        fixture:setFilter(tempFixture.filter.categoryBits, tempFixture.filter.maskBits, tempFixture.filter.groupIndex)
        --stores in the tempFixture table the RNBody which is connected to
        tempFixture.parentBody = aRNBody
        fixture.parentBody = aRNBody
        tempFixture.indexinlist = 1
        fixture.indexinlist = 1
        --and update this RNBody.fixturelist (1 because this will be the
        --only whon fixture in this RNBody)
        aRNBody.fixturelist[1] = tempFixture

        --gives RNFixture a name
        if tempFixture.pe_fixture_id == nil then tempFixture.name = image.name else tempFixture.name = tempFixture.pe_fixture_id
        end


        --if has been set a listener for collision(so the other fixtures have been set for
        --collision callbacks) also new fixtures should give a callback for collision!
        if (RNPhysics.collisionListenerExists == true) then fixture:setCollisionHandler(RNPhysics.CollisionHandling, RNPhysics.collisionTypeAllowed)
        end
    end --end if arg>0




    --adds the body to the RNPhysics.bodylist
    local len = table.getn(RNPhysics.bodylist)
    RNPhysics.bodylist[len + 1] = aRNBody
    aRNBody.indexinlist = len + 1



    --it resets the body mass
    body:resetMassData()





    --binds the image's prop to our body.
    bprop:setParent(body)

    --stores proprieties in RNPhysics object
    aRNBody.sprite = image
    aRNBody.body = body
    aRNBody.type = Type
    aRNBody.name = image.name
    aRNBody.parentList = RNPhysics.bodylist
    aRNBody.collision = nil


    --traslate body to sprite position
    aRNBody.x = xx
    aRNBody.y = yy
    aRNBody.rotation = angle


    --sets display object physic fields

    image.isPhysical = true
    image.physicObject = aRNBody
    image.fixture = aRNBody.fixturelist



    return aRNBody
end


function RNPhysics.createBodyFromMapObject(mapObject, ...)


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
    if (typeGiven == true) then fixturesReceived = arg.n - 1 else fixturesReceived = arg.n
    end


    --adds bodies to the world
    local body

    --[[ Objects are created at 0,0 and then translated to the right position, over
  the image. --]]

    --checks for body type
    if (Type == "dynamic") then body = RNPhysics.world:addBody(MOAIBox2DBody.DYNAMIC)
    end
    if (Type == "static") then body = RNPhysics.world:addBody(MOAIBox2DBody.STATIC)
    end
    if (Type == "kinematic") then body = RNPhysics.world:addBody(MOAIBox2DBody.KINEMATIC)
    end


    --get some image proprieties
    local xx = mapObject.x
    local yy = mapObject.y
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
            if (tempFixture.density == nil) then tempFixture.density = 1
            end
            if (tempFixture.friction == nil) then tempFixture.friction = 0.3
            end
            if (tempFixture.restitution == nil) then tempFixture.restitution = 0
            end
            if (tempFixture.filter == nil) then tempFixture.filter = { categoryBits = nil, maskBits = nil, groupIndex = nil }
            end
            if (tempFixture.sensor == nil) then tempFixture.sensor = false
            end
            if (tempFixture.shape == nil) and (tempFixture.radius == nil) then tempFixture.shape = "rectangle" elseif (tempFixture.shape == nil) and (tempFixture.radius ~= nil) then tempFixture.shape = "circle"
            end
            if (tempFixture.filter.categoryBits == nil) then tempFixture.filter.categoryBits = 1
            end
            if (tempFixture.radius == nil) then tempFixture.radius = h / 2
            end
            --adds the fixture shape to the body
            if (tempFixture.shape == "circle") then
                fixture = body:addCircle(0, 0, tempFixture.radius)
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
            fixture.parentBody = aRNBody
            --this fixture should stay in the i place in the fixturelist (or in the i-1 place if the Type
            --has been specified). ex: if this is the first fixture received if typeGiven is false -->i=1
            --But  if typeGiven is true --> i=2! But this fixture is the first, so it should be the first
            --in the list. and so this fixture will be the
            --number i in the list if typeGiven is false and the number i-1 if it's true.
            if (typeGiven == true) then tempFixture.indexinlist = i - 1 else tempFixture.indexinlist = i
            end
            fixture.indexinlist = tempFixture.indexinlist
            --and its native box2d fixture
            tempFixture.fixture = fixture
            --update the RNBody.fixturelist (check the comment 4 lines above)
            if (typeGiven == true) then RNBody.fixturelist[i - 1] = tempFixture else RNBody.fixturelist[i] = tempFixture
            end

            --if has been set a listener for collision(so the other fixtures have been set for
            --collision callbacks) also new fixtures should give a callback for collision!
            if (collisionListenerExists == true) then fixture:setCollisionHandler(CollisionHandling, RNPhysics.collisionTypeAllowed)
            end
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
        local tempFixture = RNFixture:new(proprieties)
        fixture:setFilter(tempFixture.filter.categoryBits, tempFixture.filter.maskBits, tempFixture.filter.groupIndex)
        --stores in the tempFixture table the RNBody which is connected to
        tempFixture.parentBody = RNBody
        fixture.parentBody = RNBody
        tempFixture.indexinlist = 1
        fixture.indexinlist = 1
        --and update this RNBody.fixturelist (1 because this will be the
        --only whon fixture in this RNBody)
        RNBody.fixturelist[1] = tempFixture

        --gives RNFixture a name
        tempFixture.name = mapObject.name


        --if has been set a listener for collision(so the other fixtures have been set for
        --collision callbacks) also new fixtures should give a callback for collision!
        if (RNPhysics.collisionListenerExists == true) then fixture:setCollisionHandler(CollisionHandling, RNPhysics.collisionTypeAllowed)
        end
    end --end if arg>0




    --adds the body to the RNPhysics.bodylist
    local len = table.getn(RNPhysics.bodylist)
    RNPhysics.bodylist[len + 1] = RNBody
    RNBody.indexinlist = len + 1



    --it resets the body mass
    body:resetMassData()



    --stores proprieties in RNPhysics object
    RNBody.body = body
    RNBody.type = Type
    RNBody.name = mapObject.name
    RNBody.parentList = RNPhysics.bodylist
    RNBody.collision = nil


    --traslate body to sprite position
    RNBody.x = xx + w / 2
    RNBody.y = yy + h / 2




    return RNBody
end


-- debug draw section

--we need the layer from RNScene received
--keep it in mind for future changes

--- Set the debug draw for the given screen (sprites drawn after this will be drawn over the debug draw image)
-- @param screen screen: the RNFactory screen
-- @usage RNPhysics.setDebugDraw(RNFactory.screen)
function RNPhysics.setDebugDraw(screen)

    local layerfordebug = screen.layer
    --    local len = table.getn(screen.sprites)
    --    for i, sprite in pairs(screen.sprites) do
    --        --sprite.visible = false
    --        --in general, assigning visibility doesnt work at all
    --    end
    --for i = 1, len, 1 do
    -- screen.sprites[i].visible = false;
    --end
    layerfordebug:setBox2DWorld(RNPhysics.world)
end


function RNPhysics.setCollisions(type)
    if type == "all" then
        RNPhysics.collisionTypeAllowed = MOAIBox2DArbiter.ALL
    end
    if type == "begin" then
        RNPhysics.collisionTypeAllowed = MOAIBox2DArbiter.BEGIN
    end
    if type == "end" then
        RNPhysics.collisionTypeAllowed = MOAIBox2DArbiter.END
    end
    if type == "pre_solve" then
        RNPhysics.collisionTypeAllowed = MOAIBox2DArbiter.PRE_SOLVE
    end
    if type == "post_solve" then
        RNPhysics.collisionTypeAllowed = MOAIBox2DArbiter.POST_SOLVE
    end
end


-- COLLISION HANDLER
function RNPhysics.addEventListener(Type, funct)
    if (Type == "collision") then
        RNPhysics.collisionHandlerName = funct
        --
        local blist = RNPhysics.bodylist
        local len = table.getn(blist)
        --for each body in RNPhysics.bodylist
        for i = 1, len, 1 do
            local currentbody = blist[i]
            --and for each fixture in that body
            local flist = currentbody.fixturelist
            local flistlen = table.getn(flist)
            for k = 1, flistlen, 1 do
                --sets the fixture for callbacks
                local currentfixture = flist[k].fixture
                currentfixture:setCollisionHandler(RNPhysics.CollisionHandling, RNPhysics.collisionTypeAllowed)
            end
        end
        RNPhysics.collisionListenerExists = true
    end
end


-- GLOBAL COLLISION HANDLER
function RNPhysics.CollisionHandling(phase, fixtureA, fixtureB, arbiter)

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


    body1 = fixtureA.parentBody
    fixture1 = fixtureA
    body2 = fixtureB.parentBody
    fixture2 = fixtureB

    --stores in the event table some things to pass to callback funcions
    currentEvent.phase = currentphase
    currentEvent.fixture1 = fixture1
    currentEvent.fixture2 = fixture2




    --if there is a function RNPhysics.set for callback we sent it the event table
    --and if objects aren't nil
    if (body1 ~= nil) and (body2 ~= nil) then
        currentEvent.object1 = body1.sprite
        currentEvent.object2 = body2.sprite
        if (RNPhysics.collisionHandlerName ~= nil) then
            local funct = RNPhysics.collisionHandlerName
            if (funct ~= nil) then funct(currentEvent)
            end
        end
    end
end


-- LOCAL COLLISION HANDLER
function RNPhysics.LocalCollisionHandling(phase, fixtureA, fixtureB, arbiter)


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


    body1 = fixtureA.parentBody
    fixture1 = fixtureA
    body2 = fixtureB.parentBody
    fixture2 = fixtureB

    --stores in the event table some things to pass to callback funcions
    currentEvent.phase = currentphase
    if body1 ~= nil then currentEvent.object1 = body1.sprite
    end
    if body2 ~= nil then currentEvent.object2 = body2.sprite
    end
    currentEvent.fixture1 = fixture1
    currentEvent.fixture2 = fixture2
    --we check the bodies for local collision handling set
    blist = RNPhysics.bodylist
    len = table.getn(blist)
    --we create the event to send to the function RNPhysics.stored in RNBody.collision
    local localEvent = { phase = currentphase, self = nil, other = nil, selfFixture = nil, otherFixture = nil, force = currentEvent.force, friction = currentEvent.friction }
    --for each body in RNPhysics.bodylist
    --if the body is involved in this collision
    --if collision is set and there aren't any nils
    if (body1.collision ~= nil) and (body1 ~= nil) and (body2 ~= nil) then
        localEvent.self = body1.sprite
        localEvent.other = body2.sprite
        localEvent.selfFixture = fixture1
        localEvent.otherFixture = fixture2
        body1.collision(localEvent.self, localEvent) --we call the function
    end

    --    if (body2.collision ~= nil) and (body1 ~= nil) and (body2 ~= nil) then
    --        localEvent.self = body2.sprite
    --        localEvent.other = body1.sprite
    --        localEvent.selfFixture = fixture2
    --        localEvent.otherFixture = fixture1
    --        body2.collision(localEvent.self, localEvent)
    --    end
end


-- JOINTS
function RNPhysics.createJoint(type, ...)

    local joint, bodyA, bodyB, anchorX, anchorY, anchorA_X, anchorA_Y, anchorB_X, anchorB_Y, axisA, axisB, groundAnchorA_X, groundAnchorA_Y, groundAnchorB_X, groundAnchorB_Y, ratio, targetX, targetY, frequency, damping, maxForce, maxTorque, maxLengthA, maxLengthB, jointA, jointB, frequencyHz, dampingRatio

    --revolute joint
    --(type,bodyA,bodyB,anchorX,anchorY)
    if (type == "revolute") then
        bodyA = arg[1].physicObject
        bodyB = arg[2].physicObject
        anchorX = arg[3]
        anchorY = arg[4]
        joint = RNPhysics.world:addRevoluteJoint(bodyA.body, bodyB.body, anchorX, anchorY)
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
        if (frequency == nil) then frequency = 30
        end
        if (damping == nil) then damping = 0
        end
        joint = RNPhysics.world:addDistanceJoint(bodyA.body, bodyB.body, anchorA_X, anchorA_Y, anchorB_X, anchorB_Y, frequency, damping)
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
        joint = RNPhysics.world:addPrismaticJoint(bodyA.body, bodyB.body, anchorA_X, anchorA_Y, axisA, axisB)
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
        if (maxForce == nil) then maxForce = 1000000
        end
        if (maxTorque == nil) then maxTorque = 1000000
        end
        joint = RNPhysics.world:addFrictionJoint(bodyA.body, bodyB.body, anchorX, anchorY, maxForce, maxTorque)
    end

    --weld joint
    --(type,bodyA,bodyB,anchorX,anchorY)
    if (type == "weld") then
        bodyA = arg[1].physicObject
        bodyB = arg[2].physicObject
        anchorX = arg[3]
        anchorY = arg[4]
        joint = RNPhysics.world:addWeldJoint(bodyA.body, bodyB.body, anchorX, anchorY)
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
        joint = RNPhysics.world:addWheelJoint(bodyA.body, bodyB.body, anchorX, anchorY, axisX, axisY)
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
        if (maxLengthA == nil) then maxLengthA = 100
        end
        if (maxLengthB == nil) then maxLengthB = 100
        end
        joint = RNPhysics.world:addPulleyJoint(bodyA.body, bodyB.body, groundAnchorA_X, groundAnchorA_Y, groundAnchorB_X, groundAnchorB_Y, anchorA_X, anchorA_Y, anchorB_X, anchorB_Y, ratio, maxLengthA, maxLengthB)
    end

    --gear joint
    --(type,jointA,jointB,ratio)
    if (type == "gear") then
        jointA = arg[1], joint
        jointB = arg[2].joint
        ratio = arg[3]
        joint = RNPhysics.world:addGearJoint(jointA, jointB, ratio)
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
        if (frequency == nil) then frequency = 30
        end
        if (dampingRatio == nil) then dampingRatio = 0.2
        end

        joint = RNPhysics.world:addMouseJoint(bodyA.body, bodyB.body, RNPhysics.world, targetX, targetY, maxForce, frequencyHz, dampingRatio)
    end


    --rope joint
    --(type,bodyA,bodyB,maxLength,[,anchorAX,anchorAY,anchorBX,anchorBY])
    --function RNPhysics.addRopeJoint ( MOAIBox2DWorld self, MOAIBox2DBody bodyA, MOAIBox2DBody bodyB, number maxLength [, number anchorAX, number anchorAY, number anchorBX, number anchorBY ] )
    if (type == "rope") then
        bodyA = arg[1].physicObject
        bodyB = arg[2].physicObject
        maxLength = arg[3]
        anchorAX = arg[4]
        anchorAY = arg[5]
        anchorBX = arg[6]
        anchorBY = arg[7]
        -- Those are real settings according to box2d:
        --        if (anchorAX == nil) then anchorAX = bodyA.x
        --        end
        --        if (anchorAY == nil) then anchorAY = bodyA.y
        --        end
        --        if (anchorBX == nil) then anchorBX = bodyB.x
        --        end
        --        if (anchorBY == nil) then anchorBY = bodyB.y
        --        end
        -- Those are temporary settings according to MOAI bug:
        if (anchorAX == nil) then anchorAX = 0
        end
        if (anchorAY == nil) then anchorAY = 0
        end
        if (anchorBX == nil) then anchorBX = 0
        end
        if (anchorBY == nil) then anchorBY = 0
        end
        joint = RNPhysics.world:addRopeJoint(bodyA.body, bodyB.body, maxLength, anchorAX, anchorAY, anchorBX, anchorBY)
        joint:destroy()
    end

    --set RNJoint
    local RNJoint = RNJoint:new()
    RNJoint.joint = joint
    RNJoint.type = type
    RNJoint.bodyA = bodyA
    RNJoint.bodyB = bodyB
    RNJoint.parentList = RNPhysics.jointlist
    --set specific proprieties for specific types of joint
    if (type == "pulley") then
        RNJoint.ratio = ratio
        RNJoint.anchorA_X = anchorA_X
        RNJoint.anchorA_Y = anchorA_Y
        RNJoint.anchorB_X = anchorB_X
        RNJoint.anchorB_Y = anchorB_Y
    end


    --add RNJoint to RNPhysics RNPhysics.jointlist
    local len = table.getn(RNPhysics.jointlist)
    RNPhysics.jointlist[len + 1] = RNJoint
    RNJoint.indexingloballist = len + 1

    if type ~= "gear" then
        --add RNJoint to bodyA.RNPhysics.jointlist
        len = table.getn(bodyA.jointlist)
        bodyA.jointlist[len + 1] = RNJoint
        RNJoint.indexinbodyAlist = len + 1

        if type ~= "mouse" then
            --add RNJoint to bodyB.RNPhysics.jointlist
            len = table.getn(bodyB.jointlist)
            bodyB.jointlist[len + 1] = RNJoint
            RNJoint.indexinbodyBlist = len + 1
        end
    end


    return RNJoint
end

return RNPhysics

