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

--Animations can become physic objects...


--add images
background = RNFactory.createImage("rapanui-samples/physics/background-purple.png")
box = RNFactory.createImage("rapanui-samples/physics/box.png"); box.x = 170; box.y = 80;
ball = RNFactory.createImage("rapanui-samples/physics/ball.png"); ball.x = 240; ball.y = 80;
triangle = RNFactory.createImage("rapanui-samples/physics/poly.png"); triangle.x = 80; triangle.y = 80; triangle.rotation = 190
floor = RNFactory.createImage("rapanui-samples/physics/floor.png"); floor.x = 160; floor.y = 400;

--starts simulation
RNPhysics.start()


--set images as physics objects
RNPhysics.createBodyFromImage(box)
RNPhysics.createBodyFromImage(ball, { shape = "circle" })
RNPhysics.createBodyFromImage(triangle, { shape = { -32, 32, 0, -32, 32, 32 }, restitution = 0.3, friction = 0.1 })
RNPhysics.createBodyFromImage(floor, "static")
box.restitution = 0.5
ball.restitution = 0.3
triangle.restitution = 0.3


--simple animation which plays the default sequence
char = RNFactory.createAnim("rapanui-samples/physics/char.png", 42, 32)
char.x = 100; char.y = 100;
char.scaleX = 0.5; char.scaleY = 1
char:play("default", 12, -1)

RNPhysics.createBodyFromImage(char)
char.restitution = 0.8




--[[

	Check other samples for complete animation tutorials.

]] --