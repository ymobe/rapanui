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

--RNDirector test , remove comments to test effects.



director = RNDirector:new()


director:addScene("rapanui-samples/director/scene1")
director:addScene("rapanui-samples/director/scene2")

--check if they are inside the director
for i, v in ipairs(director.scenes) do print(i, v) end

--Set director's time
director:setTime(1000)


--POP TEST
--director:showScene("rapanui-samples/director/scene1","pop")
--director:hideScene("rapanui-samples/director/scene1","pop")
--director:showScene("rapanui-samples/director/scene1","pop")


--POP CHANGE TEST
--director:showScene("rapanui-samples/director/scene1","pop")
--director:showScene("rapanui-samples/director/scene2","pop")


--FADE IN TEST
--director:showScene("rapanui-samples/director/scene1","fade")


--FADE OUT TEST
--director:showScene("rapanui-samples/director/scene2","pop")
--director:hideCurrentScene("fade")


--FADE CHANGE TEST
--director:showScene("rapanui-samples/director/scene1","pop")
--director:showScene("rapanui-samples/director/scene2","fade")


--SLIDE TO LEFT IN TEST
--director:showScene("rapanui-samples/director/scene1", "slidetoleft")


--SLIDE TO LEFT OUT TEST
--director:showScene("rapanui-samples/director/scene2","pop")
--director:hideCurrentScene("slidetoleft")


--SLIDE TO LEFT CHANGE TEST
--director:showScene("rapanui-samples/director/scene1","pop")
--director:showScene("rapanui-samples/director/scene2","slidetoleft")


--SLIDE TO RIGHT IN TEST
--director:showScene("rapanui-samples/director/scene1","slidetoright")


--SLIDE TO RIGHT OUT TEST
--director:showScene("rapanui-samples/director/scene1","pop")
--director:hideCurrentScene("slidetoright")


--SLIDE TO RIGHT CHANGE TEST
--director:showScene("rapanui-samples/director/scene1","pop")
--director:showScene("rapanui-samples/director/scene2","slidetoright")


--SLIDE TO TOP IN TEST
--director:showScene("rapanui-samples/director/scene1","slidetotop")


--SLIDE TO TOP OUT TEST
--director:showScene("rapanui-samples/director/scene1","pop")
--director:hideCurrentScene("slidetotop")


--SLIDE TO TOP CHANGE TEST
--director:showScene("rapanui-samples/director/scene1","pop")
--director:showScene("rapanui-samples/director/scene2","slidetotop")


--SLIDE TO BOTTOM IN TEST
--director:showScene("rapanui-samples/director/scene1","slidetobottom")


--SLIDE TO BOTTOM OUT TEST
--director:showScene("rapanui-samples/director/scene1","pop")
--director:hideCurrentScene("slidetobottom")


--SLIDE TO BOTTOM CHANGE TEST
--director:showScene("rapanui-samples/director/scene1","pop")
--director:showScene("rapanui-samples/director/scene2","slidetobottom")


--SPECIAL
--we can also get the scene we are going into because maybe we want references to it.
local sceneWeAreGoing = director:showScene("rapanui-samples/director/scene1", "slidetoleft")
print(sceneWeAreGoing)



--GET METHODS
print(director:isTransitioning())
print(director:getCurrentScene())
print(director:getNextScene())
print(director:getCurrentSceneGroup())
print(director:getNextSceneGroup())
print(director:getCurrentSceneName())