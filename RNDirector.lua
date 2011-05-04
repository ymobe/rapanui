----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------
module(..., package.seeall)

SWAP = 1
SLIDE_TO_LEFT = 2
SLIDE_TO_RIGHT = 3
SLIDE_TO_BOTTOM = 4
SLIDE_TO_TOP = 5

local TRANSITIONING = false

offsetX = 0
offsetY = 0

currentScene = nil
nextScene = nil

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
-- add a scene to the Director the name of the scene have to be unique because it will be used ad key
--
-- @param scene  a scene object to add to the director managed scenes

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
            print("In iteration " .. value:getName())
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
function RNDirector:switch(mode, name)
    if (TRANSITIONING) then
        return
    end

    if (mode == SWAP) then
        self:swap(name)
    elseif (mode == SLIDE_TO_LEFT) then
        self:slideToLeft(name)
    elseif (mode == SLIDE_TO_RIGHT) then
        self:slideToRight(name)
    elseif (mode == SLIDE_TO_BOTTOM) then
        self:slideToBottom(name)
    elseif (mode == SLIDE_TO_TOP) then
        self:slideToTop(name)
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

function RNDirector:slideToTop(name)
    offsetX = 0
    offsetY = -480
    self:slide(name, offsetX, offsetY)
end

function RNDirector:slideToBottom(name)
    offsetX = 0
    offsetY = 480
    self:slide(name, offsetX, offsetY)
end

function RNDirector:slideToLeft(name)
    offsetX = -320
    offsetY = 0
    self:slide(name, offsetX, offsetY)
end

function RNDirector:slideToRight(name)
    offsetX = 320
    offsetY = 0
    self:slide(name, offsetX, offsetY)
end

function RNDirector:slide(name, offsetX, offsetY)



    if (not TRANSITIONING) then
        TRANSITIONING = true

        nextScene = self:getScene(name)

        local nextSceneSprites = nextScene:getSprites()

        for key, value in pairs(nextSceneSprites)
        do
            local xLoc, yLoc = value:getProp():getLoc()
            xLoc = xLoc + (-1) * offsetX
            yLoc = yLoc + (-1) * offsetY

            print("slide:  xLoc: " .. xLoc)

            value:getProp():setLoc(xLoc, yLoc)
        end

        nextScene:showAll()

        local action = nil

        --print_r(currentSceneSprites)
        for key, value in pairs(nextSceneSprites)
        do
        --  print("Name: " .. value:getImageName())
            value:getProp():moveLoc(offsetX, offsetY, 1)
        end

        --    MOAISim.pushRenderPass(self.layer)

        local action = nil

        --print_r(currentSceneSprites)

        local currentSceneSprites = currentScene:getSprites()
        for key, value in pairs(currentSceneSprites)
        do
            print("Name: " .. value:getImageName())
            action = value:getProp():moveLoc(offsetX, offsetY, 1)
        end

        -- add a listener on the last prop moveLoc to do task at the end of animation
        if (action ~= nil) then
            action:setListener(MOAIAction.EVENT_STOP, self.onEndSlide)
        end
        currentScene:showAll()
    end
end

--
-- Reset scenes status at the end of the transition
--
--
function RNDirector:onEndSlide()
    currentScene:hideAll()

    local currentSceneSprites = currentScene:getSprites()
    for key, value in pairs(currentSceneSprites)
    do
        local xLoc, yLoc = value:getProp():getLoc()
        xLoc = xLoc + (-1) * offsetX
        yLoc = yLoc + (-1) * offsetY

        print(" onEndSlide " .. currentScene:getName() .. " xLoc: " .. xLoc .. " yLoc: " .. yLoc)

        value:getProp():setLoc(xLoc, yLoc)
    end

    currentScene = nextScene
    nextScene = nil
    TRANSITIONING = false
end