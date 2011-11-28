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
	    self:slideIn(name,320,0)
	end
	if effect=="slidetoright" then
	    self:slideIn(name,-320,0)
	end
	if effect=="slidetotop" then
	    self:slideIn(name,0,480)
	end
	if effect=="slidetobottom" then
	    self:slideIn(name,0,-480)
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
	    self:slideOut(320,0)
	end
	if effect=="slidetoright" then
	    self:slideOut(-320,0)
	end
	if effect=="slidetotop" then
	    self:slideOut(0,480)
	end
	if effect=="slidetobottom" then
	    self:slideOut(0,-480)
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
	    self:slideOutChange(320,0)
	    self:slideIn(sceneToGo,320,0)
	end
	
	if effect=="slidetoright" then
	    self:slideOutChange(-320,0)
	    self:slideIn(sceneToGo,-320,0)
	end
	
	if effect=="slidetotop" then
	    self:slideOutChange(0,480)
	    self:slideIn(sceneToGo,0,480)
	end
	
	if effect=="slidetobottom" then
	    self:slideOutChange(0,-480)
	    self:slideIn(sceneToGo,0,-480)
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
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="alpha",alpha=0,time=1,onComplete=startFadeIn})
	end
	
end


function RNDirector:fadeOut()
--fade the scene out with a transition, then calls a function to reset scene
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="alpha",alpha=0,time=self.TIME,onComplete=endFadeOut})
	end
end




function startFadeIn()
--now we have a hidden scene with alpha value to 0 we can start show it and fade it in!
CURRENT_SCENE_GROUP.visible=true
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
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
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="alpha",alpha=0,time=self.TIME,onComplete=endFadeOutChange})
	end
end

function endFadeOutChange()
    OLD_SCENE.onEnd()
end






----------------------------Slide effect---------------------------------------------------------

function RNDirector:slideIn(name,xx,yy)
--set up a scene to start slide in
		CURRENT_SCENE=require(name)
		CURRENT_SCENE_GROUP=CURRENT_SCENE.onCreate()	
		CURRENT_SCENE_GROUP.x=xx
		CURRENT_SCENE_GROUP.y=yy
--start slide
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="move",x=CURRENT_SCENE_GROUP.displayObjects[i].x-xx,y=CURRENT_SCENE_GROUP.displayObjects[i].y-yy,time=TIME})
	end	
end

function RNDirector:slideOut(xx,yy)
--start slide
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="move",x=CURRENT_SCENE_GROUP.displayObjects[i].x-xx,y=CURRENT_SCENE_GROUP.displayObjects[i].y-yy,time=TIME,onComplete=slideOutEnd})
	end	
end


function slideOutEnd()
	CURRENT_SCENE.onEnd()	
end

function RNDirector:slideOutChange(xx,yy)
OLD_SCENE=CURRENT_SCENE		
--start slide
	for i=1,table.getn(CURRENT_SCENE_GROUP.displayObjects),1 do
		local trn=RNTransition:new()
		trn:run(CURRENT_SCENE_GROUP.displayObjects[i],{type="move",x=CURRENT_SCENE_GROUP.displayObjects[i].x-xx,y=CURRENT_SCENE_GROUP.displayObjects[i].y-yy,time=TIME,onComplete=endSlideOutChange})
	end	
end

function endSlideOutChange()
    OLD_SCENE.onEnd()
end

