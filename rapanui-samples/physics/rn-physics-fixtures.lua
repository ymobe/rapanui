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

--We create 4 objects and change their fixture properties during creation and/or after


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

box.density = 1.5
box.friction = 0.5
box.restitution = 0.7

ball.sensor = true --the ball become a sensor (check other samples)

--[[

 "fixture" should be a table containing
 {density=number,friction=number,shape=string or table,filter=table,restitution=number,sensor=boolean}


 default values are
 
 density=1
 friction=0.3
 sensor=false
 filter={categoryBits = 1, maskBits = nil, groupIndex = nil}
 shape="rectangle"
 
 you can't change shape and type after creation.



 and we can change this also after creation.
 Changes made after creation will affect all fixtures in the body.
 If you want to change a specific fixture in the body you should use lists.
 please check other samples for lists tutorials

]] --