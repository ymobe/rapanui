----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------

require("RNGlobals")


local TRANSITIONING = false

local offsetX = 0
local offsetY = 0

local currentScene = nil
local nextScene = nil

local timeToExecute = 1


RNDirector = {}
-- Create a new RNDirector Object
function RNDirector:new(o)

    o = o or {
        name = "",
        scenes = {}
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

--
-- add a scene to the Director the name of the scene have to be unique because it will be used as key
--
-- @param scene  a scene object to add to the director's managed scenes

function RNDirector:addScene(scene)
    self.scenes[scene:getName()] = scene
end

--
-- define the first scene to be shown
--
-- @param scene the first scene


function RNDirector:startWithScene(name)

    for key, value in pairs(self.scenes)
    do
        if (key == name) then
            currentScene = value
        else
            value:hideAll()
        end
    end
end

function RNDirector:getScene(name)
    return self.scenes[name]
end

--
-- Main method for switching
--
-- @param mode the switch mode if the mode it's not valid then a simple swap it's performed
--
function RNDirector:switch(name, props)

    if (TRANSITIONING) then
        return
    end

    local type = ""

    if (props.type ~= nil) then
        type = props.type
    end

    local time = 1

    if (props.time ~= nil) then
        time = props.time
    end

    local mode = MOAIEaseType.LINEAR

    if (props.mode ~= nil) then
        mode = props.mode
    end

    if (type == SWAP) then
        self:swap(name)
    elseif (type == RNGlobals.SLIDE_TO_LEFT) then
        self:slideToLeft(name, time, mode)
    elseif (type == RNGlobals.SLIDE_TO_RIGHT) then
        self:slideToRight(name, time, mode)
    elseif (type == RNGlobals.SLIDE_TO_BOTTOM) then
        self:slideToBottom(name, time, mode)
    elseif (type == RNGlobals.SLIDE_TO_TOP) then
        self:slideToTop(name, time, mode)
    elseif (type == RNGlobals.FADE_OUT_FADE_IN) then
        self:fadeOutFadeIn(name, time, mode)
    elseif (type == RNGlobals.CROSSFADE) then
        self:crossFade(name, time, mode)
    else
        self:swap(name)
    end
end

--
-- a simple scene swap, no effect
--
-- @param name the name of the scene
--

function RNDirector:swap(name)
    currentScene:hideAll()
    local newScene = self:getScene(name)
    currentScene = newScene
    currentScene:showAll()
end

function RNDirector:slideToTop(name, time, mode)
    offsetX = 0
    offsetY = -480
    self:slide(name, offsetX, offsetY, time, mode)
end

function RNDirector:slideToBottom(name, time, mode)
    offsetX = 0
    offsetY = 480
    self:slide(name, offsetX, offsetY, time, mode)
end

function RNDirector:slideToLeft(name, time, mode)
    offsetX = -320
    offsetY = 0
    self:slide(name, offsetX, offsetY, time, mode)
end

function RNDirector:slideToRight(name, time, mode)
    offsetX = 320
    offsetY = 0
    self:slide(name, offsetX, offsetY, time, mode)
end

function RNDirector:slide(name, offsetX, offsetY, time, mode)

    if (not TRANSITIONING) then
        TRANSITIONING = true

        nextScene = self:getScene(name)

        local nextSceneSprites = nextScene:getSprites()

        for key, value in pairs(nextSceneSprites)
        do
            local xLoc, yLoc = value:getProp():getLoc()
            xLoc = xLoc + (-1) * offsetX
            yLoc = yLoc + (-1) * offsetY

            value:getProp():setLoc(xLoc, yLoc)
        end

        nextScene:showAll()

        local action = nil

        for key, value in pairs(nextSceneSprites)
        do
            value:getProp():moveLoc(offsetX, offsetY, time, mode)
        end

        local action = nil

        local currentSceneSprites = currentScene:getSprites()
        for key, value in pairs(currentSceneSprites)
        do
            action = value:getProp():moveLoc(offsetX, offsetY, time, mode)
        end

        if (action ~= nil) then
            action:setListener(MOAIAction.EVENT_STOP, self.onEndSlide)
        end
        currentScene:showAll()
    end
end

--
-- Reset scenes status at the end of the slide group transitions
--
function RNDirector:onEndSlide()
    currentScene:hideAll()

    local currentSceneSprites = currentScene:getSprites()
    for key, value in pairs(currentSceneSprites)
    do
        local xLoc, yLoc = value:getProp():getLoc()
        xLoc = xLoc + (-1) * offsetX
        yLoc = yLoc + (-1) * offsetY

        value:getProp():setLoc(xLoc, yLoc)
    end

    currentScene = nextScene
    nextScene = nil
    TRANSITIONING = false
end

--
-- Crossfade to the next scene
--

function RNDirector:crossFade(name, time, mode)
    TRANSITIONING = true

    nextScene = self:getScene(name)

    local action = nil

    nextScene:setColor(0, 0, 0, 0)
    nextScene:showAll()

    currentScene:seekColor(0, 0, 0, 0, time, mode)
    action = nextScene:seekColorToDefault(1, 1, 1,  time, mode)

    action:setListener(MOAIAction.EVENT_STOP, RNDirector.onEndFade)
end


function RNDirector:fadeOutFadeIn(name, time, mode)
    TRANSITIONING = true

    timeToExecute = time

    nextScene = self:getScene(name)

    local action = nil

    nextScene:setColor(0, 0, 0, 0)

    action = currentScene:seekColor(0, 0, 0, 0, time / 2, mode)

    action:setListener(MOAIAction.EVENT_STOP, RNDirector.onEndFadeCurrentScene)
end

--
-- start the fade in of the next scene
--

function RNDirector:onEndFadeCurrentScene()

    currentScene:hideAll()
    nextScene:showAll()
    local action = nil

    action = nextScene:seekColor(1, 1, 1, 0, timeToExecute / 2)
    action:setListener(MOAIAction.EVENT_STOP, RNDirector.onEndFade)
end

--
-- Reset scenes status at the end of the crossfade transition
--
-- BEWARE: at the moment the alpha of the sprites in the scene reset to full opaque
--

function RNDirector:onEndFade()
    currentScene:hideAll()
    currentScene:setColor(1, 1, 1, 1)

    currentScene = nextScene

    nextScene = nil

    TRANSITIONING = false
end