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



-- start physic simulation
RNPhysics.start()


--same as rn map basic map
-- tiles by Daniel Cook (http://www.lostgarden.com)



map = RNMapFactory.loadMap(RNMapFactory.TILED, "rapanui-samples/maps/physicmap.tmx")
aTileset = map:getTileset(0)
aTileset:updateImageSource("rapanui-samples/maps/platformtileset.png")
map:drawMapAt(0, 0, aTileset)

trn = RNTransition:new()

function setAlphaToZero()
    trn:run(map, { type = "alpha", alpha = 0, time = 1000, onComplete = setAlphaToOne })
end

function setAlphaToOne()
    trn:run(map, { type = "alpha", alpha = 1, time = 1000, onComplete = setAlphaToZero })
end

setAlphaToZero()





