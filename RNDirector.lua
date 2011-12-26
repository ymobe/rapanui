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

--global vars
--global time for transitions
local TIME = 800
--other globals
local CURRENT_SCENE
local NEXT_SCENE
local NEXT_SCENE_GROUP
local CURRENT_SCENE_NAME
local CURRENT_SCENE_GROUP
local DIRECTOR
local TRANSITIONING = false
local trn = RNTransition:new()


-- Create a new RNDirector Object
RNDirector = {}

function RNDirector:new(o)

    o = o or {
        name = "",
        scenes = {}
    }

    setmetatable(o, self)
    self.__index = self
    DIRECTOR = self
    return o
end

function RNDirector:isTransitioning()
    return TRANSITIONING
end

--add a scene to Director and set it to invisible . scene must be an instance of RNGroup
function RNDirector:addScene(scene)
    local len = table.getn(self.scenes)
    self.scenes[len + 1] = scene
end


--sets the time of transitions
function RNDirector:setTime(value)
    TIME = value
end


--Functions to show/hide  a scene with the given effect
function RNDirector:showScene(name, effect)

    if name ~= nil then
        NEXT_SCENE = require(name)
    else
        NEXT_SCENE = nil
    end

    if TRANSITIONING == false then
        TRANSITIONING = true
        if effect == "slidetoleft" then
            self:slideout(config.width, 0)
        elseif effect == "slidetoright" then
            self:slideout(-config.width, 0)
        elseif effect == "slidetotop" then
            self:slideout(0, config.height)
        elseif effect == "slidetobottom" then
            self:slideout(0, -config.height)
        elseif effect == "pop" then
            self:popIn()
        elseif effect == "fade" then
            self:fade()
        elseif effect == "crossfade" then
            self:crossFade()
        else
            self:popIn()
        end
    end
end

function RNDirector:hideCurrentScene(effect)
    self:showScene(nil, effect)
end


------------------------- pop effect -------------------------------------------------------------
function RNDirector:popIn()

    if CURRENT_SCENE ~= nil then
        CURRENT_SCENE.onEnd()
    end

    if NEXT_SCENE ~= nil then
        CURRENT_SCENE_GROUP = NEXT_SCENE.onCreate()
        CURRENT_SCENE = NEXT_SCENE
    end
    TRANSITIONING = false
end


------------------------- slide effect -----------------------------------------------------------
function RNDirector:slideout(xx, yy)

    --start slide
    if CURRENT_SCENE_GROUP ~= nill then
        for i = 1, table.getn(CURRENT_SCENE_GROUP.displayObjects), 1 do
            if i == table.getn(CURRENT_SCENE_GROUP.displayObjects) then --call transition end callback only for last element
                trn:run(CURRENT_SCENE_GROUP.displayObjects[i], { type = "move", x = CURRENT_SCENE_GROUP.displayObjects[i].x - xx, y = CURRENT_SCENE_GROUP.displayObjects[i].y - yy, time = TIME, onComplete = slideEnd })
            else
                trn:run(CURRENT_SCENE_GROUP.displayObjects[i], { type = "move", x = CURRENT_SCENE_GROUP.displayObjects[i].x - xx, y = CURRENT_SCENE_GROUP.displayObjects[i].y - yy, time = TIME })
            end
        end
    end

    -- if next scene has a value go for transition
    if NEXT_SCENE ~= nil then
        -- change the current scene group
        NEXT_SCENE_GROUP = NEXT_SCENE.onCreate()
        NEXT_SCENE_GROUP.x = xx
        NEXT_SCENE_GROUP.y = yy
        --start slide
        for i = 1, table.getn(NEXT_SCENE_GROUP.displayObjects), 1 do
            if CURRENT_SCENE_GROUP == nil and i == table.getn(NEXT_SCENE_GROUP.displayObjects) then --if CURRENT_SCENE nil we have to call endSlide on last element transition
                trn:run(NEXT_SCENE_GROUP.displayObjects[i], { type = "move", x = NEXT_SCENE_GROUP.displayObjects[i].x - xx, y = NEXT_SCENE_GROUP.displayObjects[i].y - yy, time = TIME, onComplete = slideEnd })
            else
                trn:run(NEXT_SCENE_GROUP.displayObjects[i], { type = "move", x = NEXT_SCENE_GROUP.displayObjects[i].x - xx, y = NEXT_SCENE_GROUP.displayObjects[i].y - yy, time = TIME })
            end
        end
    end
end


function slideEnd()

    if CURRENT_SCENE ~= nil then
        CURRENT_SCENE.onEnd()
    end

    if NEXT_SCENE ~= nil then
        NEXT_SCENE_GROUP.x = 0
        NEXT_SCENE_GROUP.y = 0
        CURRENT_SCENE_GROUP = NEXT_SCENE_GROUP
        CURRENT_SCENE = NEXT_SCENE
    end
    TRANSITIONING = false
    collectgarbage("collect")
end


---------------------------- crossfade effect----------------------------------------------------
function RNDirector:crossFade()

    if CURRENT_SCENE_GROUP ~= nil then --if it's first call we don't have a CURRENT_SCENE or CURRENT_SCENE_GROUP

        for i = 1, table.getn(CURRENT_SCENE_GROUP.displayObjects), 1 do
            if NEXT_SCENE == nil and i == table.getn(CURRENT_SCENE_GROUP.displayObjects) then
                trn:run(CURRENT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 0, time = TIME, onComplete = DIRECTOR.endFade })
            else
                trn:run(CURRENT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 0, time = TIME })
            end
        end
    end

    if NEXT_SCENE ~= nil then

        NEXT_SCENE_GROUP = NEXT_SCENE.onCreate()

        for i = 1, table.getn(NEXT_SCENE_GROUP.displayObjects), 1 do
            NEXT_SCENE_GROUP.displayObjects[i]:setAlpha(0)
        end

        for i = 1, table.getn(NEXT_SCENE_GROUP.displayObjects), 1 do
            if i == table.getn(NEXT_SCENE_GROUP.displayObjects) then
                trn:run(NEXT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 1, time = TIME, onComplete = DIRECTOR.endFade })
            else
                trn:run(NEXT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 1, time = TIME })
            end
        end
    end
end



---------------------------- fade effect---------------------------------------------------------
function RNDirector:fade()

    if CURRENT_SCENE_GROUP ~= nill then --if it's first call we don't have a CURRENT_SCENE or CURRENT_SCENE_GROUP
        for i = 1, table.getn(CURRENT_SCENE_GROUP.displayObjects), 1 do
            if i == table.getn(CURRENT_SCENE_GROUP.displayObjects) then
                if NEXT_SCENE ~= nil then
                    trn:run(CURRENT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 0, time = DIRECTOR:timeToRun(), onComplete = DIRECTOR.startFadeInNext })
                else
                    trn:run(CURRENT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 0, time = DIRECTOR:timeToRun(), onComplete = DIRECTOR.endFade })
                end
            else
                trn:run(CURRENT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 0, time = DIRECTOR:timeToRun() })
            end
        end
    else
        -- if we don't have a CURRENT_SCENE or CURRENT_SCENE_GROUP then call fadeIn on the next scene
        DIRECTOR:startFadeInNext()
    end
end


function RNDirector:timeToRun()
    -- used for fading, if one of NEXT or CURRENT is missing we have to do the transition with on at full lenght
    if CURRENT_SCENE == nil or NEXT_SCENE == nil then
        return TIME
    else
        --if we have both NEXT and CURRENT each group have to run own transition at half time so the whole animation lasts the full lenght
        return TIME / 2
    end
end


function RNDirector:startFadeInNext()

    NEXT_SCENE_GROUP = NEXT_SCENE.onCreate()

    for i = 1, table.getn(NEXT_SCENE_GROUP.displayObjects), 1 do
        NEXT_SCENE_GROUP.displayObjects[i]:setAlpha(0)
    end

    for i = 1, table.getn(NEXT_SCENE_GROUP.displayObjects), 1 do
        if i == table.getn(NEXT_SCENE_GROUP.displayObjects) then
            trn:run(NEXT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 1, time = DIRECTOR:timeToRun(), onComplete = DIRECTOR.endFade })
        else
            trn:run(NEXT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 1, time = DIRECTOR:timeToRun() })
        end
    end
end


function RNDirector:endFade()

    print("ON END FADE!")
    if CURRENT_SCENE ~= nil then
        CURRENT_SCENE.onEnd()
    end

    if NEXT_SCENE ~= nil then
        CURRENT_SCENE_GROUP = NEXT_SCENE_GROUP
        CURRENT_SCENE = NEXT_SCENE
    end

    TRANSITIONING = false
    collectgarbage("collect")
end