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




--[[
	  
	  SCENES MUST HAVE 
	  1)a sceneGroup where all instances are inserted
	  2)onCreate function in which we create everything
	  3)onEnd function in which we clean the instance

]] --

aScene = {}

local sceneGroup = RNGroup:new()



--init Scene
function aScene.onCreate()
    --add things to sceneGroup
    local background = RNFactory.createImage("images/background-purple.png", { parentGroup = sceneGroup }); background.x = 160; background.y = 240;
    local text1 = RNFactory.createText("This is the menu screen. Choose scene to go!", { size = 8, top = 150, left = 50, width = 200, height = 500 })
    sceneGroup:insert(text1)
    local button1 = RNFactory.createAnim("images/sceneButtons.png", 128, 64)
    button1.frame = 3
    sceneGroup:insert(button1)
    button1.x = 200; button1.y = 100
    local button2 = RNFactory.createAnim("images/sceneButtons.png", 128, 64)
    button2.frame = 5
    sceneGroup:insert(button2)
    button2.x = 150; button2.y = 200
    local button3 = RNFactory.createAnim("images/sceneButtons.png", 128, 64)
    button3.frame = 7
    sceneGroup:insert(button3)
    button3.x = 200; button3.y = 300



    button1:setOnTouchDown(button1Down)
    button2:setOnTouchDown(button2Down)
    button3:setOnTouchDown(button3Down)

    button1:setOnTouchUp(button1Up)
    button2:setOnTouchUp(button2Up)
    button3:setOnTouchUp(button3Up)

    --return sceneGroup
    return sceneGroup
end

function button1Down(event)
    event.target.frame = 4
end

function button2Down(event)
    event.target.frame = 6
end

function button3Down(event)
    event.target.frame = 8
end

function button1Up(event)
    event.target.frame = 3
    director:showScene("rapanui-samples/menu/scene2m", "slidetoleft")
end

function button2Up(event)
    event.target.frame = 5
    director:showScene("rapanui-samples/menu/scene3m", "slidetotop")
end

function button3Up(event)
    event.target.frame = 7
    director:showScene("rapanui-samples/menu/scene4m", "slidetobottom")
end


function aScene.onEnd()

    sceneGroup:remove()
end

return aScene



