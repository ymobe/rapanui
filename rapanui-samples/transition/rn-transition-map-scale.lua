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

require("RNMapFactory")
require("RNMap")
require("RNMapLayer")
require("RNMapObject")
require("RNMapObjectGroup")
require("RNMapTileset")
require("RNUtil")



map = RNMapFactory.loadMap(RNMapFactory.TILED,"rapanui-samples/maps/rpgmap.tmx")
aTileset = map:getTileset(0)
aTileset:updateImageSource("rapanui-samples/maps/rpgtileset.png")
map:drawMapAt(0, 0, aTileset)

trn = RNTransition:new()

function first()
    trn:run(map, { type = "scale", xScale = 1, yScale = 1, time = 1000, onComplete = second })
end

function second()
    trn:run(map, { type = "scale", xScale = -1, yScale = -1, time = 1000, onComplete = first })
end

first()



