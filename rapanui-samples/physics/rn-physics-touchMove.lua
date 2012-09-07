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


--simple code to move a physical object under mouse


RNPhysics.start()


local touchedObject

function letterTouchDown(event)
    touchedObject = event.target
end

function touch(event)
    if touchedObject ~= nil then
        touchedObject.x = event.x
        touchedObject.y = event.y
        touchedObject:setLinearVelocity(0, 0)
    end
end

function create_letter()
    local letter = RNFactory.createImage("images/tile0.png"); letter.x = math.random(45, 300); letter.y = 40;
    RNPhysics.createBodyFromImage(letter)
    letter.restitution = 0.5
    letter:setOnTouchDown(letterTouchDown)
end


function create_floor()
    local floor = RNFactory.createImage("rapanui-samples/physics/floor.png")
    floor.x = 160
    floor.y = 400
    RNPhysics.createBodyFromImage(floor, "static")
end


RNListeners:addEventListener("touch", touch)
RNFactory.createImage("images/background-purple.png")
create_floor()
create_letter()