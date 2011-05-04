MOAISim.openWindow("test", 320, 480)

require("RNSprite")
require("RNSpriteButton")
require("RNScene")
require("RNTransition")
require("RNDirector")

mainsprite = nil

propTest = nil

scene = nil
sceneTwo = nil
director = nil

local function main()

    local background = RNSprite:new()
    scene = RNScene:new()
    director = RNDirector:new()

    print("Created scene: " .. scene:getName())

    scene:initWith(320, 480)
    scene:setName("main")

    background:initWith("background-purple.png")

    scene:addSpriteWithLocatingMode(background, RNSprite.TOP_LEFT_MODE)


    background:setLocation(0, 0)

    local sprite2 = RNSprite:new();

    sprite2:initWith("color_2.png")

    sprite2:setLocation(0, 0)

    local sprite3 = RNSprite:new();

    sprite3:initWith("color_1.png")

    sprite3:setLocation(100, 448)

    mainsprite = sprite2

    scene:addSpriteWithLocatingMode(sprite2, RNSprite.TOP_LEFT_MODE)
    scene:addSpriteWithLocatingMode(sprite3, RNSprite.TOP_LEFT_MODE)


    director:addScene(scene)

    sceneTwo = RNScene:new()

    sceneTwo:initWith(320, 480)
    sceneTwo:setName("two")

    local backgroundTwo = RNSprite:new()

    backgroundTwo:initWith("background-green.png")

    sceneTwo:addSpriteWithLocatingMode(backgroundTwo, RNSprite.TOP_LEFT_MODE)

    backgroundTwo:setLocation(0, 0)


    local sprite3 = RNSprite:new();

    sprite3:initWith("color_3.png")

    sprite3:setLocation(128, 128)

    sceneTwo:addSpriteWithLocatingMode(sprite3, RNSprite.TOP_LEFT_MODE)


    director:addScene(sceneTwo)
    director:startWithScene("two")
end

main()

function onTouchEvent(eventType, idx, x, y, tapCount)

    if (eventType == MOAITouchSensor.TOUCH_DOWN) then
        local animation = RNTransition:new()
        if (scene:isVisible()) then
            director:switch(RNDirector.SLIDE_TO_BOTTOM, "two")
        else
            director:switch(RNDirector.SLIDE_TO_RIGHT, "main")
        end
    end
end

MOAIInputMgr.device.touch:setCallback(onTouchEvent)