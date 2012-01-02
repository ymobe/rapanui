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
local TIME
local POP_SCENE
local POP_SCENE_GROUP
local CURRENT_SCENE
local CURRENT_SCENE_GROUP
local OLD_SCENE
local OLD_SCENE_GROUP
local trn
local width, height

local RNDirector = {}
local R
-- Create a new RNDirector Object
function RNDirector:new(o)
	if not R then R = RN end
	width, height = R.Factory.contentWidth, R.Factory.contentHeight
	trn = R.Transition:new()
	TIME = 800 --default
    o = o or {
        name = "",
        scenes = {}
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

--sets the time of transitions
function RNDirector:setTime(value)
	TIME=value
end


--Functions to show/hide  a scene with the given effect

local function getab(effect)
	local a,b = 0,0
		if effect=="slidetoleft" then
			a,b = width,0  
		elseif effect=="slidetoright" then
			a,b = -width,0
		elseif effect=="slidetotop" then
			a,b = 0,height
		elseif effect=="slidetobottom" then
			a,b = 0,-height
		end
	return a,b
end
function RNDirector:showScene(name,effect)
local name = "../"..name
	if effect=="pop" or effect==nil then
		self:popIn(name)	
	elseif effect=="fade" then
	    self:fadeIn(name)
	else	
		local a,b = getab(effect)
		self:slideIn(name,a,b)
	end
end

function RNDirector:hideScene(name,effect)
local name = "../"..name
	if effect=="pop" or effect==nil then
		onOut()
	elseif effect=="fade" then
		onOut()
	else	
		local a,b = getab(effect)
		self:slideOut(a,b)
	end
end

local coll = collectgarbage
local unloadScene = function ( moduleName )
	if moduleName ~= "main" and type( package.loaded[moduleName] ) == "table" then
		package.loaded[moduleName] = nil
		local collect = function() coll() end
		R.MainThread.addTimedAction(TIME/10, collect)
	end
end

--function for changing a scene to another one

function RNDirector:changeScene(sceneToGo,effect)
OLD_SCENE=CURRENT_SCENE
OLD_SCENE_GROUP=CURRENT_SCENE_GROUP
local sceneToGo = "../"..sceneToGo
	unloadScene(sceneToGo)
	if effect=="pop" or effect==nil then
		onChangeOut()
		self:popIn(sceneToGo)   
	elseif effect=="fade" then
	    self:fadeOutChange()
	    self:fadeIn(sceneToGo)
	else	
		local a,b = getab(effect)
		self:slideOutChange(a,b)
		self:slideIn(sceneToGo,a,b)
	end
end

function RNDirector:openPopUp(sceneToGo,effect)
local sceneToGo = "../"..sceneToGo
	POP_SCENE=require(sceneToGo)
	POP_SCENE_GROUP=POP_SCENE.onCreate() 
end

function RNDirector:closePopUp(sceneToGo,effect)
	for i=1,table.getn(POP_SCENE_GROUP.displayObjects),1 do
		POP_SCENE_GROUP.displayObjects[1]:remove();
	end
end
-------------------------pop effect-------------------------------------------------------------

function RNDirector:popIn(name)
	CURRENT_SCENE=require(name)
	CURRENT_SCENE_GROUP=CURRENT_SCENE.onCreate()
end

function ended()
	for i=1,table.getn(OLD_SCENE_GROUP.displayObjects),1 do
		OLD_SCENE_GROUP.displayObjects[1]:remove();
	end
end

function onOut()
	CURRENT_SCENE.onEnd()
	ended()	
end

function onChangeOut()
    OLD_SCENE.onEnd()
	ended()	
end

function RNDirector:fadeIn(name)
	CURRENT_SCENE=require(name)
	CURRENT_SCENE_GROUP=CURRENT_SCENE.onCreate()
CURRENT_SCENE_GROUP.visible=false	
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="alpha",alpha=0,time=1,onComplete=startFadeIn})
	end
	
end


function RNDirector:fadeOut()
--fade the scene out with a transition, then calls a function to reset scene
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="alpha",alpha=0,time=self.TIME,onComplete=onOut})
	end
end




function startFadeIn()
--now we have a hidden scene with alpha value to 0 we can start show it and fade it in!
CURRENT_SCENE_GROUP.visible=true
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="alpha",alpha=1,time=TIME})
	end
end




function RNDirector:fadeOutChange()
--fade the scene out with a transition, then calls a function to reset scene
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="alpha",alpha=0,time=self.TIME,onComplete=onChangeOut})
	end
end



----------------------------Slide effect---------------------------------------------------------

function RNDirector:slideIn(name,xx,yy)
--set up a scene to start slide in
		CURRENT_SCENE=require(name)
		CURRENT_SCENE_GROUP=CURRENT_SCENE.onCreate()	
		CURRENT_SCENE_GROUP.x=xx
		CURRENT_SCENE_GROUP.y=yy
--start slide
	local function onEndSlideIn()
		CURRENT_SCENE_GROUP.x=0
		CURRENT_SCENE_GROUP.y=0
	end
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="move",x=CURRENT_SCENE_GROUP.displayObjects[i].x-xx,y=CURRENT_SCENE_GROUP.displayObjects[i].y-yy,time=TIME,onComplete=onEndSlideIn})
	end	

end


function RNDirector:slideOut(xx,yy)
--start slide
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="move",x=CURRENT_SCENE_GROUP.displayObjects[i].x-xx,y=CURRENT_SCENE_GROUP.displayObjects[i].y-yy,time=TIME,onComplete=onOut})
	end	
end


function RNDirector:slideOutChange(xx,yy)
--start slide
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="move",x=CURRENT_SCENE_GROUP.displayObjects[i].x-xx,y=CURRENT_SCENE_GROUP.displayObjects[i].y-yy,time=TIME,onComplete=onChangeOut})
	end	
end

return RNDirector
