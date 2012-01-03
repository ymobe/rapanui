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

-- types of touches:

-- TOUCH_DOWN
-- TOUCHMOVE
-- TOUCH_UP
-- TOUCH_CANCEL


local CURRENT_TARGET_LEVEL_DEFAULT = 99999999999999
local CURRENT_TARGET_LEVEL = CURRENT_TARGET_LEVEL_DEFAULT

local RNInputManager = {}

local DRAGGING = false
local DRAGGED_TARGET_LISTENER = nil
local LAST_xSTART = nil
local LAST_ySTART = nil
local isTOUCHING = false
local layer
local R
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

local innerInputManager = RNInputManager:new()


function RNInputManager.init()
if not R then R = RN end
layer = R.Factory.screen
    if MOAIInputMgr.device.pointer then
        -- mouse input
        MOAIInputMgr.device.pointer:setCallback(RNInputManager.onPointer)
        MOAIInputMgr.device.mouseLeft:setCallback(RNInputManager.onClick)
    else
        MOAIInputMgr.device.touch:setCallback(RNInputManager.onEvent)
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

function RNInputManager.addGlobalListenerToEvent(eventName, func, object)
    innerInputManager:innerAddGlobalListenerToEvent(eventName, func)
end


function RNInputManager:getListenersToEvent(eventName)
    return self.events[eventName]
end

function RNInputManager:getGlobalListenersToEvent(eventName)
    return self.globalevents[eventName]
end


function RNInputManager:innerAddListenerToEvent(eventName, func, object)
    local listeners = self.events[eventName]

    if listeners ~= nil then
        local listenrsSize = self.eventsSize[eventName]
        local aListener = R.WrappedEventListener:new()
        aListener:setFunction(func)
        aListener:setTarget(object)
        listeners[listenrsSize] = aListener
        self.eventsSize[eventName] = listenrsSize + 1
    end
end

function RNInputManager:innerAddGlobalListenerToEvent(eventName, func)
    local globallisteners = self.globalevents[eventName]
    if globallisteners ~= nil then
        local globallistenrsSize = self.globaleventsSize[eventName]
        local aListener = R.WrappedEventListener:new()
        aListener:setFunction(func)
        globallisteners[globallistenrsSize] = aListener
        self.globaleventsSize[eventName] = globallistenrsSize + 1
    end
end


function RNInputManager:addListenerToList(listener)
    self.listeners[self.size] = listener
    self.size = self.size + 1
end

function RNInputManager:getListeners()
    return self.listeners
end

function RNInputManager.onPointer(x, y)
    innerInputManager:setPointerX(x)
    innerInputManager:setPointerY(y)
    if isTOUCHING == true then
        RNInputManager.onEvent(MOAITouchSensor.TOUCHMOVE, -1, x, y, 0)
    end
end


function RNInputManager.onClick(down)
    if down then
        local x = innerInputManager:getPointerX()
        local y = innerInputManager:getPointerY()
        RNInputManager.onEvent(MOAITouchSensor.TOUCH_DOWN, -1, x, y, 0)
        isTOUCHING = true
    else
        local x = innerInputManager:getPointerX()
        local y = innerInputManager:getPointerY()
        RNInputManager.onEvent(MOAITouchSensor.TOUCH_UP, -1, x, y, 0)
        isTOUCHING = false
    end
end


function RNInputManager.setOnTouchDown(func)
    innerInputManager:setGlobalOnTouchDown(func)
end


function RNInputManager.setOnTouchMove(func)
    innerInputManager:setGlobalOnTouchMove(func)
end


function RNInputManager.setOnTouchUp(func)
    innerInputManager:setGlobalOnTouchUp(func)
end


function RNInputManager.setOnTouchCancel(func)
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

local prev = {}

function RNInputManager.onEvent(eventType, idx, x, y, tapCount)
    local event = R.Event:new()

    local x, y = layer.layer:wndToWorld ( x, y )
    event.x, event.y = x, y

    local listeners
    local target


    local listeners = innerInputManager:getListenersToEvent("touch")
    local globallisteners = innerInputManager:getGlobalListenersToEvent("touch")

    if (eventType == MOAITouchSensor.TOUCH_DOWN) then
        event.phase = "began"
        event.down = true
        LAST_xSTART = x
        LAST_ySTART = y
    end

    if (eventType == MOAITouchSensor.TOUCHMOVE) then
        event.phase = "moved"
        event.down = true
    end

    if (eventType == MOAITouchSensor.TOUCH_UP) then
        event.phase = "ended"
		event.down = false
        event.xStart = LAST_xSTART
        event.yStart = LAST_ySTART

        local lastLevelValue = -99999999999999

        DRAGGED_TARGET_LISTENER = nil
        DRAGGING = false
    end

    if (eventType == MOAITouchSensor.TOUCH_CANCEL) then
        event.phase = "cancelled"
        DRAGGED_TARGET_LISTENER = nil
        DRAGGING = false
    end

    if event.phase == "began" then

        local lastLevelValue = -99999999999999
        local lastlistener

        for key, value in pairs(listeners) do

            if value:isToCall(x, y) and value:getTarget():getLevel() >= lastLevelValue then
                event.target = value:getTarget()
                lastLevelValue = value:getTarget():getLevel()
                lastlistener = value
                prev.target = event.target
               -- prev.target.awake = false --temp fix
            end
        end

        DRAGGED_TARGET_LISTENER = lastlistener
        DRAGGING = true
    end

    if listeners ~= nil and DRAGGING ~= true then
        for key, value in pairs(listeners) do
            event.target = value:getTarget()
            if value:isToCall(x, y) then
                local breakHere = value:call(event)
                if breakHere then
                end
            end
        end
    else
        if DRAGGED_TARGET_LISTENER ~= nil then
            event.target = DRAGGED_TARGET_LISTENER:getTarget()
            local breakHere = DRAGGED_TARGET_LISTENER:call(event)
            if breakHere then
            end
        end
    end

    if globallisteners ~= nil then
        for key, value in pairs(globallisteners) do
            local breakHere = value:call(event)
        end
    end
    if event.phase == "ended" and prev.target then
       prev.target.awake = true
       prev.target = nil
    end
end
return RNInputManager