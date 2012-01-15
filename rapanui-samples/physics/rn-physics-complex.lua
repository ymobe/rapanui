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

--The floor we create has two different fixtures with different properties!


--add images
background = RNFactory.createImage("rapanui-samples/physics/background-purple.png")
box = RNFactory.createImage("rapanui-samples/physics/box.png");
box.x = 170; box.y = 80;
ball = RNFactory.createImage("rapanui-samples/physics/ball.png");
ball.x = 240; ball.y = 80;
triangle = RNFactory.createImage("rapanui-samples/physics/poly.png");
triangle.x = 80; triangle.y = 80; triangle.rotation = 190;
floor = RNFactory.createImage("rapanui-samples/physics/floor.png");
floor.x = 160; floor.y = 400;

--starts simulation
RNPhysics.start()


--set images as physics objects
RNPhysics.createBodyFromImage(box)
RNPhysics.createBodyFromImage(ball, { shape = "circle" })
RNPhysics.createBodyFromImage(triangle, { shape = { -32, 32, 0, -32, 32, 32 }, restitution = 0.3, friction = 0.1 })
RNPhysics.createBodyFromImage(floor, "static", { density = 1, friction = 0.3, restitution = 0, sensor = false, shape = { -128, -16, 128, -16, 128, 16, -128, 16 } }, { density = 1, friction = 0.3, restitution = 0.5, sensor = true, shape = { -32, 32 - 100, 32, 32 - 100, 0, 64 - 100 } })

box.restitution = 0.5
ball.restitution = 0.3
triangle.restitution = 0.3



--set debud draw on screen
--for i,v in ipairs(RNFactory.screen.sprites) do print(i,v) end
RNPhysics.setDebugDraw(RNFactory.screen)



--[[

	 We can create a Body with different fixtures and different properties in it
	 (if we need a part of the body is sensor and the other not)
	 
	 You can add as many fixtures as you like on the body.
	 
	 As soon as you change a global body property, all the fixtures in the body will
	 change.
	 
	 In the example above the floor has two fixtures: only one of them is sensor.
	 if we call
	 floor.sensor=true or floor.sensor=false
	 both fixtures will change.
	 
	 See others samples for list-changing only one fixture's property
	 
	 Debug Draw show us debug lines. See box2d docs.

]] --