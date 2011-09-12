----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------


module(..., package.seeall)

function RNJoint:new(o)

    o = o or {
    joint=nil,  --box2d joint
    type=nil,
    bodyA=nil,     --RNBody
    bodyB=nil,     --RNBody
    indexingloballist=nil,   --index in global jointlist
    parentList=nil,          --RNPhisics global jointlist
    indexinbodyAlist=nil,     --index in his bodyA.jointlist
    indexinbodyBlist=nil,      --index in his body.jointlist
    --other proprieties for specific types of joint
    --specific for pulley joint
    ratio=nil,
    anchorA_X=nil,
    anchorA_Y=nil,
    anchorB_X=nil,
    anchorB_Y=nil,
    -- -- -- --
    }
    setmetatable(o, self)
    self.__index = self
    return o
end




-------------------------Physics Joint Methods----------------------------


 	
function RNJoint:getAnchorA()
return self.joint:getAnchorA()
end

function RNJoint:getAnchorB()
return self.joint:getAnchorB()
end

function RNJoint:getReactionForce()
return self.joint:getReactionForce()
end

function RNJoint:getReactionTorque()
return self.joint:getReactionTorque()
end

function RNJoint:setLimitEnabled(value)
self.joint:setLimitEnabled(value)
end

function RNJoint:setMotorEnabled(value)
self.joint:setMotorEnabled(value)
end

function RNJoint:setLimit(lower,upper)
self.joint:setLimit(lower,upper)
end

function RNJoint:setMotor(speed,max)
self.joint:setMotor(speed,max)
end

--specific methods for distance joints----------------------------------------------------
--distance between bodyA and bodyB of this joint
--it can be used also by other type of joints

function RNJoint:getLength()
return math.sqrt(math.pow(self.bodyA:getX()-self.bodyB:getX(),2)+math.pow(self.bodyA:getY()-self.bodyB:getY(),2))
end


--specific methods for pulley joints-------------------------------------------------------
--those methods CANNOT BE use by other type of joints, they CAN only be used by
--a pulley joints (because values as ration and anchors are stored only in 
--RNJoints of "pulley" type)

--distance between bodyA and Anchor point A
function RNJoint:getLength1()
return math.sqrt(math.pow(self.bodyA:getX()-self.anchorA_X,2)+math.pow(self.bodyA:getY()-self.anchorA_Y,2))
end

--distance between bodyB and Anchor point B
function RNJoint:getLength2()
return math.sqrt(math.pow(self.bodyB:getX()-self.anchorB_X,2)+math.pow(self.bodyB:getY()-self.anchorB_Y,2))
end

--ratio
function RNJoint:getRatio()
return self.ratio
end

------------------------remove-----------------------------------------------------------


function RNJoint:removeSelf()
self.joint:destroy()
--remove from global joint list (RNPhysics.jointlist) and update the list
len=table.getn(self.parentList)
ind=self.indexingloballist
for i=1,len,1 do
if (i==ind) then 
for k=ind, len,1 do self.parentList[k-1]=self.parentList[k] self.parentList[k].indexingloballist=k-1 end
self.parentList[len]=nil
end
end
--uptade other joints indexingloballist
for i,v in ipairs(self.parentList) do v.indexingloballist=i end

--remove from bodyA joint list (bodyA.jointlist) and update the list
len=table.getn(self.bodyA.jointlist)
ind=self.indexinbodyAlist
for i=1,len,1 do
if (i==ind) then 
for k=ind, len,1 do self.bodyA.jointlist[k-1]=self.bodyA.jointlist[k] self.bodyA.jointlist[k].indexinbodyAlist=k-1 end
self.bodyA.jointlist[len]=nil
end
end
--uptade other joints indexinbodyAlist
for i,v in ipairs(self.bodyA.jointlist) do v.indexinbodyAlist=i end


--remove from bodyB joint list (bodyB.jointlist) and update the list
len=table.getn(self.bodyB.jointlist)
ind=self.indexinbodyBlist
for i=1,len,1 do
if (i==ind) then 
for k=ind, len,1 do self.bodyB.jointlist[k-1]=self.bodyB.jointlist[k] self.bodyB.jointlist[k].indexinbodyBlist=k-1 end
self.bodyB.jointlist[len]=nil
end
end
--uptade other joints indexinbodyBlist
for i,v in ipairs(self.bodyB.jointlist) do v.indexinbodyBlist=i end
end