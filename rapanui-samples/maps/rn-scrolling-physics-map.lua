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
--
-- Tiles of the map from:
--
-- gfxlib
--
-- Product	: gfxlib-fuzed.zip
-- Website	: http://www.spicypixel.net
-- Author	: Marc Russell
-- Released: 10th January 2008
--
--
-- gfxlib is under Common Public License (http://www.opensource.org/licenses/cpl1.0.php)
]]

require("socket")

-- start physic simulation

RNPhysics.start()


local map = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/maps/platformmapphysics.tmx")

aTileset = map:getTileset(0)

aTileset:updateImageSource("rapanui-samples/maps/platformtileset.png")

local layersSize = map:getLayersSize()

tilesCreated = 0
map:drawMapAt(0, 0, aTileset)


local lastx = 0
local delta = -3

lastTime = socket.gettime()

local intervalForFps = 1 / 60

print(intervalForFps)
local currentTime = socket.gettime()
local diff = currentTime - lastTime





function update(enterFrame)
    currentTime = socket.gettime()
    diff = currentTime - lastTime
    if diff >= intervalForFps then
        map:drawMapAt(lastx, 0, aTileset)
        lastx = lastx + delta

        if lastx <= -1280 then
            delta = delta * -1
        end

        if lastx >= 0 then
            delta = delta * -1
        end
        lastTime = currentTime
    end
end

-- scrolling can be done either with enterFrame and Timer.
-- timer is recommend due to enterFrame massive consume of device's CPU.

--RNListeners:addEventListener("enterFrame", update)
local actionId = RNMainThread.addTimedAction(0.009, update)



--Debug Draw if you want
--RNPhysics.setDebugDraw(RNFactory.screen)