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

-- tiles by Daniel Cook (http://www.lostgarden.com)

--so now we want to get properties for the tiles we touch
-- from our "mountains" layer in rpgmap-properties.tmx map

--we create a map
local map = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/maps/rpgmap-properties.tmx")

local aTileset = map:getTileset(0)
aTileset:updateImageSource("rapanui-samples/maps/rpgtileset.png")

map:drawMapAt(0, 0, aTileset)


--we get the layer we are interested in
local mountainslayer = map:getLayerByName("mountains")


--we set a callback for touch
function touch(event)
    if event.phase == "began" then
        --we get properties
        local properties = mountainslayer:getTilePropertiesAt(event.x, event.y, aTileset)
        if properties ~= nil then
            --we print them
            for i, v in pairs(properties) do
                print(i, v)
            end
        end
    end
end

--set a touch listener
RNListeners:addEventListener("touch", touch)


--i've set properties only for "mountains" layer and only for the 4 center tiles on the top of the mountain
-- and for the vines I've set two values.
--
--this way we can get whether a tile is solid so maybe a character can't walk over it
--or maybe we want to get when a character walks on a specific tile which will generate an event in the game.
