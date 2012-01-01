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

--The triangle and the box can't collide!


--add images
background = RNFactory.createImage("RapaNui-samples/physics/background-purple.png")
box = RNFactory.createImage("RapaNui-samples/physics/box.png"); box.x = 170; box.y = 80;
ball = RNFactory.createImage("RapaNui-samples/physics/ball.png"); ball.x = 200; ball.y = -50;
triangle = RNFactory.createImage("RapaNui-samples/physics/poly.png"); triangle.x = 80; triangle.y = 80; triangle.rotation = 190
floor = RNFactory.createImage("RapaNui-samples/physics/floor.png"); floor.x = 160; floor.y = 400;

--starts simulation
RNPhysics.start()


--set images as physics objects
RNPhysics.createBodyFromImage(box, { filter = { groupIndex = -1 } })
RNPhysics.createBodyFromImage(ball, { shape = "circle" })
RNPhysics.createBodyFromImage(triangle, { shape = { -32, 32, 0, -32, 32, 32 }, restitution = 0.3, friction = 0.1, filter = { groupIndex = -1 } })
RNPhysics.createBodyFromImage(floor, "static", { density = 1, friction = 0.3, restitution = 0, sensor = false, shape = { -128, -16, 128, -16, 128, 16, -128, 16 } }, { density = 1, friction = 0.3, restitution = 0.5, sensor = true, shape = { -32, 32 - 100, 32, 32 - 100, 0, 64 - 100 } })

box.restitution = 0.5
ball.restitution = 0.3
triangle.restitution = 0.3

--[[

	For this sample we use the groupIndex.
	but in filter table we can also specify
	
	{categoryBits=value,maskBits=value,groupIndex=value}
	
	see box2d docs.



]] --