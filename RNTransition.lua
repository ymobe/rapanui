----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------

module(..., package.seeall)


MOVE = "move"
ROTATE = "rotate"

-- Create a New Transition Object
function RNTransition:new(o)
    o = o or {
        name = ""
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

mainSprite = nil


function RNTransition:run(type, sprite, props)

    local toX = sprite:getX();
    local toY = sprite:getY();
    local time = 1

    if (props.x ~= nil) then
        toX = props.x
    end

    if (props.y ~= nil) then
        toY = props.y
    end

    if (props.time ~= nil) then
        time = props.time
    else
        time = 1
    end


    if (type == MOVE) then
        local px, py = sprite:getProp():getLoc();
        local deltax = self:getDelta(px, toX)
        local deltay = self:getDelta(py, toY)

        if (toX < px) then
            deltax = (-1) * deltax
        end

        if (toY < py) then
            deltay = (-1) * deltay
        end

        local action = sprite:getProp():moveLoc(deltax, deltay, time)

        if (props.onEndFunction ~= nil) then
            action:setListener(MOAIAction.EVENT_STOP, props.onEndFunction)
        end
    end

    if (type == ROTATE) then
        local action = sprite:getProp():moveRot(-360, 2)
    end
end

function RNTransition:getDelta(a, b)
    if (a > b) then
        return a - b
    else
        return b - a
    end
end