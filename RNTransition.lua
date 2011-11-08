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
require("RNUtil")

MOVE = "move"
ROTATE = "rotate"
SCALE = "scale"
ALPHA = "alpha"

-- Create a New Transition Object
RNTransition = {}

function RNTransition:new(o)
    o = o or {
        name = ""
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

mainSprite = nil

function RNTransition:run(target, params)

    local toX = target.x
    local toY = target.y

    local xScale = 0
    local yScale = 0

    local time = 1
    local delay = 1
    local type = ""
    local alpha = -1
    local angle = 0
    local mode = MOAIEaseType.SMOOTH

    if (params.type ~= nil) then
        type = params.type
    end

    if (params.x ~= nil) then
        toX = params.x
    end

    if (params.y ~= nil) then
        toY = params.y
    end

    if (params.xScale ~= nil) then
        xScale = params.xScale
    end

    if (params.yScale ~= nil) then
        yScale = params.yScale
    end

    if (params.time ~= nil) then
        time = params.time / 1000
    else
        time = 1
    end

    if (params.delay ~= nil) then
        delay = params.delay / 1000
    else
        delay = 0
    end

    if (params.alpha ~= nil) then
        alpha = params.alpha
    end

    if (params.angle ~= nil) then
        angle = params.angle
    end

    if (params.mode ~= nil) then
        mode = params.mode
    end


    if (type == MOVE) then
        local px, py = target:getProp():getLoc();

        local deltax = self:getDelta(px, toX)
        local deltay = self:getDelta(py, toY)

        if (toX < px) then
            deltax = (-1) * deltax
        end

        if (toY < py) then
            deltay = (-1) * deltay
        end

        local action = target:getProp():moveLoc(deltax, deltay, time)

        if (params.onComplete ~= nil) then
            action:setListener(MOAIAction.EVENT_STOP, function() params.onComplete(target) end)
        end
    end

    if (type == ROTATE) then
        local action = target:getProp():moveRot(angle, time)
        if (params.onComplete ~= nil) then
            action:setListener(MOAIAction.EVENT_STOP, function() params.onComplete(target) end)
        end
    end

    if (type == ALPHA) then
        action = target:getProp():seekColor(alpha, alpha, alpha, alpha, time, mode)

        if (params.onComplete ~= nil) then
            action:setListener(MOAIAction.EVENT_STOP, function() params.onComplete(target) end)
        end
    end


    if (type == SCALE) then
        action = target:getProp():moveScl(xScale, yScale, time, mode)
        if (params.onComplete ~= nil) then
            action:setListener(MOAIAction.EVENT_STOP, function() params.onComplete(target) end)
        end
    end
end

function RNTransition:getDelta(a, b)
    if (a > b) then
        return a - b
    else
        return b - a
    end
end