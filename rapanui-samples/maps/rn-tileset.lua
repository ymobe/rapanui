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

require("RNMapFactory")
require("RNMap")
require("RNMapLayer")
require("RNMapObject")
require("RNMapObjectGroup")
require("RNMapTileset")
require("RNUtil")


map = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/maps/demomap.tmx")

aTileset = map:getTileset(0)

aTileset:updateImageSource("rapanui-samples/maps/tilesetdemo.png")

for i = 0, 6 do
    aTile = aTileset:getTileImage(i)
    aTile.x = 40 * i + 40
end

aTile = aTileset:getTileImage(13)
aTile.y = 40 * 3




