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



mapOne = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/groups/mapone.tmx")
aTileset = mapOne:getTileset(0)
aTileset:updateImageSource("rapanui-samples/groups/tilesetdemo.png")
mapOne:drawMapAt(0, 0, aTileset)


mapTwo = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/groups/maptwo.tmx")
aTileset = mapTwo:getTileset(0)
aTileset:updateImageSource("rapanui-samples/groups/tilesetdemo.png")
mapTwo:drawMapAt(0, 160, aTileset)


mapThree = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/groups/mapthree.tmx")
aTileset = mapThree:getTileset(0)
aTileset:updateImageSource("rapanui-samples/groups/tilesetdemo.png")
mapThree:drawMapAt(0, 320, aTileset)


--add maps in groups, with a little bit of nesting, too ^^

group = RNGroup:new()
group2 = RNGroup:new()

group:insert(mapOne)
group2:insert(mapTwo)
group:insert(mapThree)
group:insert(group2)
group2:removeChild(mapTwo.idInGroup)

print("group one size: " .. group:getSize())



local myListener = function(event)
    group.x = event.x
    group.y = event.y

--    print("group x: " .. group.x .. " y: " .. group.y)

--    print("anImageTest1 x: " .. anImageTest1.x .. " y: " .. anImageTest1.y)
--    print("anImageTest2 x: " .. anImageTest2.x .. " y: " .. anImageTest2.y)
--    print("anImageTest3 x: " .. anImageTest3.x .. " y: " .. anImageTest3.y)
--    print("anImageTest4 x: " .. anImageTest4.x .. " y: " .. anImageTest4.y)
end

RNListeners:addEventListener("touch", myListener)