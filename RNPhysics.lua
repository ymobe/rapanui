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
--stora il nome delle funzioni che verranno chiamate per ogni phase della collisione
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
--[[ dall' RNSprite prendo x,y,h,w,name e prop e per ora no ma in futuro si l'angle
	 si tenga a mente se si deve cambiare qualcosa
	 che poi name e RNSprite vengono anche storate
	 nell'oggetto RNBody e la prop la uso anche in RNBody:removeSelf()
--]]





--adds bodies to the world
local body
--li creao a 0,0 senza dare i parametri in piu
--non si puo decidere di creare un body dovunque
--viene creato a 0 e poi traslato sull'immagine dell'RNSprite.
--poi comunque si puo spostare (e si porta appresso la sprite la sprite)
--in realtà si porta appresso la prop della RNSprite, non vado
--ad aggiornare la locazione della RNSprite ogni volta sarebbe un casino.
if (Type == "dynamic")then  body = world:addBody ( MOAIBox2DBody.DYNAMIC ) end
if (Type == "static" )then  body = world:addBody ( MOAIBox2DBody.STATIC ) end
if (Type == "kinematic" )then  body = world:addBody ( MOAIBox2DBody.KINEMATIC ) end


--get some RNSprite proprieties
local xx,yy= RNSprite:getLocation()
local h=RNSprite:getOriginalHeight()
local w=RNSprite:getOriginalWidth()
local bprop=RNSprite:getProp()
local angle=0  --dovrei prenderlo dalla RNSprite


--creates the RNPhysics object
local RNBody=RNBody:new()

RNSprite:setLocation(0,0)

--Check for additional arguments
if (arg.n~=0) then
    --per ogni fixture ricevuta
	for i=1,arg.n,1  do
	    --crea la fixture
		local RNFixture=arg[i]
		--se non arrivano parametri negli argomenti li setta standard
		if (RNFixture.density==nil) then RNFixture.density=1 end
		if (RNFixture.friction==nil) then RNFixture.friction=0.3 end 
		if (RNFixture.bounce==nil) then RNFixture.bounce=0 end
		if (RNFixture.filter==nil) then RNFixture.filter={categoryBits=nil,maskBits=nil,groupIndex=nil} end
		if (RNFixture.sensor==nil) then RNFixture.sensor=false end 
		if (RNFixture.shape==nil) then RNFixture.shape="rectangle" end
		if (RNFixture.filter.categoryBits==nil)then RNFixture.filter.categoryBits=1 end
		--aggiunge la forma della fixture al body
		if (RNFixture.shape=="circle")then
			fixture = body:addCircle (0,0,h/2)
		elseif (RNFixture.shape=="rectangle")then
			fixture = body:addRect ( -w/2,-h/2,w/2,h/2)
		else
    		fixture = body:addPolygon(RNFixture.shape)
		end

		--setta le fixture come dette
		fixture:setDensity ( RNFixture.density )
		fixture:setFriction ( RNFixture.friction )
		fixture:setRestitution ( RNFixture.bounce )
		fixture:setSensor(RNFixture.sensor)
		fixture:setFilter(RNFixture.filter.categoryBits,RNFixture.filter.maskBits,RNFixture.filter.groupIndex)
		
		
		--storo nella fixture a che body è connessa
		RNFixture.parentBody=RNBody
		RNFixture.indexinlist=i
		--e gli do la fixture nativa di box2d
		RNFixture.fixture=fixture
		--aggiorno la fixture list di RNBody
		RNBody.fixturelist[i]=RNFixture
		
		--setto il collision handler senza terzo parametro
		--cioè per tutte le collisioni anche fra oggetti che si trapassano
		fixture:setCollisionHandler ( RNCollisionHandling, MOAIBox2DArbiter.ALL)
	end --end arg for

elseif (arg.n==0) then --else arg[1]~=nil
	--se non ci sono argomenti aggiuntivi
	--creo un physic body standard
	fixture = body:addRect ( -w/2,-h/2,w/2,h/2)
	fixture:setDensity ( 1 )
	fixture:setFriction ( 0.3 )
	fixture:setRestitution ( 0.0 )
	fixture:setSensor(false)
	--proprieta standard per la RNFixture
	local proprieties={fixture=fixture,density=1,friction=0.3,bounce=0,filter={categoryBits=1,maskBits=nil,groupIndex=nil},sensor=false,shape="rectangle"}
	--e la sua RNFixture anchessa standard
	RNFixture=proprieties
	fixture:setFilter(RNFixture.filter.categoryBits,RNFixture.filter.maskBits,RNFixture.filter.groupIndex)
	--storo nella fixture a che body è connessa
	RNFixture.parentBody=RNBody
	RNFixture.indexinlist=1
	--aggiorno la fixture list
	RNBody.fixturelist[1]=RNFixture
	
   --setto il collision handler senza terzo parametro
   --cioè per tutte le collisioni anche fra oggetti che si trapassano
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


--DALLA RNScene PRENDO IL LAYER
function startDebugDrawScene(RNScene)

local layerfordebug=RNScene:getLayer()
layerfordebug:setBox2DWorld(world)
RNScene:hideAll()

end















---------------------------------------------------------------------

-----------------------COLLISION HANDLER-----------------------------------------

function RNCollisionHandling (phase,fixtureA,fixtureB,arbiter)

	local blist,len,flist,flistlen,currentbody,currentfixture,body1,body2,currentphase,element1,element2,currentEvent
	--creo un evento RNCollisionEvent
    currentEvent={object1=nil,object2=nil,element1=nil,element2=nil,force=nil,friction=nil,phase=nil}
    --e gli do force e friction che tanto saranno =~0 solo in presolve e postsolve
    currentEvent.force=arbiter:getNormalImpulse()
	currentEvent.friction=arbiter:getNormalImpulse()


	--vedo in che fase sono
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

	--vedo quali fixtures di quals oggetti si toccano
	blist=physics.getBodyList()
	len=table.getn(blist)
	--trovo il nome di fixtureA
	--scorro i bodyes
		for i=1,len,1 do
		currentbody=blist[i]
		    --scorro le fixture
		    flist=currentbody.fixturelist
		    flistlen=table.getn(flist)
		    for k=1,flistlen,1 do
		        currentfixture=flist[k].fixture
		        --quando la fixture è quella giusta salva in body1
		        --il nome dell'RNBody a cui appartiene la fixture in collisione
				if (fixtureA==currentfixture) then body1=currentbody element1=flist[k] end
			end
		end
		
	--trovo il nome di fixtureB
	--scorro i bodyes
		for i=1,len,1 do
		currentbody=blist[i]
		    --scorro le fixture
		    flist=currentbody.fixturelist
		    flistlen=table.getn(flist)
		    for k=1,flistlen,1 do
		        currentfixture=flist[k].fixture
		        --quando la fixture è quella giusta salva in body1
		        --il nome dell'RNBody a cui appartiene la fixture in collisione
				if (fixtureB==currentfixture) then body2=currentbody element2=flist[k] end
			end
		end

	--dico all'oggetto evento le cose che dovra passare alla funzione
	currentEvent.phase=currentphase
	currentEvent.object1=body1
	currentEvent.object2=body2
	currentEvent.element1=element1
	currentEvent.element2=element2


	--se sono state impostate le funzioni le chiama, sia quella dell'evento
	--sia quella di all e passa loro l'RNCollisionEvent
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

local joint,bodyA,bodyB,anchorX,anchorY,anchorA_X,anchorA_Y,anchorB_X,anchorB_Y,axisA,axisB

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
    joint=world:addDistanceJoint(bodyA.body,bodyB.body,anchorA_X,anchorA_Y,anchorB_X,anchorB_Y)
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

--set RNJoint
local RNJoint=RNJoint:new()
RNJoint.joint=joint
RNJoint.type=type
RNJoint.bodyA=bodyA
RNJoint.bodyB=bodyB
	
return RNJoint 

end

