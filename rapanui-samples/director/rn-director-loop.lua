------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------

--RNDirector test , remove comments to test effects.



director = RNDirector:new()


director:addScene("rapanui-samples/director/scene1")
director:addScene("rapanui-samples/director/scene2")
director:addScene("rapanui-samples/director/scene3")
director:addScene("rapanui-samples/director/scene4")

--check if they are inside the director
for i, v in ipairs(director.scenes) do print(i, v) end

--counter, flag and state for loop
counter = 0
state = 1
canChange = false


--Set director's time
director:setTime(800)



--show first scene
director:showScene("rapanui-samples/director/scene1", "pop")




--for loop counter
function updateCounter()
    counter = counter + 1
    if counter == 200 then
        state = state + 1
        counter = 0
        canChange = true
    end
end

--perform showScene
function perform()
    if state == 2 and canChange == true then
        director:showScene("rapanui-samples/director/scene2", "pop")
        canChange = false
    elseif state == 3 and canChange == true then
        director:showScene("rapanui-samples/director/scene3", "fade")
        canChange = false
    elseif state == 4 and canChange == true then
        director:showScene("rapanui-samples/director/scene4", "slidetoleft")
        canChange = false
    elseif state == 5 and canChange == true then
        director:showScene("rapanui-samples/director/scene1", "slidetoright")
        canChange = false
    elseif state == 6 and canChange == true then
        director:showScene("rapanui-samples/director/scene2", "slidetotop")
        canChange = false
    elseif state == 7 and canChange == true then
        director:showScene("rapanui-samples/director/scene3", "slidetobottom")
        canChange = false
    elseif state == 8 and canChange == true then
        director:showScene("rapanui-samples/director/scene4", "fade")
        canChange = false
    elseif state == 9 and canChange == true then
        director:showScene("rapanui-samples/director/scene1", "pop")
        canChange = false
        state = 1
    end
end



--handling enterFrame
function step()
    updateCounter()
    perform()
end


--set a listener for enterFrame
RNListeners:addEventListener("enterFrame", step)