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

--RapaNui tutorial on how to set up the framework for Physics Editor
--demo by RapaNui team

--first of all we load the required APIs from RapaNui framework

require("RNFactory")
require("RNListeners")
require("RNPhysics")
require("RNMainThread")
require("RNThread")




-- and we start the physics simulation, initializing the physics world
RNPhysics.start()


--now we have RapaNui and physics correctly running we can start creating something

--a background image will be good, so we create it with RNFactory
RNFactory.createImage("resources/bkg_cor.png");




--we load the PhysicsData containing all PhysicsEditor's information for our bodies,
--obviously exported with "RapaNui" exporter.


local physicsData = (require"resources/PhysicsData").physicsData()


--now we can create the waved floor
--first we load the image through RapaNui's factory
local floorImage = RNFactory.createImage("resources/floor.png");
--and we set its position and name
floorImage.x = 290; floorImage.y = 375; floorImage.name = "floor"


--now we let RapaNui create a "static" physics object with the given floor image and the
--"floor" physics data we got earlier
RNPhysics.createBodyFromImage(floorImage, "static", physicsData:get("floor"))



--we create a global table with all falling object's names within
local foodTable = { 'drink', 'hamburger', 'hotdog', 'icecream', 'icecream2', 'icecream3' }


--we should now set a function to create falling objects
function createFallingObjects()
    --we get a random item from the food table
    local item = foodTable[math.random(#foodTable)]

    --we create a falling object from the random item we got
    --first the image
    local object = RNFactory.createImage("resources/" .. item .. ".png");
    --moved in to a random position
    object.x = math.random(580);
    --and with the right name
    object.name = item

    --then we make create a physics object from it and from the data we got from PhysicsEditor
    RNPhysics.createBodyFromImage(object, physicsData:get(item))
end


--we give a first run to the above function
createFallingObjects()


--now we should create the timed action to call the above function repeatedly each 2000 steps
RNMainThread.addTimedAction(2000, createFallingObjects, -1)



