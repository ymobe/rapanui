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

module(..., package.seeall)

--global vars

--global time for transitions
TIME=800
SCENE_TO_END_FADE_OUT=nil
SCENE_TO_END_SCALE_OUT=nil
SCENE_TO_START_SCALE_IN=nil

CURRENT_SCENE=nil
CURRENT_SCENE_GROUP=nil
OLD_SCENE=nil



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


--add a scene to Director and set it to invisible . scene must be an instance of RNGroup
function RNDirector:addScene(scene)
    	local len = table.getn(self.scenes)
        self.scenes[len + 1] = scene
end


--sets the time of transitions
function RNDirector:setTime(value)
	TIME=value
end


--Functions to show/hide  a scene with the given effect


function RNDirector:showScene(name,effect)

	if effect=="pop" then
		self:popIn(name)	
	end

	if effect=="fade" then
	    self:fadeIn(name)
	end
	
	if effect=="slidetoleft" then
	    self:slideToLeftIn(name)
	end

end

function RNDirector:hideScene(name,effect)
	if effect=="pop" then
		self:popOut()
	end

	if effect=="fade" then
	    self:fadeOut()
	end
	
	if effect=="slidetoleft" then
	    self:slideToLeftOut()
	end
	
end


--function for changing a scene to another one

function RNDirector:changeScene(sceneToGo,effect)

	if effect=="pop" then
		self:popOutChange()
		self:popIn(sceneToGo)   
	end

	if effect=="fade" then
	    self:fadeOutChange()
	    self:fadeIn(sceneToGo)
	end
	
	if effect=="slidetoleft" then
	    self:slideToLeftOutChange()
	    self:slideToLeftIn(sceneToGo)
	end
	

end





-------------------------pop effect-------------------------------------------------------------

function RNDirector:popIn(name)
		CURRENT_SCENE=require(name)
		CURRENT_SCENE_GROUP=CURRENT_SCENE.onCreate()
end



function RNDirector:popOut()
		CURRENT_SCENE.onEnd()
end

function RNDirector:popOutChange()
		OLD_SCENE=CURRENT_SCENE()
		OLD_SCENE.onEnd()
end


----------------------------fade effect---------------------------------------------------------

function RNDirector:fadeIn(name)
--set up a scene to start fade in
		CURRENT_SCENE=require(name)
		CURRENT_SCENE_GROUP=CURRENT_SCENE.onCreate()
--set starting alpha
--and call for startFadeIn when ready
CURRENT_SCENE_GROUP.visible=false	
	for i=0,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="alpha",alpha=0,time=1,onComplete=startFadeIn})
	end
	
end


function RNDirector:fadeOut()
--fade the scene out with a transition, then calls a function to reset scene
	for i=0,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="alpha",alpha=0,time=self.TIME,onComplete=endFadeOut})
	end
end




function startFadeIn()
--now we have a hidden scene with alpha value to 0 we can start show it and fade it in!
CURRENT_SCENE_GROUP.visible=true
	for i=0,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="alpha",alpha=1,time=TIME})
	end
end


function endFadeOut()
	CURRENT_SCENE.onEnd()
end

function RNDirector:fadeOutChange()
OLD_SCENE=CURRENT_SCENE
--fade the scene out with a transition, then calls a function to reset scene
	for i=0,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="alpha",alpha=0,time=self.TIME,onComplete=endFadeOutChange})
	end
end

function endFadeOutChange()
    OLD_SCENE.onEnd()
end






----------------------------Scale to left effect---------------------------------------------------------

function RNDirector:slideToLeftIn(name)
--set up a scene to start slide in
		CURRENT_SCENE=require(name)
		CURRENT_SCENE_GROUP=CURRENT_SCENE.onCreate()	
		CURRENT_SCENE_GROUP.x=320
--start slide
	for i=0,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="move",x=CURRENT_SCENE_GROUP.displayObjects[i].x-320,y=CURRENT_SCENE_GROUP.displayObjects[i].y,time=TIME})
	end	
end

function RNDirector:slideToLeftOut()		
--start slide
	for i=0,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="move",x=CURRENT_SCENE_GROUP.displayObjects[i].x-320,y=CURRENT_SCENE_GROUP.displayObjects[i].y,time=TIME,onComplete=slideToLeftOutEnd})
	end	
end


function slideToLeftOutEnd()
	CURRENT_SCENE.onEnd()	
end

function RNDirector:slideToLeftOutChange()
OLD_SCENE=CURRENT_SCENE		
--start slide
	for i=0,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="move",x=CURRENT_SCENE_GROUP.displayObjects[i].x-320,y=CURRENT_SCENE_GROUP.displayObjects[i].y,time=TIME,onComplete=endSlideToLeftOutChange})
	end	
end

function endSlideToLeftOutChange()
    OLD_SCENE.onEnd()
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
    elseif (type == SLIDE_TO_LEFT) then
        self:slideToLeft(name, time, mode)
    elseif (type == SLIDE_TO_RIGHT) then
        self:slideToRight(name, time, mode)
    elseif (type == SLIDE_TO_BOTTOM) then
        self:slideToBottom(name, time, mode)
    elseif (type == SLIDE_TO_TOP) then
        self:slideToTop(name, time, mode)
    elseif (type == FADE_OUT_FADE_IN) then
        self:fadeOutFadeIn(name, time, mode)
    elseif (type == CROSSFADE) then
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
    action = nextScene:seekColor(1, 1, 1, 1, time, mode)

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