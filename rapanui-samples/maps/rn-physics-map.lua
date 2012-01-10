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

------start physic simulation

RNPhysics.start()


--same as rn map basic map
-- tiles by Daniel Cook (http://www.lostgarden.com)

require("RNMapFactory")
require("RNMap")
require("RNMapLayer")
require("RNMapObject")
require("RNMapObjectGroup")
require("RNMapTileset")
require("RNUtil")


map = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/maps/physicmap.tmx")


aTileset = map:getTileset(0)

aTileset:updateImageSource("rapanui-samples/maps/platformtileset.png")


local layersSize = map:getLayersSize()

print("Layers", layersSize)
local layers = map:getLayers()


memestatus()

map:drawMapAt(0, 0, aTileset)


memestatus()



--Debug Draw if you want
--RNPhysics.setDebugDraw(RNFactory.screen)




