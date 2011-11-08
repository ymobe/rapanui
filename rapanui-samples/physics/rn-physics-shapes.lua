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

--We create 4 objects, one for shape type and one with default shape


--add images
background = RNFactory.createImage("RapaNui-samples/physics/background-purple.png")
box = RNFactory.createImage("RapaNui-samples/physics/box.png"); box.x = 170; box.y = 80;
box2 = RNFactory.createImage("RapaNui-samples/physics/box.png"); box2.x = 170; box2.y = 0;
ball = RNFactory.createImage("RapaNui-samples/physics/ball.png"); ball.x = 240; ball.y = 80;
triangle = RNFactory.createImage("RapaNui-samples/physics/poly.png"); triangle.x = 80; triangle.y = 80; triangle.rotation = 190
floor = RNFactory.createImage("RapaNui-samples/physics/floor.png"); floor.x = 160; floor.y = 400;

--starts simulation
RNPhysics.start()


--set images as physics objects
RNPhysics.createBodyFromImage(box)
RNPhysics.createBodyFromImage(box2, { shape = "rectangle" })
RNPhysics.createBodyFromImage(ball, { shape = "circle" })
RNPhysics.createBodyFromImage(triangle, { shape = { -32, 32, 0, -32, 32, 32 } })
RNPhysics.createBodyFromImage(floor, "static")


--[[

 RNPhysics.createBodyFromImage(image[,type,fixture1,fixture2...fixtureN])
 or
 RNPhysics.createBodyFromImage(image[,fixture1,fixture2...fixtureN])
 
 "fixture" should be a table containing
 {density=number,friction=number,shape=string or table,filter=table,restitution=number,sensor=boolean}
 
 shape can be "circle" , "rectangle" or an array containg vertex coordinate components in clockwise order
 shape is "rectangle" for default

 please check other samples

]] --