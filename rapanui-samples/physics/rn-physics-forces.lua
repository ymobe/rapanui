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

--We create 3 objects and apply forces and impulses to them
local R = RN
--add images
background = R.Factory.createImage("RN/RapaNui-samples/physics/background-purple.png")
box = R.Factory.createImage("RN/RapaNui-samples/physics/box.png"); box.x = 170; box.y = 80;
ball = R.Factory.createImage("RN/RapaNui-samples/physics/ball.png"); ball.x = 270; ball.y = 80;
triangle = R.Factory.createImage("RN/RapaNui-samples/physics/poly.png"); triangle.x = 80; triangle.y = 80; triangle.rotation = 190
floor = R.Factory.createImage("RN/RapaNui-samples/physics/floor.png"); floor.x = 160; floor.y = 400;

--starts simulation
R.Physics.start()


--set images as physics objects
R.Physics.createBodyFromImage(box)
R.Physics.createBodyFromImage(ball, { shape = "circle", restitution = 0.2 })
R.Physics.createBodyFromImage(triangle, { shape = { -32, 32, 0, -32, 32, 32 }, restitution = 0.2 })
R.Physics.createBodyFromImage(floor, "static")

box.restitution = 0.2
box:applyAngularImpulse(10000)

ball:applyLinearImpulse(-100, -1000, ball.x, ball.y)

triangle:applyForce(0, -1000, triangle.x, triangle.y)

--check R.Body.lua for all methods available!


--[[

 please check other samples

]] --