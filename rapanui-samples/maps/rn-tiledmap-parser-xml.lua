require("RNMapFactory")
require("RNMap")
require("RNMapLayer")
require("RNMapObject")
require("RNMapObjectGroup")
require("RNMapTileset")
require("RNUtil")

map = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/maps/testMap.tmx")

require("rapanui-samples/maps/rn-tiledmap-parser-assertions")
