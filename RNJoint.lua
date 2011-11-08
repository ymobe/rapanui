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


local function fieldChangedListener(self, key, value)

    getmetatable(self).__object[key] = value
    self = getmetatable(self).__object

    --pivot
    if self.type == "pivot" then
        if key ~= nil and key == "isMotorEnabled" then
            self:setMotorEnabled(value)
        end

        if key ~= nil and key == "motorSpeed" then
            self:setMotor(value, 1000000000000000)
        end

        if key ~= nil and key == "maxMotorTorque" then
            self:setMaxMotorTorque(value)
        end

        if key ~= nil and key == "isLimitEnabled" then
            self:setLimitEnabled(value)
        end
    end
    --distance
    if self.type == "distance" then
        if key ~= nil and key == "length" then
            self:setLength(value)
        end

        if key ~= nil and key == "frequency" then
            self:setFrequency(value)
        end

        if key ~= nil and key == "dampingRatio" then
            self:setDampingRatio(value)
        end
    end
    --piston
    if self.type == "piston" then
        if key ~= nil and key == "isMotorEnabled" then
            self:setMotorEnabled(value)
        end
        if key ~= nil and key == "motorSpeed" then
            self:setMotor(value, 1000000000000000)
        end
        if key ~= nil and key == "maxMotorForce" then
            self:setMaxMotorForce(value)
        end
        if key ~= nil and key == "isLimitEnabled" then
            self:setLimitEnabled(value)
        end
    end
    --friction
    if self.type == "friction" then
        if key ~= nil and key == "maxForce" then
            self:setMaxForce(value)
        end

        if key ~= nil and key == "maxTorque" then
            self:setMaxTorque(value)
        end
    end
    --wheel
    if self.type == "wheel" then
        if key ~= nil and key == "isMotorEnabled" then
            self:setMotorEnabled(value)
        end
        if key ~= nil and key == "motorSpeed" then
            self:setMotor(value, 1000000000000000)
        end
        if key ~= nil and key == "maxMotorForce" then
            self:setMaxMotorForce(value)
        end
    end
    --gear
    if self.type == "gear" then
        if key ~= nil and key == "ratio" then
            self:setRatio(value)
        end
    end
    --mouse
    if self.type == "mouse" then
        if key ~= nil and key == "maxForce" then
            self:setMaxForce(value)
        end

        if key ~= nil and key == "frequency" then
            self:setFrequency(value)
        end
        if key ~= nil and key == "dampingRation" then
            self:setDampingRatio(value)
        end
    end
end


local function fieldAccessListener(self, key)


    local object = getmetatable(self).__object

    --pivot
    if object.type == "pivot" then
        if key ~= nil and key == "motorSpeed" then
            object.motorSpeed = object:getMotorSpeed()
        end

        if key ~= nil and key == "motorTorque" then
            object.motorTorque = object:getMotorTorque()
        end

        if key ~= nil and key == "isLimitEnabled" then
            object.isLimitEnabled = object:isLimitEnabled()
        end

        if key ~= nil and key == "jointAngle" then
            object.jointAngle = object:getJointAngle()
        end

        if key ~= nil and key == "jointSpeed" then
            object.jointSpeed = object:jointSpeed()
        end
    end

    --distance
    if object.type == "distance" then
        if key ~= nil and key == "length" then
            object.length = object:getLength()
        end

        if key ~= nil and key == "frequency" then
            object.frequency = object:getFrequency()
        end

        if key ~= nil and key == "dampingRatio" then
            object.dampingRatio = object:getDampingRatio()
        end
    end
    --piston
    if object.type == "distance" then
        if key ~= nil and key == "motorSpeed" then
            object.motorSpeed = object:getMotorSpeed()
        end
        if key ~= nil and key == "motorForce" then
            object.motorForce = object:getMotorForce()
        end
        if key ~= nil and key == "isLimitEnabled" then
            object.isLimitEnabled = object:isLimitEnabled()
        end
        if key ~= nil and key == "jointTranslation" then
            object.jointTranslation = object:getJointTranslation()
        end
        if key ~= nil and key == "jointSpeed" then
            object.jointSpeed = object:jointSpeed()
        end
    end
    --friction
    if object.type == "friction" then
        if key ~= nil and key == "maxForce" then
            object.maxForce = object:getMaxForce()
        end
        if key ~= nil and key == "maxTorque" then
            object.maxTorque = object:getMaxTorque()
        end
    end
    --wheel
    if object.type == "wheel" then
        if key ~= nil and key == "motorSpeed" then
            object.motorSpeed = object:getMotorSpeed()
        end
        if key ~= nil and key == "motorForce" then
            object.motorForce = object:getMotorForce()
        end
        if key ~= nil and key == "jointSpeed" then
            object.jointSpeed = object:jointSpeed()
        end
        if key ~= nil and key == "jointTranslation" then
            object.jointTranslation = object:getJointTranslation()
        end
    end
    --pulley
    if object.type == "pulley" then
        if key ~= nil and key == "length1" then
            object.length1 = object:getLength1()
        end
        if key ~= nil and key == "length2" then
            object.length2 = object:getLength2()
        end
        if key ~= nil and key == "ratio" then
            object.ratio = object:getRatio()
        end
        if key ~= nil and key == "groundAnchorA" then
            object.groundAnchorA = object:getGroundAnchorA()
        end
        if key ~= nil and key == "groundAnchorB" then
            object.groundAnchorB = object:getGroundAnchorB()
        end
    end
    --gear
    if object.type == "gear" then
        if key ~= nil and key == "jointA" then
            object.jointA = object:getJointA()
        end
        if key ~= nil and key == "jointB" then
            object.jointB = object:getJointB()
        end
        if key ~= nil and key == "ratio" then
            object.ratio = object:ratio()
        end
    end
    --mouse
    if object.type == "mouse" then
        if key ~= nil and key == "maxForce" then
            object.maxForce = object:getMaxForce()
        end
        if key ~= nil and key == "frequency" then
            object.frequency = object:getFrequency()
        end
        if key ~= nil and key == "dampingRatio" then
            object.dampingRatio = object:getDampingRatio()
        end
    end


    return getmetatable(self).__object[key]
end


-- Create a new proxy for RNObject Object


function RNJoint:new(o)
    local physicJoint = RNJoint:innerNew()
    local proxy = setmetatable({}, { __newindex = fieldChangedListener, __index = fieldAccessListener, __object = physicJoint })
    return proxy, physicJoint
end




function RNJoint:innerNew(o)

    o = o or {
        joint = nil, --box2d joint
        type = nil,
        bodyA = nil, --RNBody
        bodyB = nil, --RNBody
        userdata = nil,
        myName = nil,
        indexingloballist = nil, --index in global jointlist
        parentList = nil, --RNPhisics global jointlist
        indexinbodyAlist = nil, --index in his bodyA.jointlist
        indexinbodyBlist = nil, --index in his bodyB.jointlist
        --other proprieties for specific types of joint
        --pivot and some piston and some wheel
        isMotorEnabled = false, -- (boolean)
        motorSpeed = 0,
        motorTorque = 0, -- (get-only)
        maxMotorTorque = 0, -- (set-only)
        isLimitEnabled = false,
        jointAngle = 0,
        jointSpeed = 0,
        --distance and some mouse
        length = 0,
        frequency = 0,
        dampingRatio = 0,
        --piston and some wheel and some mouse
        motorForce = 0,
        maxMotorForce = 0,
        jointTranslation = 0,
        --friction
        maxForce = 0,
        maxTorque = 0,
        --pulley
        length1 = 0,
        length2 = 0,
        ratio = 0,
        groundAnchorA = nil,
        groundAnchorB = nil,
        --gear
        jointA = nil,
        jointB = nil,
        ratio = 0,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end



------------------------- Physics Joint Methods----------------------------

--- PIVOT / REVOLUTE  JOINT    and some PISTON / REVOLUTE JOINT and some WHEEL /LINE JOINT
function RNJoint:getJointAngle()
    if self.type == "pivot" then
        return self.joint:getJointAngle()
    end
end

function RNJoint:getJointSpeed()
    if self.type == "pivot" or "piston" or "wheel" then
        return self.joint:getJointSpeed()
    end
end

function RNJoint:getLowerLimit()
    if self.type == "pivot" or "piston" or "wheel" then
        return self.joint:getLowerLimit()
    end
end

function RNJoint:getMotorSpeed()
    if self.type == "pivot" or "piston" or "wheel" then
        return self.joint:getMotorSpeed()
    end
end

function RNJoint:getMotorTorque()
    if self.type == "pivot" then
        return self.joint:getMotorTorque()
    end
end

function RNJoint:getUpperLimit()
    if self.type == "pivot" or "piston" or "wheel" then
        return self.joint:getUpperLimit()
    end
end

function RNJoint:isLimitEnabled()
    if self.type == "pivot" or "piston" or "wheel" then
        return self.joint:isLimitEnabled()
    end
end

function RNJoint:isMotorEnabled()
    if self.type == "pivot" or "piston" or "wheel" then
        return self.joint:isMotorEnabled()
    end
end

function RNJoint:setLimit(lower, upper)
    if self.type == "pivot" or "piston" or "wheel" then
        if lower ~= nil then self.joint:setLimit(lower, upper) else self.joint:setLimit() end
    end
end

function RNJoint:setLimitEnabled(value)
    if self.type == "pivot" or "piston" or "wheel" then
        if value ~= nil then self.joint:setLimitEnabled(value) else self.joint:setLimitEnabled() end
    end
end

function RNJoint:setMaxMotorTorque(value)
    if self.type == "pivot" then
        if value ~= nil then self.joint:setMaxMotorTorque(value) else self.joint:setMaxMotorTorque() end
    end
end

function RNJoint:setMotor(speed, max)
    if self.type == "pivot" or "piston" or "wheel" then
        if speed ~= nil then self.joint:setMotor(speed, max) else self.joint:setMotor() end
    end
end

function RNJoint:setMotorEnabled(value)
    if self.type == "pivot" or "piston" or "wheel" then
        if value ~= nil then self.joint:setMotorEnabled(value) else self.joint:setMotorEnabled() end
    end
end

function RNJoint:setRotationLimits(lower, upper)
    if self.type == "pivot" then
        self:setLimit(lower, upper)
    end
end

function RNJoint:getRotationLimits()
    if self.type == "pivot" then
        return self:getLowerLimit(), self:getUpperLimit()
    end
end


--DISTANCE JOINT

function RNJoint:getDampingRatio()
    if self.type == "distance" or "mouse" then
        return self.joint:getDampingRatio()
    end
end

function RNJoint:getFrequency()
    if self.type == "distance" or "mouse" then
        return self.joint:getFrequency()
    end
end


function RNJoint:getLength()
    if self.type == "distance" then
        return self.joint:getLength()
    end
end

function RNJoint:setDampingRatio(value)
    if self.type == "distance" or "mouse" then
        if value ~= nil then self.joint:setDampingRatio(value) else self.joint:setDampingRatio() end
    end
end

function RNJoint:setFrequency(value)
    if self.type == "distance" or "mouse" then
        if value ~= nil then self.joint:setFrequency(value) else self.joint:setFrequency() end
    end
end

function RNJoint:setLength(value)
    if self.type == "distance" then
        if value ~= nil then self.joint:setLength(value) else self.joint:setLength() end
    end
end


--PISTON / PRISMATIC JOINT  and some WHEEL/LINE JOINT

function RNJoint:getJointTranslation()
    if self.type == "piston" or "wheel" then
        return self.joint:getJointTranslation()
    end
end

function RNJoint:getMotorForce()
    if self.type == "piston" or "wheel" then
        return self.joint:getMotorForce()
    end
end

function RNJoint:setMaxMotorForce(value)
    if self.type == "distance" or "wheel" then
        if value ~= nil then self.joint:setMaxMotorForce(value) else self.joint:setMaxMotorForce() end
    end
end

function RNJoint:getLimits()
    if self.type == "piston" then
        return self:getLowerLimit(), self:getUpperLimit()
    end
end

function RNJoint:setLimits()
    if self.type == "piston" then
        self:setLimit(lower, upper)
    end
end

--FRICTION JOINT

function RNJoint:getMaxForce()
    if self.type == "friction" or "mouse" then
        return self.joint:getMaxForce()
    end
end

function RNJoint:getMaxTorque()
    if self.type == "friction" then
        return self.joint:getMaxTorque()
    end
end

function RNJoint:setMaxForce(value)
    if self.type == "friction" or "mouse" then
        if value ~= nil then self.joint:setMaxForce(value) else self.joint:setMaxForce() end
    end
end

function RNJoint:setMaxTorque(value)
    if self.type == "friction" then
        if value ~= nil then self.joint:setMaxTorque(value) else self.joint:setMaxTorque() end
    end
end

--WHEEL / LINE JOINT
--check above joint functions


--PULLEY JOINT

function RNJoint:getGroundAnchorA()
    if self.type == "pulley" then
        return self.joint:getGroundAnchorA()
    end
end

function RNJoint:getGroundAnchorB()
    if self.type == "pulley" then
        return self.joint:getGroundAnchorB()
    end
end

function RNJoint:getLength1()
    if self.type == "pulley" then
        return self.joint:getLength1()
    end
end

function RNJoint:getLength2()
    if self.type == "pulley" then
        return self.joint:getLength2()
    end
end

function RNJoint:getRatio()
    if self.type == "pulley" then
        return self.joint:getRatio()
    end
end

--GEAR JOINT

function RNJoint:getJointA()
    if self.type == "gear" then
        return self.joint:getJointA()
    end
end

function RNJoint:getJointB()
    if self.type == "gear" then
        return self.joint:getJointB()
    end
end

function RNJoint:getRatio()
    if self.type == "gear" then
        return self.joint:getRatio()
    end
end

function RNJoint:setRatio(value)
    if self.type == "gear" then
        if value ~= nil then self.joint:setRatio(value) else self.joint:setRatio() end
    end
end


--MOUSE JOINT

function RNJoint:getTarget()
    if self.type == "mouse" then
        return self.joint:getTarget()
    end
end

function RNJoint:setTarget(xx, yy)
    if self.type == "mouse" then
        self.joint:setTarget(xx, yy)
    end
end



------------------------ remove-----------------------------------------------------------
function RNJoint:remove()

    self.joint:destroy()
    --remove from global joint list (RNPhysics.jointlist) and update the list
    len = table.getn(self.parentList)
    ind = self.indexingloballist
    for i = 1, len, 1 do
        if (i == ind) then
            for k = ind + 1, len, 1 do self.parentList[k - 1] = self.parentList[k] self.parentList[k].indexingloballist = k - 1 end
            self.parentList[len] = nil
        end
    end
    --uptade other joints indexingloballist
    for i, v in ipairs(self.parentList) do v.indexingloballist = i end

    --remove from bodyA joint list (bodyA.jointlist) and update the list
    len = table.getn(self.bodyA.jointlist)
    ind = self.indexinbodyAlist
    for i = 1, len, 1 do
        if (i == ind) then
            for k = ind + 1, len, 1 do self.bodyA.jointlist[k - 1] = self.bodyA.jointlist[k] self.bodyA.jointlist[k].indexinbodyAlist = k - 1 end
            self.bodyA.jointlist[len] = nil
        end
    end
    --update other joints indexinbodyAlist or indexinbodyBlist
    --depending on their bind to bodyA
    for i, v in ipairs(self.bodyA.jointlist) do
        if self.bodyA == v.bodyA then
            v.indexinbodyAlist = i
        else
            v.indexinbodyBlist = i
        end
    end


    --remove from bodyB joint list (bodyB.jointlist) and update the list
    len = table.getn(self.bodyB.jointlist)
    ind = self.indexinbodyBlist
    for i = 1, len, 1 do
        if (i == ind) then
            for k = ind + 1, len, 1 do self.bodyB.jointlist[k - 1] = self.bodyB.jointlist[k] self.bodyB.jointlist[k].indexinbodyBlist = k - 1 end
            self.bodyB.jointlist[len] = nil
        end
    end
    --update other joints indexinbodyBlist or indexinbodyAlist
    --depending on their bind to bodyB
    for i, v in ipairs(self.bodyB.jointlist) do
        if self.bodyB == v.bodyB then
            v.indexinbodyBlist = i
        else
            v.indexinbodyAlist = i
        end
    end
end