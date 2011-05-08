MOAISim.openWindow("test", 320, 480)

require("RNSprite")
--require("RNSpriteButton")
require("RNScene")
require("RNTransition")
require("RNDirector")
require("RNUtil")

mainsprite = nil

propTest = nil

scene = nil
sceneTwo = nil
director = nil
canMove = true

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
    sprite2:setAlpha(0.5)

    local sprite3 = RNSprite:new();

    sprite3:initWith("color_1.png")

    sprite3:setLocation(100, 448)

    mainsprite = sprite2

    scene:addSpriteWithLocatingMode(sprite2, RNSprite.TOP_LEFT_MODE)
    scene:addSpriteWithLocatingMode(sprite3, RNSprite.TOP_LEFT_MODE)

    director:addScene(scene)

    director:startWithScene("main")
end

main()

function onTouchEvent(eventType, idx, x, y, tapCount)

    if (eventType == MOAITouchSensor.TOUCH_DOWN and canMove) then
        canMove = false
        local animation = RNTransition:new()
        animation:run(RNTransition.MOVE, mainsprite, { x = x, y = y, time = 2, onEndFunction = callMeBack })
    end
end

function callMeBack()
    canMove = true
    print("done!")
end

MOAIInputMgr.device.touch:setCallback(onTouchEvent)