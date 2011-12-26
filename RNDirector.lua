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
    NEXT_SCENE = require(name)

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
        else
            self:popIn()
        end
    end
end


------------------------- pop effect -------------------------------------------------------------
function RNDirector:popIn()

    if CURRENT_SCENE ~= nil then
        CURRENT_SCENE.onEnd()
    end

    CURRENT_SCENE_GROUP = NEXT_SCENE.onCreate()
    CURRENT_SCENE = NEXT_SCENE
    TRANSITIONING = false
end


------------------------- slide effect -----------------------------------------------------------
function RNDirector:slideout(xx, yy)

    --start slide
    for i = 1, table.getn(CURRENT_SCENE_GROUP.displayObjects), 1 do
        trn:run(CURRENT_SCENE_GROUP.displayObjects[i], { type = "move", x = CURRENT_SCENE_GROUP.displayObjects[i].x - xx, y = CURRENT_SCENE_GROUP.displayObjects[i].y - yy, time = TIME })
    end

    -- change the current scene group
    NEXT_SCENE_GROUP = NEXT_SCENE.onCreate()
    NEXT_SCENE_GROUP.x = xx
    NEXT_SCENE_GROUP.y = yy
    --start slide
    for i = 1, table.getn(NEXT_SCENE_GROUP.displayObjects), 1 do
        if i == table.getn(NEXT_SCENE_GROUP.displayObjects) then
            trn:run(NEXT_SCENE_GROUP.displayObjects[i], { type = "move", x = NEXT_SCENE_GROUP.displayObjects[i].x - xx, y = NEXT_SCENE_GROUP.displayObjects[i].y - yy, time = TIME, onComplete = allSlideEnd })
        else
            trn:run(NEXT_SCENE_GROUP.displayObjects[i], { type = "move", x = NEXT_SCENE_GROUP.displayObjects[i].x - xx, y = NEXT_SCENE_GROUP.displayObjects[i].y - yy, time = TIME })
        end
    end
end


function allSlideEnd()
    CURRENT_SCENE.onEnd()
    NEXT_SCENE_GROUP.x = 0
    NEXT_SCENE_GROUP.y = 0
    CURRENT_SCENE_GROUP = NEXT_SCENE_GROUP
    CURRENT_SCENE = NEXT_SCENE
    TRANSITIONING = false
    collectgarbage("collect")
end


---------------------------- fade effect---------------------------------------------------------
function RNDirector:fade()

    for i = 1, table.getn(CURRENT_SCENE_GROUP.displayObjects), 1 do
        if i == table.getn(CURRENT_SCENE_GROUP.displayObjects) then
            trn:run(CURRENT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 0, time = TIME/2, onComplete = DIRECTOR.startFadeInNext })
        else
            trn:run(CURRENT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 0, time = TIME/2 })
        end
    end
end


function RNDirector:startFadeInNext()
    NEXT_SCENE_GROUP = NEXT_SCENE.onCreate()
    for i = 1, table.getn(NEXT_SCENE_GROUP.displayObjects), 1 do
        NEXT_SCENE_GROUP.displayObjects[i]:setAlpha(0)
    end

    for i = 1, table.getn(NEXT_SCENE_GROUP.displayObjects), 1 do
        if i == table.getn(NEXT_SCENE_GROUP.displayObjects) then
            trn:run(NEXT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 1, time = TIME/2, onComplete = DIRECTOR.endFade })
        else
            trn:run(NEXT_SCENE_GROUP.displayObjects[i], { type = "alpha", alpha = 1, time = TIME/2 })
        end
    end
end


function RNDirector:endFade()
    CURRENT_SCENE.onEnd()
    collectgarbage("collect")
    CURRENT_SCENE_GROUP = NEXT_SCENE_GROUP
    CURRENT_SCENE = NEXT_SCENE
    TRANSITIONING = false
end