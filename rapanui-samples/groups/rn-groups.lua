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
--]]

freeImage = RNFactory.createImage("images/background-blue.png")

freeImage = RNFactory.createImage("images/image.png")

group = RNGroup:new()
group2 = RNGroup:new()

anImageTest1 = RNFactory.createImage("images/tile1.png")
anImageTest1.x = 96
anImageTest1.y = 96

anImageTest2 = RNFactory.createImage("images/tile2.png", { top = 15, left = 115 })

anImageTest3 = RNFactory.createImage("images/tile3.png", { top = 77, left = 132 })
anImageTest3.x = 96
anImageTest3.y = 96

anImageTest4 = RNFactory.createImage("images/tile4.png", { top = 0, left = 180 })


anImageTest4.x = 160
anImageTest4.y = 240



--group.x = 160
--group.y = 240



--group:insert(anImageTest1)
group:insert(anImageTest2)
group:insert(anImageTest3)

group2:insert(anImageTest1)
group2:insert(anImageTest4)


print("anImageTest1 x: " .. anImageTest1.x .. " y: " .. anImageTest1.y)
print("anImageTest2 x: " .. anImageTest2.x .. " y: " .. anImageTest2.y)
print("anImageTest3 x: " .. anImageTest3.x .. " y: " .. anImageTest3.y)
print("anImageTest4 x: " .. anImageTest4.x .. " y: " .. anImageTest4.y)
print("anImageTest1 x: " .. anImageTest1.x .. " y: " .. anImageTest1.y)


--print_r(group.displayObjects)
--print_r(group2.displayObjects)

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
