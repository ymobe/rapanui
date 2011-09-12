----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------


module(..., package.seeall)

require("RNBody")
require("RNJoint")


world=nil
units=nil
bodylist={}
jointlist={}
--collisions funcions names
collisionHandlerAllName=nil
collisionHandlerABeginName=nil
collisionHandlerEndName=nil
collisionHandlerPresolveName=nil
collisionHandlerPostsolveName=nil









-----------------------------------------------------------------------
--world settings-------------------------------------------------------

function start(...)
world = MOAIBox2DWorld.new ()
world:setGravity ( 0, 10 )
world:start ()

if (arg.n==0) then
	world:setUnitsToMeters (0.1)
	units=0.1
else
	world:setUnitsToMeters (arg[1])
	units=arg[1]
end

end






function stop()
world:stop()
end

function setCollisionHandler(type,name)
if (type=="all") then collisionHandlerAllName=name end
if (type=="begin") then collisionHandlerBeginName=name end
if (type=="end") then collisionHandlerEndName=name end
if (type=="pre_solve") then collisionHandlerPresolveName=name end
if (type=="post_solve") then collisionHandlerPostsolveName=name end
end

function setGravity(x,y)
world:setGravity(x,y)
end

function getGravity()
local x,y=world:getGravity()
return x,y
end

--change this after initialization won't fit sprites to bodies
function setMeters(meters)
world:setUnitsToMeters ( meters )
units=meters
end


function setIterations (velocity,position)
world:setIterations(velocity,position)
end

function getMeters()
return units
end

function setAutoClearForces(boolean)
world:setAutoClearForces(boolean)
end

function getAutoClearForces()
return world:getAutoClearForces()
end


function getBodyList()
return bodylist
end

-------------------------------------------------------------------
--bodies section---------------------------------------------------





function addBody(RNSprite,Type,...)

--[[ We need x,y,h,w,name and prop from RNSprite . The name and RNSprite are stored
     in RNBody and the prop is used in RNBody:removeSelf() 
	 Just keep it in mind for future changes to rapanui                           
--]]





--adds bodies to the world
local body

--[[ Objects are created at 0,0 and then translated to the right position, over
     the RNSprite. --]]

--checks for body type
if (Type == "dynamic")then  body = world:addBody ( MOAIBox2DBody.DYNAMIC ) end
if (Type == "static" )then  body = world:addBody ( MOAIBox2DBody.STATIC ) end
if (Type == "kinematic" )then  body = world:addBody ( MOAIBox2DBody.KINEMATIC ) end


--get some RNSprite proprieties
local xx,yy= RNSprite:getLocation()
local h=RNSprite:getOriginalHeight()
local w=RNSprite:getOriginalWidth()
local bprop=RNSprite:getProp()
local angle=0  --we should take this from RNSprite


--creates the RNPhysics object
local RNBody=RNBody:new()

--brings the RNSprite to the origin
RNSprite:setLocation(0,0)

--Check for additional arguments
if (arg.n~=0) then
    --for each  fixture(=field) received 
	for i=1,arg.n,1  do
	    --we create a fixture (a table)
		local RNFixture=arg[i]
		--sets default parameters if they aren't given 
		if (RNFixture.density==nil) then RNFixture.density=1 end
		if (RNFixture.friction==nil) then RNFixture.friction=0.3 end 
		if (RNFixture.bounce==nil) then RNFixture.bounce=0 end
		if (RNFixture.filter==nil) then RNFixture.filter={categoryBits=nil,maskBits=nil,groupIndex=nil} end
		if (RNFixture.sensor==nil) then RNFixture.sensor=false end 
		if (RNFixture.shape==nil) then RNFixture.shape="rectangle" end
		if (RNFixture.filter.categoryBits==nil)then RNFixture.filter.categoryBits=1 end
		--adds the fixture shape to the body
		if (RNFixture.shape=="circle")then
			fixture = body:addCircle (0,0,h/2)
		elseif (RNFixture.shape=="rectangle")then
			fixture = body:addRect ( -w/2,-h/2,w/2,h/2)
		else
    		fixture = body:addPolygon(RNFixture.shape)
		end

		--sets the real box2d fixture as above
		fixture:setDensity ( RNFixture.density )
		fixture:setFriction ( RNFixture.friction )
		fixture:setRestitution ( RNFixture.bounce )
		fixture:setSensor(RNFixture.sensor)
		fixture:setFilter(RNFixture.filter.categoryBits,RNFixture.filter.maskBits,RNFixture.filter.groupIndex)
		
		
		--the fixture now stores the body which is connected to 
		RNFixture.parentBody=RNBody
		RNFixture.indexinlist=i
		--and its native box2d fixture
		RNFixture.fixture=fixture
		--update the RNBody.fixturelist
		RNBody.fixturelist[i]=RNFixture
		
		--sets the collision handler without 3rd argument
		--(all collisions give callbacks, also if they pierce)
		fixture:setCollisionHandler ( RNCollisionHandling, MOAIBox2DArbiter.ALL)
	end --end arg for

elseif (arg.n==0) then --else arg[1]~=nil
	--if there aren't additional arguments
	--a default physic body is created
	fixture = body:addRect ( -w/2,-h/2,w/2,h/2)
	fixture:setDensity ( 1 )
	fixture:setFriction ( 0.3 )
	fixture:setRestitution ( 0.0 )
	fixture:setSensor(false)
	--default proprieties are given to the RNFixture table too
	local proprieties={fixture=fixture,density=1,friction=0.3,bounce=0,filter={categoryBits=1,maskBits=nil,groupIndex=nil},sensor=false,shape="rectangle"}
	--and to its filter
	RNFixture=proprieties
	fixture:setFilter(RNFixture.filter.categoryBits,RNFixture.filter.maskBits,RNFixture.filter.groupIndex)
	--stores in the RNFixture table the RNBody which is connected to
	RNFixture.parentBody=RNBody
	RNFixture.indexinlist=1
	--and update this RNBody.fixturelist (1 because this will be the
	--only whon fixture in this RNBody)
	RNBody.fixturelist[1]=RNFixture
	
   --sets the collision handler without 3rd argument
   --(all collisions give callbacks, also if they pierce)
   fixture:setCollisionHandler ( RNCollisionHandling, MOAIBox2DArbiter.ALL)
	
end--end if arg>0




--adds the body to the bodylist
len=table.getn(bodylist)
bodylist[len+1]=RNBody
RNBody.indexinlist=len+1



--it resets the body mass
body:resetMassData ()





--binds the RNSprite's prop to our body.
bprop:setParent(body)

--stores proprieties in RNPhysics object
RNBody.sprite=RNSprite
RNBody.body=body
RNBody.type=Type
RNBody.name=RNSprite.name
RNBody.parentList=bodylist




--traslate body to sprite position
body:setTransform(xx,yy,angle)

return RNBody

end 




















------------------------------------------------------------------
--debug draw section----------------------------------------------


--we need the layer from RNScene received
--keep it in mind for future changes
function startDebugDrawScene(RNScene)

local layerfordebug=RNScene:getLayer()
layerfordebug:setBox2DWorld(world)
RNScene:hideAll()

end















---------------------------------------------------------------------

-----------------------COLLISION HANDLER-----------------------------------------

function RNCollisionHandling (phase,fixtureA,fixtureB,arbiter)

	local blist,len,flist,flistlen,currentbody,currentfixture,body1,body2,currentphase,element1,element2,currentEvent
	--creates an event table(that will be passed to the callback function)
    currentEvent={object1=nil,object2=nil,element1=nil,element2=nil,force=nil,friction=nil,phase=nil}
    --sets the received friction and force =~0 only in presolve and postsolve
    currentEvent.force=arbiter:getNormalImpulse()
	currentEvent.friction=arbiter:getNormalImpulse()


	--check for current phase
	if phase == MOAIBox2DArbiter.BEGIN then
	currentphase="begin"
	end
	if phase == MOAIBox2DArbiter.END then
	currentphase="end"
	end
	if phase == MOAIBox2DArbiter.PRE_SOLVE then
	currentphase="pre_solve"
	end
	if phase == MOAIBox2DArbiter.POST_SOLVE then
	currentphase="post_solve"
	end

	--checks for which fixtures in which bodies are colliding
	blist=physics.getBodyList()
	len=table.getn(blist)
	--finds fixtureA name:
	--for each body in bodylist 
		for i=1,len,1 do
		currentbody=blist[i]
		    --and for each fixture in that body
		    flist=currentbody.fixturelist
		    flistlen=table.getn(flist)
		    for k=1,flistlen,1 do
		        currentfixture=flist[k].fixture
		        --if the fixture is the right one envolved in this collision 
		        --stores in body1 the envolved fixture's parent RNBody.
		        --and in element1 the RNFixture table of the fixture envolved.
				if (fixtureA==currentfixture) then body1=currentbody element1=flist[k] end
			end
		end
		
	--finds fixtureB name:
	--for each body in bodylist
		for i=1,len,1 do
		currentbody=blist[i]
		    --and for each fixture in that body
		    flist=currentbody.fixturelist
		    flistlen=table.getn(flist)
		    for k=1,flistlen,1 do
		        currentfixture=flist[k].fixture
		        --if the fixture is the right one envolved in this collision 
		        --stores in body2 the envolved fixture's parent RNBody.
		        --and in element2 the RNFixture table of the fixture envolved.
				if (fixtureB==currentfixture) then body2=currentbody element2=flist[k] end
			end
		end

	--stores in the event table some things to pass to callback funcions
	currentEvent.phase=currentphase
	currentEvent.object1=body1
	currentEvent.object2=body2
	currentEvent.element1=element1
	currentEvent.element2=element2


	--if there are functions set for callback the event table will be passed
	--to the right function according to the phase(if it exists) and to the
	--function receiveing callbacks for "all" (if it exists)
	if (currentphase=="begin")then
	if (collisionHandlerBeginName~=nil)then
	local funct=collisionHandlerBeginName
    if(funct~=nil)then funct(currentEvent)end
    end
	end
    --
    if (currentphase=="end")then
	if (collisionHandlerEndName~=nil)then
	local funct=collisionHandlerEndName
    if(funct~=nil)then funct(currentEvent) end
    end
	end
    --
    if (currentphase=="pre_solve")then
	if (collisionHandlerPresolveName~=nil)then
	local funct=collisionHandlerPresolveName
    if(funct~=nil)then funct(currentEvent) end
    end
	end
    --
    if (currentphase=="post_solve")then
	if (collisionHandlerPostsolveName~=nil)then
	local funct=collisionHandlerPostsolveName
    if(funct~=nil)then funct(currentEvent) end
    end
	end
    --
    if (collisionHandlerAllName~=nil)then
	local funct=collisionHandlerAllName
    if(funct~=nil)then funct(currentEvent) end
    end
    




end













------------------------------------------------------------------------------------
----------------------------JOINTS------------------------------------------------


function  newJoint(type,...)

local joint,bodyA,bodyB,anchorX,anchorY,anchorA_X,anchorA_Y,anchorB_X,anchorB_Y,axisA,axisB,groundAnchorA_X,groundAnchorA_Y,groundAnchorB_X,groundAnchorB_Y,ratio,targetX,targetY,frequency,damping,maxForce,maxTorque,maxLengthA,maxLengthB

--revolute joint
--(type,bodyA,bodyB,anchorX,anchorY)
	if (type=="revolute") then
	bodyA=arg[1]
	bodyB=arg[2]
	anchorX=arg[3]
	anchorY=arg[4]
	joint=world:addRevoluteJoint(bodyA.body,bodyB.body,anchorX,anchorY)
	end

--distance joint    
--(type,bodyA,bodyB,anchorA_X.anchorA_Y,anchorB_X,anchorB_Y[,frequencyHz,dampingRatio])
--NB: PER ORA QUI MANCANO FREQUENCY E DAMPING
    if (type=="distance") then
    bodyA=arg[1]
	bodyB=arg[2]
	anchorA_X=arg[3]
	anchorA_Y=arg[4]
	anchorB_X=arg[5]
	anchorB_Y=arg[6]
	frequency=arg[7]
	damping=arg[8]
	print(arg[7],arg[8])
	if (frequency==nil) then frequency=30 end
	if (damping==nil) then damping=0 end
    joint=world:addDistanceJoint(bodyA.body,bodyB.body,anchorA_X,anchorA_Y,anchorB_X,anchorB_Y,frequency,damping)
    end

--prismatic joint
--(type,bodyA,bodyB,anchorA_X,anchorA_Y,axisA,axisB)
	if (type=="prismatic") then
	bodyA=arg[1]
	bodyB=arg[2]
	anchorA_X=arg[3]
	anchorA_Y=arg[4]
	axisA=arg[5]
	axisB=arg[6]
	joint=world:addPrismaticJoint (bodyA.body,bodyB.body,anchorA_X,anchorA_Y,axisA,axisB)	
	end
	
--friction joint
--(type,bodyA,bodyB,anchorX,anchorY[, number maxForce, number maxTorque ] )
	if (type=="friction") then
	bodyA=arg[1]
	bodyB=arg[2]
	anchorX=arg[3]
	anchorY=arg[4]
	maxForce=arg[5]
	maxTorque=arg[6]
	if (maxForce==nil) then maxForce=1000000 end
	if (maxTorque==nil) then maxTorque=1000000 end
	joint=world:addFrictionJoint (bodyA.body,bodyB.body,anchorX,anchorY,maxForce,maxTorque)
	end

--weld joint
--(type,bodyA,bodyB,anchorX,anchorY)
	if (type=="weld") then
	bodyA=arg[1]
	bodyB=arg[2]
	anchorX=arg[3]
	anchorY=arg[4]
	joint=world:addWeldJoint (bodyA.body,bodyB.body,anchorX,anchorY)
	end
	
--line joint
--(type,bodyA,bodyB,anchorX,anchorY,axisX,axisY)
	if (type=="line") then
	bodyA=arg[1]
	bodyB=arg[2]
	anchorX=arg[3]
	anchorY=arg[4]
	axisX=arg[5]
	axisY=arg[6]
	joint=world:addLineJoint (bodyA.body,bodyB.body,anchorX,anchorY,axisX,axisY)
	end
	
--pulley joint
--(type,bodyA,bodyB,groundAnchorA_X,groundAnchorA_Y,groundAnchorB_X,groundAnchorB_Y,anchorA_X,anchorA_Y,anchorB_X,anchorB_Y,ratio,number maxLengthA, number maxLengthB )
	if (type=="pulley") then
	bodyA=arg[1]
	bodyB=arg[2]
	groundAnchorA_X=arg[3]
	groundAnchorA_Y=arg[4]
	groundAnchorB_X=arg[5]
	groundAnchorB_Y=arg[6]
	anchorA_X=arg[7]
	anchorA_Y=arg[8]
	anchorB_X=arg[9]
	anchorB_Y=arg[10]
	ratio=arg[11]
	maxLengthA=arg[12]
	maxLengthB=arg[13]
	if (maxLengthA==nil) then maxLengthA=100000 end
	if (maxLengthB==nil) then maxLengthB=100000 end
	joint=world:addPulleyJoint (bodyA.body,bodyB.body,groundAnchorA_X,groundAnchorA_Y,groundAnchorB_X,groundAnchorB_Y,anchorA_X,anchorA_Y,anchorB_X,anchorB_Y,ratio,maxLengthA,maxLengthB)
	end

--mouse joint
--(type,targetX,targetY,maxForce,frequency,damping)
	if (type=="mouse") then
	targetX=arg[1]
	targetY=arg[2]
	joint=world:addMouseJoint (targetX,targetY,10000,50,0.2)
	end


--set RNJoint
local RNJoint=RNJoint:new()
RNJoint.joint=joint
RNJoint.type=type
RNJoint.bodyA=bodyA
RNJoint.bodyB=bodyB
RNJoint.parentList=jointlist
--set specific proprieties for specific types of joint
if (type=="pulley") then
RNJoint.ratio=ratio
RNJoint.anchorA_X=anchorA_X
RNJoint.anchorA_Y=anchorA_Y
RNJoint.anchorB_X=anchorB_X
RNJoint.anchorB_Y=anchorB_Y
end

--add RNJoint to RNPhysics jointlist
len=table.getn(jointlist)
jointlist[len+1]=RNJoint
RNJoint.indexingloballist=len+1

--add RNJoint to bodyA.jointlist
len=table.getn(bodyA.jointlist)
bodyA.jointlist[len+1]=RNJoint
RNJoint.indexinbodyAlist=len+1

--add RNJoint to bodyB.jointlist
len=table.getn(bodyB.jointlist)
bodyB.jointlist[len+1]=RNJoint
RNJoint.indexinbodyBlist=len+1
	
return RNJoint 

end

