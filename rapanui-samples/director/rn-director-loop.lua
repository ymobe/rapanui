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
director:addScene("rapanui-samples/director/scene3")
director:addScene("rapanui-samples/director/scene4")

--check if they are inside the director
for i, v in ipairs(director.scenes) do print(i, v) end

--counter, flag and state for loop
local counter = 0
local state = 0
local tran = 0

--Set director's time
director:setTime(800)



--show first scene
director:showScene("rapanui-samples/director/scene1", "pop")




--for loop counter
function updateCounter()
  counter = counter + 1
  if counter == 60 then
    state = state + 1
    tran = tran + 1
    if tran == 7 then
      tran = 1
    end
    counter = 0
    perform()
  end
end

trans = {"pop", "fade", "slidetoleft" , "slidetoright", "slidetotop", "slidetobottom"}
--perform showScene
function perform()
print(state, trans[tran])
  director:showScene("rapanui-samples/director/scene"..state, trans[tran])
  if state == 4 then
    state = 0
  end
end

--set a listener for enterFrame
RNListeners:addEventListener("enterFrame", updateCounter)