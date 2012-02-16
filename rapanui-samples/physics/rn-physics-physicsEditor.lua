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

--basic physics editor sample


--starts simulation
RNPhysics.start()


--loads PE data
local physicsData = (require"rapanui-samples/physics/complex_shapes").physicsData()


--Complex Star Object
--create image
local shape1 = RNFactory.createImage("rapanui-samples/physics/c_shape1.png"); shape1.x = 200; shape1.y = 200;
--create physics from image and from fixtures got from PE
RNPhysics.createBodyFromImage(shape1, physicsData:get("c_shape1"))
--get name from fixture
--we can get names by fixtures or fixtures by their name.
print(shape1.fixture[2].name)
--get fixture from name
print(shape1:getFixtureListByName("Star"))
--check if RapaNui correctly loads all
print(shape1.restitution, shape1.friction, shape1.density)
shape1.name = "Star"

--Complex With Sensor Part
local shape2 = RNFactory.createImage("rapanui-samples/physics/c_shape2.png"); shape2.x = 200; shape2.y = 200;
RNPhysics.createBodyFromImage(shape2, physicsData:get("c_shape2"))

--Complex Floor
local shape3 = RNFactory.createImage("rapanui-samples/physics/c_shape3.png"); shape3.x = 150; shape3.y = 400;
RNPhysics.createBodyFromImage(shape3, "static", physicsData:get("c_shape3"))
shape3.name = "floor"

--Complex Doll-like
local shape4 = RNFactory.createImage("rapanui-samples/physics/c_shape4.png"); shape4.x = 100; shape4.y = 200;
RNPhysics.createBodyFromImage(shape4, physicsData:get("c_shape4"))
shape4.rotation = 45
shape4.name = "doll"

--print fixtures name to make sure we got all from PE
for i, v in ipairs(shape4.fixture) do print(i, v.name) end



--let's get now all fixtures named "rightArm"
--returns a table with all the fixtures named "rightArm"
print(shape4:getFixtureListByName("rightArm"))
--let's make the right arm to be bouncing!
--changes the restitution of all fixtures named "rightArm" to 1
shape4:changeFixturesProperty("rightArm", "restitution", 1)




--create a function for collision's callbacks
function onLocalCollide(self, event)
    if (event.self ~= nil) and (event.other ~= nil) and (event.phase == "begin") then
        print("Hi, I'm a " .. self.name .. " and im calling a " .. event.phase .. " local collision event between my  " .. self.fixture[event.selfFixture.indexinlist].name .. " and " .. event.other.fixture[event.otherFixture.indexinlist].name .. " of " .. event.other.name .. " with a force of " .. event.force .. " and a friction of " .. event.friction)
    end
end

--Collision Handling for Doll-like
shape4.collision = onLocalCollide
shape4:addEventListener("collision")







--debug draw
RNPhysics.setDebugDraw(RNFactory.screen)