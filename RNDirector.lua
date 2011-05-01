----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------
module(..., package.seeall)

--require("RNUtil")


SWAP = 1
SLIDE_TO_LEFT = 2

-- Create a new RNDirector Object
function RNDirector:new(o)

    o = o or {
        name = "",
        currentScene,
        nextScene,
        scenes = {}
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

--
-- add a scene to the Director the name of the scene have to be unique because it will be used to identify the object
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
            self.currentScene = value
        else
            value:hideAll()
        end
    end
end

function RNDirector:getScene(name)
    return self.scenes[name]
end


function RNDirector:switch(mode, name)
    if (mode == SWAP) then
        self:swap(name)
    elseif (mode == SLIDE_TO_LEFT) then
        self:slideToLeft(name)
    else
        self:swap(name)
    end
end

function RNDirector:swap(name)
    self.currentScene:hideAll()
    local newScene = self:getScene(name)
    self.currentScene = newScene
    self.currentScene:showAll()
end

function RNDirector:slideToLeft(name)
--self.currentScene:hideAll()
    print("Slide to left")
    local currentSceneSprites = self.currentScene:getSprites()
    nextScene = self:getScene(name)

    nextScene:showAll()

    local action = nil

    --print_r(currentSceneSprites)
    for key, value in pairs(currentSceneSprites)
    do
        print("Name: " .. value:getImageName())
        action = value:getProp():moveLoc(-320, 0, 1)
    end

    if (action ~= nil) then
        action:setListener(MOAIAction.EVENT_STOP, self.onEndSlideToLeft)
    end
--	self.currentScene:showAll()
end

function RNDirector:onEndSlideToLeft()
    print("Swapped onEndSlideToLeft")
    currentScene = nextScene
    nextScene = nil
end