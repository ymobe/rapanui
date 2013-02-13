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

RNTransition = {}

RNTransition.MOVE = "move"
RNTransition.ROTATE = "rotate"
RNTransition.SCALE = "scale"
RNTransition.ALPHA = "alpha"

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
    --local mode = MOAIEaseType.LINEAR
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

    local root_action = MOAIAction.new()

    local deltax, deltay = 0, 0

    if (type == RNTransition.MOVE) then
        local px, py, pz


        if target:getType() == "RNObject" then
            px, py = target:getProp():getLoc()
        elseif target:getType() == "RNText" then
            px, py = target:getProp():getLoc()
        elseif target:getType() == "RNButton" then
            px, py = target:getLoc()
        elseif target:getType() == "RNMap" then
            px, py = target:getLoc();
        elseif target:getType() == "RNGroup" or target:getType() == "RNBitmapText" then
            px, py = target.x, target.y
        end

        deltax = self:getDelta(px, toX)
        deltay = self:getDelta(py, toY)

        if (toX < px) then
            deltax = (-1) * deltax
        end

        if (toY < py) then
            deltay = (-1) * deltay
        end


        if target:getType() == "RNObject" then
            local action = target:getProp():moveLoc(deltax, deltay, time, mode)
            action:attach(root_action)
        elseif target:getType() == "RNMap" then
            for key, prop in pairs(target:getAllProps()) do
                local action = prop:moveLoc(deltax, deltay, time, mode)
                action:attach(root_action)
            end
        elseif target:getType() == "RNButton" then
            for key, prop in pairs(target:getAllRNObjectProps()) do
                local action = prop:moveLoc(deltax, deltay, time, mode)
                action:attach(root_action)
            end
            local action = target:getRNtext():getProp():moveLoc(deltax, deltay, 0, time, mode)
            action:attach(root_action)
        elseif target:getType() == "RNText" then
            local action = target:getProp():moveLoc(deltax, deltay, 0, time, mode)
            action:attach(root_action)
        elseif target:getType() == "RNGroup" or target:getType() == "RNBitmapText" then
            local action = target:getProp():moveLoc(deltax, deltay, time, mode)
            action:attach(root_action)
            target.lastx = toX
            target.lasty = toY
            for key, object in pairs(target:getAllNonGroupChildren()) do
                if object:getType() == "RNObject" then
                    local action = object:getProp():moveLoc(deltax, deltay, time, mode)
                    action:attach(root_action)
                elseif object:getType() == "RNMap" then
                    for key2, prop2 in pairs(object:getAllProps()) do
                        local action = prop2:moveLoc(deltax, deltay, time, mode)
                        action:attach(root_action)
                    end
                elseif object:getType() == "RNButton" then
                    for key2, prop2 in pairs(object:getAllRNObjectProps()) do
                        local action = prop2:moveLoc(deltax, deltay, time, mode)
                        action:attach(root_action)
                    end

                    local action = object:getRNtext():getProp():moveLoc(deltax, deltay, 0, time, mode)
                    action:attach(root_action)

                elseif object:getType() == "RNText" then
                    local action = object:getProp():moveLoc(deltax, deltay, 0, time, mode)
                    action:attach(root_action)
                end
            end
        end
    end


    if (type == RNTransition.ROTATE) then
        if target:getType() == "RNObject" then
            local action = target:getProp():moveRot(angle, time)
            action:attach(root_action)
        elseif target:getType() == "RNText" then
            -- action = target:getProp():moveRot(angle, angle, 0, time)
            local action = target:getProp():moveRot(0, 0, angle, time)
            action:attach(root_action)
        elseif target:getType() == "RNButton" then
            print("[WARN] RNButton: RNTransition.ROTATE unsupported")
        elseif target:getType() == "RNMap" then
            for key, prop in pairs(target:getAllProps()) do
                local action = prop:moveRot(angle, time)
                action:attach(root_action)
            end
        elseif target:getType() == "RNGroup" then
            for key, object in pairs(target:getAllNonGroupChildren()) do
                if object:getType() == "RNObject" then
                    local action = object:getProp():moveRot(angle, time)
                    action:attach(root_action)
                elseif object:getType() == "RNText" then
                    local action = object:getProp():moveRot(0, 0, angle, time)
                    action:attach(root_action)
                elseif object:getType() == "RNMap" then
                    for key2, prop2 in pairs(object:getAllProps()) do
                        local action = prop2:moveRot(angle, time)
                        action:attach(root_action)
                    end
                end
            end
        end
    end


    if (type == RNTransition.ALPHA) then
        if target:getType() == "RNObject" or target:getType() == "RNText" then
            local action = target:getProp():seekColor(alpha, alpha, alpha, alpha, time, mode)
            action:attach(root_action)
        elseif target:getType() == "RNButton" then
            for key, prop in pairs(target:getAllProps()) do
                local action = prop:seekColor(alpha, alpha, alpha, alpha, time, mode)
                action:attach(root_action)
            end
        elseif target:getType() == "RNMap" then
            for key, prop in pairs(target:getAllProps()) do
                local action = prop:seekColor(alpha, alpha, alpha, alpha, time, mode)
                action:attach(root_action)
            end
        elseif target:getType() == "RNGroup" or target:getType() == "RNBitmapText" then
            for key, object in pairs(target:getAllNonGroupChildren()) do
                if object:getType() == "RNObject" or object:getType() == "RNText" then
                    local action = object:getProp():seekColor(alpha, alpha, alpha, alpha, time, mode)
                    action:attach(root_action)
                elseif object:getType() == "RNMap" then
                    for key2, prop2 in pairs(object:getAllProps()) do
                        local action = prop2:seekColor(alpha, alpha, alpha, alpha, time, mode)
                        action:attach(root_action)
                    end
                elseif object:getType() == "RNButton" then
                    for key, prop in pairs(object:getAllProps()) do
                        local action = prop:seekColor(alpha, alpha, alpha, alpha, time, mode)
                        action:attach(root_action)
                    end
                end
            end
        end
    end


    if (type == RNTransition.SCALE) then
        if target:getType() == "RNObject" then
            local action = target:getProp():moveScl(xScale, yScale, time, mode)
            action:attach(root_action)
        elseif target:getType() == "RNText" then
            local action = target:getProp():moveScl(xScale, yScale, 0, time, mode)
            action:attach(root_action)
        elseif target:getType() == "RNButton" then
            print("[WARN] RNButton: RNTransition.SCALE unsupported")
            --     elseif target:getType() == "RNButton" then
            --         for key, prop in pairs(target:getAllRNObjectProps()) do
            --             action = prop:moveScl(xScale, yScale, time, mode)
            --         end
            --         action = target:getRNtext():getProp():moveScl(xScale, yScale, 0, time, mode)
        elseif target:getType() == "RNMap" then
            for key, prop in pairs(target:getAllProps()) do
                local action = prop:moveScl(xScale, yScale, time, mode)
                action:attach(root_action)
            end
        elseif target:getType() == "RNGroup" then
            for key, object in pairs(target:getAllNonGroupChildren()) do
                if object:getType() == "RNObject" then
                    local action = object:getProp():moveScl(xScale, yScale, time, mode)
                    action:attach(root_action)
                elseif object:getType() == "RNText" then
                    local action = object:getProp():moveScl(xScale, yScale, 0, time, mode)
                    action:attach(root_action)
                elseif object:getType() == "RNMap" then
                    for key2, prop2 in pairs(object:getAllProps()) do
                        local action = prop2:moveScl(xScale, yScale, time, mode)
                        action:attach(root_action)
                    end
                end
            end
        end
    end

    root_action:start()

    if (params.onComplete ~= nil and root_action ~= nil) then
        root_action:setListener(MOAIAction.EVENT_STOP, function() self.updateMapLoc(self, target, toX, toY, deltax, deltay) params.onComplete(target) end)
    elseif (root_action ~= nil) then
        root_action:setListener(MOAIAction.EVENT_STOP, function() self.updateMapLoc(self, target, toX, toY, deltax, deltay) end)
    end


    return root_action
end

function RNTransition:updateMapLoc(target, x, y, deltax, deltay)
    -- if the target is a RNMap or a RNGroup with a RNMap inside we need to upate the x,y location.
    if target:getType() == "RNMap" then
        target.mapx = x
        target.mapy = y
    elseif target:getType() == "RNGroup" then

        --   if deltax == nil then
        --       deltax = 0
        --   end

        --   if deltay == nil then
        --       deltay = 0
        --   end


        for key, object in pairs(target:getAllNonGroupChildren()) do
            if object:getType() == "RNMap" then
                object.mapx = object.mapx + deltax
                object.mapy = object.mapy + deltay
            end
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

return RNTransition