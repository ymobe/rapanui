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

director:addScene("rapanui-samples/director/scene1")
director:addScene("rapanui-samples/director/scene2")

--check if they are inside the director
for i, v in ipairs(director.scenes) do
    print(i, v)
end

--Set director's time
director:setTime(1000)



director:showScene("rapanui-samples/director/scene1", getRandomTransition())

text1 = RNFactory.createText("Touch to swap!", { size = 20, top = 5, left = 5, width = 200, height = 50 })
text1:setLevel(1000)

local scene1 = "rapanui-samples/director/scene1"
local scene2 = "rapanui-samples/director/scene2"
local sceneToShow = scene1

function callMeBack(event)
    print("Called Back!")
end

function onTouchEvent(event)
    if event.phase == "began" and director:isTransitioning() == false then
        if sceneToShow == scene1 then
            sceneToShow = scene2
        else
            sceneToShow = scene1
        end

        director:showScene(sceneToShow, getRandomTransition(), callMeBack)
    end
end



RNListeners:addEventListener("touch", onTouchEvent)