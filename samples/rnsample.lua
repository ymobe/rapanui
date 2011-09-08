MOAISim.openWindow("test", 320, 480)

require("RNGlobals")
require("RNSpriteButton")
require("RNSprite")
require("RNScene")
require("RNTransition")
require("RNDirector")
require("RNInputManager")
require("RNUtil")

mainsprite = nil
mainspriteTwo = nil

propTest = nil

scene = nil
sceneTwo = nil
director = nil
canMove = true


function onTouchDown(x, y)
    print("onTouchDown Called from main sample!!")

    if (scene:isVisible()) then
        director:switch("two", { type = RNGlobals.SLIDE_TO_LEFT, time = 2, mode = MOAIEaseType.SOFT_EASE_OUT })
    else
        director:switch("main", { type = RNGlobals.CROSSFADE, mode = MOAIEaseType.SOFT_EASE_OUT })
    end
end

local function main()

    print("v1")

    local backgroundScene = RNSprite:new{}
    scene = RNScene:new()
    director = RNDirector:new()

    print("Created scene: " .. scene:getName())

    scene:initWith(320, 480)
    scene:setName("main")

    backgroundScene:initWith("images/background-purple.png")

    scene:addSprite(backgroundScene)

    backgroundScene:setLocation(0, 0)

    local sprite01scene = RNSprite:new()

    sprite01scene:initWith("images/catsprite_01.png")

    sprite01scene:setLocation(10, 10)
   -- sprite01scene:setAlpha(0.5)

    scene:addSprite(sprite01scene)


    local sprite02scene = RNSprite:new()

    sprite02scene:initWith("images/catsprite_02.png")

    --sprite3:setOnTouchDown(onTouchDown)
    --sprite3:testMethod()

    sprite02scene:setLocation(35, 350)

    sprite02scene:setAlpha(0.5)

    mainsprite = sprite01scene

    mainspriteTwo = sprite02scene

    scene:addSprite(sprite02scene)

    director:addScene(scene)

    sceneTwo = RNScene:new()

    sceneTwo:initWith(320, 480)
    sceneTwo:setName("two")

    local backgroundTwo = RNSprite:new()

    backgroundTwo:initWith("images/background-green.png")

    sceneTwo:addSprite(backgroundTwo)

    backgroundTwo:setLocation(0, 0)


    local sprite3 = RNSprite:new();

    sprite3:initWith("images/khsprite.png")

    sprite3:setLocation(128, 128)

    sceneTwo:addSprite(sprite3)


    director:addScene(sceneTwo)
    director:startWithScene("main")

    RNInputManager.setOnTouchDown(onTouchDown)
    RNInputManager.setOnTouchUp(onTouchUp)
    RNInputManager.setOnTouchMove(onTouchMove)
    RNInputManager.setOnTouchCancel(onTouchCancel)
end

main()



function onTouchMove(x, y)
    print("onTouchMove Called Called from main sample!! ")
end

function onTouchUp(x, y)
    print("onTouchUp Called Called from main sample!!")
end

function onTouchCancel(x, y)
    print("onTouchCancel Called Called from main sample!! ")
end

