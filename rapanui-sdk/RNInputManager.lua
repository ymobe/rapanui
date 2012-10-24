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

-- types of touches:

-- TOUCH_DOWN
-- TOUCH_MOVE
-- TOUCH_UP
-- TOUCH_CANCEL


CURRENT_TARGET_LEVEL_DEFAULT = 99999999999999
CURRENT_TARGET_LEVEL = CURRENT_TARGET_LEVEL_DEFAULT



DRAGGING = false
DRAGGED_TARGET = nil
LAST_xSTART = nil
LAST_ySTART = nil
isTOUCHING = false
TOUCHES = 0

RNInputManager = {}

function RNInputManager:new(o)

    o = o or {
        name = "RNInputManager",
        listeners = {},
        size = 0,
        pointerX=nil,
        pointerY=nil,
    }

    setmetatable(o, self)
    self.__index = self

    self.events = { "touch" }
    self.events["touch"] = {}
    self.globalevents = { "touch" }
    self.globalevents["touch"] = {}
    self.eventsSize = { "touch" }
    self.eventsSize["touch"] = 0
    self.globaleventsSize = { "touch" }
    self.globaleventsSize["touch"] = 0
    return o
end


innerInputManager = RNInputManager:new()


function RNInputManager.init()
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


function RNInputManager.setGlobalRNScreen(RNScreen)
    innerInputManager:setScreen(RNScreen)
end


function RNInputManager:setScreen(RNScreen)
    self.screen = RNScreen
end


function RNInputManager:getScreen()
    return self.screen
end


function RNInputManager.addListener(listener)

    innerInputManager:addListenerToList(listener)
end


function RNInputManager.addListenerToEvent(eventName, func, object)
    innerInputManager:innerAddListenerToEvent(eventName, func, object)
end

function RNInputManager.addGlobalListenerToEvent(eventName, func, params)

    local name, target

    if (params.name ~= nil) then
        name = params.name
    end

    if (params.target ~= nil) then
        target = params.target
    end

    return innerInputManager:innerAddGlobalListenerToEvent(eventName, func, name, target)
end

function RNInputManager.removeGlobalListenerToEvent(eventName, id)
    return innerInputManager:innerRemoveGlobalListenerToEvent(eventName, id)
end


function RNInputManager:getListenersToEvent(eventName)
    return self.events[eventName]
end

function RNInputManager:getGlobalListenersToEvent(eventName)
    return self.globalevents[eventName]
end


function RNInputManager:innerRemoveGlobalListenerToEvent(eventName, id)

    local globallisteners = self.globalevents[eventName]

    if globallisteners ~= nil then
        local globallistenrsSize = self.globaleventsSize[eventName]
        local aListener = globallisteners[id - 1]
        aListener:scheduleForRemoval()
    end
end

function RNInputManager:innerAddListenerToEvent(eventName, func, object)

    local listeners = self.events[eventName]

    if listeners ~= nil then
        local listenrsSize = self.eventsSize[eventName]
        local aListener = RNWrappedEventListener:new()
        aListener:setFunction(func)
        aListener:setTarget(object)
        listeners[listenrsSize] = aListener
        self.eventsSize[eventName] = listenrsSize + 1
    end
end

function RNInputManager:innerAddGlobalListenerToEvent(eventName, func, name, target)

    local globallisteners = self.globalevents[eventName]

    if globallisteners ~= nil then
        local globallistenrsSize = self.globaleventsSize[eventName]
        local aListener = RNWrappedEventListener:new()
        aListener:setFunction(func)
        if target ~= nil then
            aListener:setTarget(target)
        end
        aListener.name = name
        globallisteners[globallistenrsSize] = aListener
        self.globaleventsSize[eventName] = globallistenrsSize + 1
        return self.globaleventsSize[eventName]
    end

    return listenerId
end


function RNInputManager:addListenerToList(listener)
    self.listeners[self.size] = listener
    self.size = self.size + 1
end

function RNInputManager:getListeners()
    return self.listeners
end

function onPointer(x, y)
    innerInputManager:setPointerX(x)
    innerInputManager:setPointerY(y)
    if isTOUCHING == true then
        onEvent(MOAITouchSensor.TOUCH_MOVE, -1, x, y, 0)
    end
end


function onClick(down)
    if down then
        local x = innerInputManager:getPointerX()
        local y = innerInputManager:getPointerY()
        onEvent(MOAITouchSensor.TOUCH_DOWN, -1, x, y, 0)
        isTOUCHING = true
    else
        local x = innerInputManager:getPointerX()
        local y = innerInputManager:getPointerY()
        onEvent(MOAITouchSensor.TOUCH_UP, -1, x, y, 0)
        isTOUCHING = false
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

function RNInputManager:onTouchDown(x, y, source)
    if innerInputManager:getGlobalOnTouchDown() ~= nil then
        innerInputManager.globalOnTouchDown(x, y, source)
    end
end


function RNInputManager:onTouchMove(x, y, source)
    if innerInputManager:getGlobalOnTouchMove() ~= nil then
        innerInputManager.globalOnTouchMove(x, y, source)
    end
end


function RNInputManager:onTouchUp(x, y, source)
    if innerInputManager:getGlobalOnTouchUp() ~= nil then
        innerInputManager.globalOnTouchUp(x, y, source)
    end
end


function RNInputManager:onTouchCancel(x, y, source)
    if innerInputManager:getGlobalOnTouchCancel() ~= nil then
        innerInputManager.globalOnTouchCancel(x, y, source)
    end
end


function onEvent(eventType, idx, x, y, tapCount)
    if x == nil then
        TOUCHES = 0
    end

    if x ~= nil then

        local event = RNEvent:new()
        event.id = idx
        event.tapCount = tapCount

        local screen = RNFactory.getCurrentScreen()

        if x == nil then TOUCHES = 0 end

        if x ~= nil then
            local x, y = RNFactory.screen.layer:wndToWorld(x, y)
            event.x, event.y = x, y
        end
        local currenTarget = screen:getRNObjectWithHighestLevelOn(x, y);
        event:initWithEventType(eventType)


        local globallisteners = innerInputManager:getGlobalListenersToEvent("touch")

        if globallisteners ~= nil then

            for key, value in pairs(globallisteners) do
                if value ~= nil and value:isToRemove() ~= true then
                    local breakHere = value:call(event)
                else
                    globallisteners[key] = nil
                end
            end
        end

        if currenTarget ~= nil and currenTarget.onTouchCallBackFunction ~= nil then
            event.target = currenTarget.onTouchCallBackFunction:getTarget()
            currenTarget.onTouchCallBackFunction:call(event)
        end

        --check if the target has value and if has function isListening
        if (currenTarget ~= nil and currenTarget.isListening == nil) or
                -- or if currenTarget has a valid value and if is listening on at least one event
                (currenTarget ~= nil and currenTarget:isListening() == false and DRAGGED_TARGET == nil) then
            return
        end



        local target

        if (eventType == MOAITouchSensor.TOUCH_DOWN) then
            event.phase = "began"
            if currenTarget ~= nil then
                LAST_xSTART = x
                LAST_ySTART = y
                DRAGGED_TARGET = currenTarget
                event.target = currenTarget
                TOUCHES = TOUCHES + 1
                event.touchesNumber = TOUCHES
                DRAGGING = true
                DRAGGED_TARGET:onEvent(event)
            end
        end

        if (eventType == MOAITouchSensor.TOUCH_MOVE) then
            event.phase = "moved"
            if DRAGGED_TARGET ~= nil then
                event.target = DRAGGED_TARGET
                event.touchesNumber = TOUCHES
                DRAGGED_TARGET:onEvent(event)
            end
        end

        if (eventType == MOAITouchSensor.TOUCH_UP) then
            event.phase = "ended"
            if DRAGGED_TARGET ~= nil then
                event.xStart = LAST_xSTART
                event.yStart = LAST_ySTART
                event.target = DRAGGED_TARGET
                TOUCHES = TOUCHES - 1
                event.touchesNumber = TOUCHES
                DRAGGED_TARGET:onEvent(event)
            end

            if TOUCHES == 0 then
                DRAGGED_TARGET = nil
                DRAGGING = false
            end
        end

        if (eventType == MOAITouchSensor.TOUCH_CANCEL) then
            event.phase = "cancelled"
            if DRAGGED_TARGET ~= nil then
                event.target = DRAGGED_TARGET
                DRAGGED_TARGET:onEvent(event)
                DRAGGED_TARGET = nil
            end
            DRAGGING = false
        end
    end
end

RNInputManager.init()

return RNInputManager