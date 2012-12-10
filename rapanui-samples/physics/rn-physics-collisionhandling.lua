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

--Collision callbacks handling



--add images
background = RNFactory.createImage("rapanui-samples/physics/background-purple.png")
box = RNFactory.createImage("rapanui-samples/physics/box.png"); box.x = 170; box.y = 80;
ball = RNFactory.createImage("rapanui-samples/physics/ball.png"); ball.x = 240; ball.y = 80;
triangle = RNFactory.createImage("rapanui-samples/physics/poly.png"); triangle.x = 80; triangle.y = 80; triangle.rotation = 190
floor = RNFactory.createImage("rapanui-samples/physics/floor.png"); floor.x = 160; floor.y = 400;

--starts simulation
RNPhysics.start()

--filter collisions
--you may want to set a global filter for collision types: all, begin, end, pre_solve or post_solve
--to register all fixtures in the game to call back only for one kind of collision (to optimize game speed)
--by default its set to "all"
RNPhysics.setCollisions("all")  --optional



--set images as physics objects
RNPhysics.createBodyFromImage(box)
RNPhysics.createBodyFromImage(ball, { shape = "circle" })
RNPhysics.createBodyFromImage(triangle, { shape = { -32, 32, 0, -32, 32, 32 }, restitution = 0.3, friction = 0.1 })
RNPhysics.createBodyFromImage(floor, "static")
box.name = "box"
ball.name = "ball"
triangle.name = "triangle"
floor.name = "floor"
box.restitution = 0.5
ball.restitution = 0.3
triangle.restitution = 0.3



-- global collision handling


--how to do collision handling:
--simply create a function for collision's callbacks
function onCollide(event)
    --print things (if objects are still there after collision)
    --only in pre_solve and post_solve phase event can find a force and a friction
    if (event.phase == "begin") then
        print(event.phase .. " collision between fixture number " .. event.fixture1.indexinlist .. " of " .. event.object1.name .. " and fixture number " .. event.fixture2.indexinlist .. " of " .. event.object2.name .. "---with a force of " .. event.force .. " and a friction of " .. event.friction)
        if (event.object1 == ball) and (event.object2 == floor) then ball:remove() end
    end
    --remove the  ball at floor collision
end

--and set it for receiveing callbacks
RNPhysics.addEventListener("collision", onCollide)


-- local collision handling

--create a function for collision's callbacks
function onLocalCollide(self, event)
    if (event.self ~= nil) and (event.other ~= nil) and (event.phase == "begin") then
        print("Hi, I'm a " .. self.name .. " and im calling a " .. event.phase .. " local collision event between my fixture number " .. event.selfFixture.indexinlist .. " and fixture number " .. event.otherFixture.indexinlist .. " of " .. event.other.name .. " with a force of " .. event.force .. " and a friction of " .. event.friction)
    end
end

--set the RNBody.collision field to the function you just created
box.collision = onLocalCollide
box:addEventListener("collision")

--you can create as many local collision handlers as you want (one for each object)



--[[

Global and local collision handlers override themselves
so if you set the fixtures of an object for callbacks on functionA and then you set all the fixtures
for callbacks on functionB, the fixtures of the object will give callbacks only to fixtureB
else if you set functionB for all fixtures callbacks and then funcionA only for a specifi object's
fixture callback, the fixture collision callback is only given to functionA.
that's because each fixture can have set on it just one callback function at time.

]] --
