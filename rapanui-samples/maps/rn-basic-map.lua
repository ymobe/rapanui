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


local layersSize = map:getLayersSize()

print("Layers", layersSize)
local layers = map:getLayers()

for i = 0, layersSize - 1 do
    local layer = layers[i]
    for row = 0, layer:getCols() - 1 do
        local rowTiles = ""
        for col = 0, layer:getRows() - 1 do
            local tileIdx = layer:getTilesAt(row, col)
            local aTile = aTileset:getTileImage(tileIdx)
            aTile.x = aTileset:getTileWidth() * col + aTileset:getTileWidth() / 2
            aTile.y = aTileset:getTileHeight() * row + aTileset:getTileHeight() / 2
        end
        rowTiles = ""
    end
end