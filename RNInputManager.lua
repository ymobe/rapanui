module(..., package.seeall)
require("RNUtil")

----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------

function RNInputManager:new(o)

    o = o or {
        name = "RNInputManager",
        listeners = {},
        size = 0,
        pointerX,
        pointerY
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

innerInputManager = RNInputManager:new()


function init()
    if MOAIInputMgr.device.pointer then
    -- mouse input
        MOAIInputMgr.device.pointer:setCallback(onPointer)
        MOAIInputMgr.device.mouseLeft:setCallback(onClick)
    else
        MOAIInputMgr.device.touch:setCallback(onEvent)
    end

    RNInputManager.addListener(innerInputManager)
end

function RNInputManager:getPointerX()
    return self.pointerX
end

function RNInputManager:getPointerY()
    return self.pointerY
end

function RNInputManager:setPointerX(x)
    self.pointerX = x
end

function RNInputManager:setPointerY(y)
    self.pointerY = y
end

function addListener(listener)
    innerInputManager:addListenerToList(listener)
end

function RNInputManager:addListenerToList(listener)
-- print("ADDDING!")
-- print_r(listener)
    self.listeners[self.size] = listener
    self.size = self.size + 1
end

function RNInputManager:getListeners()
    return self.listeners
end

function onPointer(x, y)
    innerInputManager:setPointerX(x)
    innerInputManager:setPointerY(y)
end

function onClick(down)

    if down then
        local x = innerInputManager:getPointerX()
        local y = innerInputManager:getPointerY()
        onEvent(MOAITouchSensor.TOUCH_DOWN, -1, x, y, 0)
    end
end


function setOnTouchDown(func)
    innerInputManager:setGlobalOnTouchDown(func)
end

function setOnTouchMove(func)
    innerInputManager:setGlobalOnTouchMove(func)
end

function setOnTouchUp(func)
    innerInputManager:setGlobalOnTouchUp(func)
end

function setOnTouchCancel(func)
    innerInputManager:setGlobalOnTouchCancel(func)
end

function RNInputManager:setGlobalOnTouchDown(func)
    self.globalOnTouchDown = func
end

function RNInputManager:getGlobalOnTouchDown()
    return self.globalOnTouchDown
end

function RNInputManager:setGlobalOnTouchMove(func)
    self.globalOnTouchMove = func
end

function RNInputManager:getGlobalOnTouchMove()
    return self.globalOnTouchMove
end

function RNInputManager:setGlobalOnTouchUp(func)
    self.globalOnTouchUp = func
end

function RNInputManager:getGlobalOnTouchUp()
    return self.globalOnTouchUp
end

function RNInputManager:setGlobalOnTouchCancel(func)
    self.globalOnTouchCancel = func
end

function RNInputManager:getGlobalOnTouchCancel()
    return self.globalOnTouchCancel
end

--[[
function defaultOnTouchDown(x, y, source)
print("defaultOnTouchDown onTouchDown Called on x of ")
end

function defaultOnTouchMove(x, y, source)
print("defaultOnTouchMove onTouchMove Called on x of ")
end

function defaultOnTouchUp(x, y, source)
print("defaultOnTouchUp onTouchUp Called on x of ")
end

function defaultOnTouchCancel(x, y, source)
print("defaultOnTouchCancel onTouchCancel Called on x of ")
end         ]] --

function RNInputManager:onTouchDown(x, y, source)
    if innerInputManager:getGlobalOnTouchDown() ~= nil then
    -- print("RNInputManager bind function onTouchDown Called")
        innerInputManager.globalOnTouchDown(x, y, source)
    end
end

function RNInputManager:onTouchMove(x, y, source)
    if innerInputManager:getGlobalOnTouchMove() ~= nil then
        print("RNInputManager bind function onTouchMove Called")
        innerInputManager.globalOnTouchMove(x, y, source)
    end
end

function RNInputManager:onTouchUp(x, y, source)
    if innerInputManager:getGlobalOnTouchUp() ~= nil then
        print("RNInputManager bind function onTouchUp Called")
        innerInputManager.globalOnTouchUp(x, y, source)
    end
end

function RNInputManager:onTouchCancel(x, y, source)
    if innerInputManager:getGlobalOnTouchCancel() ~= nil then
        print("RNInputManager bind function onTouchCancel Called")
        innerInputManager.globalOnTouchCancel(x, y, source)
    end
end

-- types of touches:

-- TOUCH_DOWN
-- TOUCH_MOVE
-- TOUCH_UP
-- TOUCH_CANCEL

function onEvent(eventType, idx, x, y, tapCount)
    for key, value in pairs(innerInputManager:getListeners())
    do

        if (eventType == MOAITouchSensor.TOUCH_DOWN) then
            value:onTouchDown(x, y, value)
        end

        if (eventType == MOAITouchSensor.TOUCH_MOVE) then
            value:onTouchMove(x, y, value)
        end

        if (eventType == MOAITouchSensor.TOUCH_UP) then
            value:onTouchUp(x, y, value)
        end

        if (eventType == MOAITouchSensor.TOUCH_CANCEL) then
            value:onTouchCancel(x, y, value)
        end
    end
end

RNInputManager.init()
