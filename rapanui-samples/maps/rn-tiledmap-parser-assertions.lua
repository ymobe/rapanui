RNUnit.assertEquals(2, map:getTilesetSize(), "Wrong tileset size")
RNUnit.assertEquals(6, map:getLayersSize(), "Wrong layers size")

print("NEW ============================================================================")
--print_r(map)

-- print_r(map:getLayers())
print("MAP ============================================================================")

RNUnit.assertEquals("value1", map:getProperty("mapCustomProp1"), "The Map property was wrong")

-- Layers
aLayer = map:getFirstLayerByName("Objects")
RNUnit.assertNotNil(aLayer, "The layer was nil")
RNUnit.assertEquals("Objects", aLayer:getName(), "The layer was wrong")

RNUnit.assertEquals(86, aLayer:getTilesAt(3, 1), "The Tile id was wrong")

print("================================================================================")
aLayer:printToAscii()
print("================================================================================")

RNUnit.assertNotNil(aLayer:getOpacity(), "The opacity was nil")

RNUnit.assertEquals(1, aLayer:getOpacity(), "Opacity should be 1")

aLayer = map:getFirstLayerByName("Back")
print("================================================================================")
aLayer:printToAscii()
print("================================================================================")

aLayer = map:getFirstLayerByName("Ground")
RNUnit.assertNotNil(aLayer, "The layer was nil")
RNUnit.assertEquals("Ground", aLayer:getName(), "The layer was wrong")

print("================================================================================")
aLayer:printToAscii()
print("================================================================================")

RNUnit.assertEquals("value1", aLayer:getProperty("layerProp1"), "The property value was wrong")
RNUnit.assertEquals("value2", aLayer:getProperty("layerProp2"), "The property value was wrong")
RNUnit.assertNil(aLayer:getProperty("layerPropX"), "The property value should be nil")


RNUnit.assertEquals("orthogonal", map:getOrientation(), "Orientation should be orthogonal")
RNUnit.assertEquals(5, map:getCols(), "Cols should be 5")
RNUnit.assertEquals(5, map:getRows(), "Rows should be 5")
RNUnit.assertEquals(16, map:getTileWidth(), "Tile Width should be 16")
RNUnit.assertEquals(16, map:getTileHeight(), "Tile Height should be 16")
RNUnit.assertEquals(6, map:getLayersSize(), "Layer size should be 8")


aTileSet = map:getFirstTilesetByName("platformtiles-02")

RNUnit.assertNotNil(aTileSet, "The Tileset was nil")
RNUnit.assertEquals("platformtiles-02", aTileSet:getName(), "The tileset name was wrong")

RNUnit.assertEquals(241, aTileSet:getFirstGid(), "The first gid should be 241")

RNUnit.assertEquals("platformtiles-02.png", aTileSet:getImage(), "The Image name was wrong")
RNUnit.assertEquals(320, aTileSet:getWidth(), "The Image Width was wrong")
RNUnit.assertEquals(200, aTileSet:getHeight(), "The Image Height was wrong")
--print("tileset image:", aTileset:getImage(), " width:", aTileset:getWidth(), "height:", aTileset:getHeight())

aTileSet = map:getFirstTilesetByName("tileset-platformer")

-- tile 16 and 50
aProp = aTileSet:getPropertiesForTile(17)
RNUnit.assertNotNil(aProp, "The Tile 16 properties were nil")

-- tile 16 and 50
aProp = aTileSet:getPropertiesForTile(77)
RNUnit.assertNil(aProp, "The Tile 77 properties should be nil")

aValue = aTileSet:getPropertyValueForTile(17, "tileCustomProp1")
RNUnit.assertEquals("value1", aValue, "The Tile property value was wrong")

aValue = aTileSet:getPropertyValueForTile(51, "tileCustomProp2")
RNUnit.assertEquals("value2", aValue, "The Tile property value was wrong")


aObjectGroup = map:getFirstObjectGroupByName("ObjectGroup01")
RNUnit.assertNotNil(aObjectGroup, "Layer group shuold be not nil")
RNUnit.assertEquals("ObjectGroup01", aObjectGroup:getName(), "The ObjectGroup name was wrong")
RNUnit.assertEquals(2, aObjectGroup:getPropertiesSize(), "The ObjectGroup size was wrong")

RNUnit.assertEquals("value1", aObjectGroup:getProperty("objGroupProps1"), "The property value was wrong")
RNUnit.assertEquals("value2", aObjectGroup:getProperty("objGroupProps2"), "The property value was wrong")

RNUnit.assertEquals(9, aObjectGroup:getObjectsSize(), "The object size was wrong")
aObjectGroupItem = aObjectGroup:getFirstObjectByName("dummy01")

RNUnit.assertNotNil(aObjectGroupItem, "The object was nil")

RNUnit.assertEquals("dummy01", aObjectGroupItem:getName(), "The property value was wrong")
RNUnit.assertEquals(96, aObjectGroupItem.x, "The x value was wrong")
RNUnit.assertEquals(96, aObjectGroupItem.y, "The y value was wrong")
RNUnit.assertEquals(16, aObjectGroupItem.width, "The width value was wrong")
RNUnit.assertEquals(16, aObjectGroupItem.height, "The height value was wrong")

RNUnit.assertEquals(1, aObjectGroupItem:getPropertiesSize(), "The properties size was wrong")
RNUnit.assertEquals("value01", aObjectGroupItem:getProperty("dummy01Prop"), "The properties size was wrong")