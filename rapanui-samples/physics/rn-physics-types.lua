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

--We create 3 objects, one for type and one with default type. One is removed.


--add images
background = RNFactory.createImage("rapanui-samples/physics/background-purple.png")
box = RNFactory.createImage("rapanui-samples/physics/box.png"); box.x = 160; box.y = 80;
box2 = RNFactory.createImage("rapanui-samples/physics/box.png"); box2.x = 230; box2.y = 80;
box3 = RNFactory.createImage("rapanui-samples/physics/box.png"); box3.x = 80; box3.y = 80; box3.rotation = 190
floor = RNFactory.createImage("rapanui-samples/physics/floor.png"); floor.x = 160; floor.y = 400;

--starts simulation
RNPhysics.start()


--set images as physics objects
RNPhysics.createBodyFromImage(box)
RNPhysics.createBodyFromImage(box2, "dynamic")
RNPhysics.createBodyFromImage(box3, "kinematic")
RNPhysics.createBodyFromImage(floor, "static")

--remove the object
box:remove()

--[[

 type can be "dynamic" "static" or "kinematic".
 default type is "dynamic"

 please check other samples

]] --