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

--World Settings tutorial


--add images
background = RNFactory.createImage("rapanui-samples/physics/background-purple.png")
box = RNFactory.createImage("rapanui-samples/physics/box.png"); box.x = 170; box.y = 80;
ball = RNFactory.createImage("rapanui-samples/physics/ball.png"); ball.x = 240; ball.y = 80;
triangle = RNFactory.createImage("rapanui-samples/physics/poly.png"); triangle.x = 80; triangle.y = 80; triangle.rotation = 190
floor = RNFactory.createImage("rapanui-samples/physics/floor.png"); floor.x = 160; floor.y = 400;

--starts and stops simulation
RNPhysics.start()
--RNPhysics.stop()

--filter collisions
--you may want to set a global filter for collision types: all, begin, end, pre_solve or post_solve
--to register all fixtures in the game to call back only for one kind of collision (to optimize game speed)
--by default its set to "all"
RNPhysics.setCollisions("all")  --optional

--setting up gravity
RNPhysics.setGravity(0, 10)
print(RNPhysics.getGravity)

--Other Methods
--Changing this after bodies creation will result buggy
RNPhysics.setMeters(6)
RNPhysics.setIterations(1, 1)
print(RNPhysics.getMeters())
RNPhysics.setAutoClearForces(true)
print(RNPhysics.getAutoClearForces())
--after-update methods
RNPhysics.setAngularSleepTolerance(1)
RNPhysics.setLinearSleepTolerance(1)
RNPhysics.setTimeToSleep(1)
print(RNPhysics.getAngularSleepTolerance())
print(RNPhysics.getLinearSleepTolerance())
print(RNPhysics.getTimeToSleep())



--set images as physics objects
RNPhysics.createBodyFromImage(box)
RNPhysics.createBodyFromImage(ball, { shape = "circle" })
RNPhysics.createBodyFromImage(triangle, { shape = { -32, 32, 0, -32, 32, 32 }, restitution = 0.3, friction = 0.1 })
RNPhysics.createBodyFromImage(floor, "static")
box.restitution = 0.5
ball.restitution = 0.3
triangle.restitution = 0.3



--after update some bodies methods
box:setMassData(5)
print(box:getInertia())
print(box:getMass()) 



