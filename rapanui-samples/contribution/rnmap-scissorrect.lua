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

-- Map without scissor rectangle
local map = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/maps/rpgmap.tmx")
local aTileset = map:getTileset(0)
aTileset:updateImageSource("rapanui-samples/maps/rpgtileset.png")
map:drawMapAt(200, 200, aTileset)

-- Map with scissor rectangle
local map2 = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/maps/rpgmap.tmx")
local aTileset2 = map:getTileset(0)
aTileset2:updateImageSource("rapanui-samples/maps/rpgtileset.png")
map2:drawMapAt(25, 25, aTileset2)

local scissorRect = MOAIScissorRect.new ()
scissorRect:setRect( 25, 25, 125, 125)
map2:setScissorRect(scissorRect)