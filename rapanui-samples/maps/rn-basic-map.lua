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

local R = RN
map = R.MapFactory.loadMap(R.MapFactory.TILED, "RN/rapanui-samples/maps/demomap.tmx")

aTileset = map:getTileset(0)

aTileset:updateImageSource("RN/rapanui-samples/maps/tilesetdemo.png")


local layersSize = map:getLayersSize()

print("Layers", layersSize)
local layers = map:getLayers()


memestatus()

for i = 0, layersSize - 1 do
    local layer = layers[i]
    for col = 0, layer:getCols() - 1 do
        local rowTiles = ""
        for row = 0, layer:getRows() - 1 do
            local tileIdx = layer:getTilesAt(row, col)
            local tileX = aTileset:getTileWidth() * col + aTileset:getTileWidth() / 2
            local tileY = aTileset:getTileHeight() * row + aTileset:getTileHeight() / 2

            if tileX > -aTileset:getTileWidth() and tileX < config.width + aTileset:getTileWidth() and
                    tileY > -aTileset:getTileHeight() and tileY < config.height + aTileset:getTileWidth()
            then
                local aTile = aTileset:getTileImage(tileIdx)
                aTile.x = tileX
                aTile.y = tileY
            end
        end
        rowTiles = ""
    end
end

memestatus()