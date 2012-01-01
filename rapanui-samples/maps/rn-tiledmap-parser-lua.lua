require("RNMapFactory")
require("RNMap")
require("RNMapLayer")
require("RNMapObject")
require("RNMapObjectGroup")
require("RNMapTileset")
require("RNUtil")

map = RNMapFactory.loadMap(RNMapFactory.TILEDLUA, "rapanui-samples/maps/testMap.lua")

require("rapanui-samples/maps/rn-tiledmap-parser-assertions")
