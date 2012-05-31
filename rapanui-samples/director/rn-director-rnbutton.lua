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

effects = { "slidetoleft", "slidetoright", "crossfade", "slidetotop", "slidetobottom", "pop", "fade" }

function getRandomTransition()
    return effects[math.random(1, table.getn(effects) + 1)]
end

director = RNDirector:new()

director:addScene("rapanui-samples/director/scene1button")
director:addScene("rapanui-samples/director/scene2button")

--check if they are inside the director
for i, v in ipairs(director.scenes) do
    print(i, v)
end

--Set director's time
director:setTime(1000)

director:showScene("rapanui-samples/director/scene1button", "slidetotop")
