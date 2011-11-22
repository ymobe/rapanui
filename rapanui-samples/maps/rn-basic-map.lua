require("RNMapFactory")
require("RNMap")
require("RNMapLayer")
require("RNMapObject")
require("RNMapObjectGroup")
require("RNMapTileset")
require("RNUtil")


map = RNMapFactory.loadMap(RNMapFactory.TILED, "demomap.tmx")


print("NEW ============================================================================")
print("NEW ============================================================================")
print("NEW ============================================================================")
print("NEW ============================================================================")
print("")
print("")
--print_r(map)

-- print_r(map:getLayers())
print("MAP ============================================================================")

print("map props: mapCustomProp1=", map:getProperty("mapCustomProp1"))
-- Layers
aLayer = map:getFirstLayerByName("Objects")
print("tile id: ", aLayer:getTilesAt(3, 1))
print("================================================================================")
aLayer:printToAscii()
print("================================================================================")
print(aLayer:getOpacity())

aLayer = map:getFirstLayerByName("Back")
print("================================================================================")
aLayer:printToAscii()
print(aLayer:getOpacity())
print("================================================================================")

aLayer = map:getFirstLayerByName("Ground")
print("================================================================================")
aLayer:printToAscii()
print("================================================================================")
print("layerProp1", "=", aLayer:getProperty("layerProp1"))
print("layerPropX", "=", aLayer:getProperty("layerPropX"))

print(map:getOrientation())
print(map:getCols())
print(map:getRows())
print(map:getTileWidth())
print(map:getTileWidth())
print(map:getLayersSize())


-- TileSet
print("TileSet ================================================================================")
for i = 0, map:getTilesetSize() - 1 do
    aTileset = map:getTileset(i)
    print("tileset name:", aTileset:getName())
    print("tileset firstGid:", aTileset:getFirstGid())
    print("tileset width:", aTileset:getTileWidth())
    print("tileset height:", aTileset:getTileHeight())
    print("tileset image:", aTileset:getImage(), " width:", aTileset:getWidth(), "height:", aTileset:getHeight())
    for tileKey, value in pairs(aTileset:getAllTilesProperties()) do
        print("--> tileset prop fot tile:", tileKey)
        for key, value in pairs(aTileset:getPropertiesForTile(tileKey)) do
            print("--> tileset prop fot tile:", tileKey, ":", key, "=", value)
        end
    end
end

print("Objects ================================================================================")
aObjectGroup = map:getFirstObjectGroupByName("ObjectGroup01")
print("object size", aObjectGroup:getObjectsSize())
for i = 0, aObjectGroup:getObjectsSize() - 1 do
    print("---> ", i)
    aObject = aObjectGroup:getObject(i)
    print("name:", aObject:getName())
    print("type:", aObject:getType())
    print("gid:", aObject:getGid())
    print("x:", aObject:getX())
    print("y:", aObject:getY())
end
print("================================================================================")


print("================================================================================")
aObjectGroup = map:getFirstObjectGroupByName("ObjectGroup02")
print("================================================================================")



--print_r(map)



