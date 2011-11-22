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


    if key ~= nil and key == "rotation" then
        self:setAngle(value)
    end

    if key ~= nil and key == "x" then
        self:setX(value)
    end

    if key ~= nil and key == "y" then
        self:setY(value)
    end

    if key ~= nil and key == "setAwake" then
        self:setAwake(value)
    end

    if key ~= nil and key == "setActive" then
        self:setActive(value)
    end

    if key ~= nil and key == "setBullet" then
        self:setBullet(value)
    end

    if key ~= nil and key == "setFixedRotation" then
        self:setFixedRotation(value)
    end

    if key ~= nil and key == "angularVelocity" then
        self:setAngularVelocity(value)
    end

    if key ~= nil and key == "angularDamping" then
        self:setAngularDamping(value)
    end

    if key ~= nil and key == "linearVelocityX" then
        self:setLinearVelocity(value, self.linearVelocityY)
    end

    if key ~= nil and key == "linearVelocityY" then
        self:setLinearVelocity(self.linearVelocityX, value)
    end

    if key ~= nil and key == "linearDamping" then
        self:setLinearDamping(value)
    end

    if key ~= nil and key == "isSensor" then
        self:setSensor(value)
    end

    if key ~= nil and key == "isSleepingAllowed" then
        print("isSleepingAllowed not available at the moment")
    end
    if key ~= nil and key == "bodyType" then
        print("bodyType not available at the moment")
    end
end


local function fieldAccessListener(self, key)

    local object = getmetatable(self).__object

    if key ~= nil and key == "rotation" then
        object.rotation = object:getAngle()
    end

    if key ~= nil and key == "x" then
        object.x = object:getX()
    end

    if key ~= nil and key == "y" then
        object.y = object:getY()
    end

    if key ~= nil and key == "userdata" then
        object.userdata = object.sprite.userdata
    end

    if key ~= nil and key == "isAwake" then
        object.isAwake = object:isAwake()
    end

    if key ~= nil and key == "isBodyActive" then
        object.isActive = object:isActive()
    end

    if key ~= nil and key == "isBullet" then
        object.isBullet = object:isBullet()
    end

    if key ~= nil and key == "isFixedRotation" then
        object.isFixedRotation = object:isFixedRotation()
    end

    if key ~= nil and key == "angularVelocity" then
        object.getAngularVelocity = object:getAngularVelocity()
    end

    if key ~= nil and key == "angularDamping" then
        object.getAngularDamping = object:getAngularDamping()
    end

    if key ~= nil and key == "linearVelocityX" then
        object.getLinearVelocityX, object.getLinearVelocityY = object:getLinearVelocity()
    end
    if key ~= nil and key == "linearVelocityY" then
        object.getLinearVelocityX, object.getLinearVelocityY = object:getLinearVelocity()
    end

    if key ~= nil and key == "linearDamping" then
        object.getLinearDamping = object:getLinearDamping()
    end

    if key ~= nil and key == "isSleepingAllowed" then
        print("isSleepingAllowed not available at the moment")
    end
    if key ~= nil and key == "bodyType" then
        print("bodyType not available at the moment")
    end




    return getmetatable(self).__object[key]
end

-- Create a new proxy 


function RNBody:new(o)
    local physicObject = RNBody:innerNew(o)
    local proxy = setmetatable({}, { __newindex = fieldChangedListener, __index = fieldAccessListener, __object = physicObject })
    return proxy, physicObject
end



function RNBody:innerNew(o)

    o = o or {
        sprite = nil, --RNSprite
        body = nil, --physic Body
        type = nil, -- dynamic, static or kinematic
        bodyType = "",
        name = "",
        x = nil,
        y = nil,
        rotation = nil,
        userdata = nil,
        myName = nil,
        isAwake = nil,
        setAwake = nil,
        isActive = nil,
        setActive = nil,
        isBullet = nil,
        setBullet = nil,
        isFixedRotation = nil,
        setFixedRotation = nil,
        angularVelocity = nil,
        angularDamping = nil,
        linearVelocityX = nil,
        linearVelocityY = nil,
        linearDamping = nil,
        isSleepingAllowed = true,
        isSensor = nil,
        parentList = nil, --bodylist in RNPhysics
        indexinlist = 0,
        fixturelist = {}, --a table containing body's fixtures
        jointlist = {},
        collision = nil, --stores the local collision function name
    }
    setmetatable(o, self)
    self.__index = self
    return o
end






function RNBody:remove()
    self.body:destroy()
    self.sprite.isPhysical = false
    --
    self.sprite.prop:setDeck(nil)
    --
    --remove this RNBody from body list and refresh the list fields.
    len = table.getn(self.parentList)
    ind = self.indexinlist
    for i = 1, len, 1 do
        if (i == ind) then
            for k = ind + 1, len, 1 do self.parentList[k - 1] = self.parentList[k] self.parentList[k].indexinlist = k - 1 end
            self.parentList[len] = nil
        end
    end
    --refresh other RNBody object's place in the bodylist.
    for i, v in ipairs(self.parentList) do v.indexinlist = i end

    --remove all the joints connected to this RNBody
    --and automatically remove the joints also from global,bodyA and bodyB jointlists)
    --
    --notes;since self.jointlist[i]removeSelf() will change self.jointlist itself
    --we'll use a temporary list to remove all joints.
    local tmpList = {}
    len = table.getn(self.jointlist)
    for i = 1, len, 1 do
        tmpList[i] = self.jointlist[i]
    end
    for i = 1, table.getn(tmpList) do
        tmpList[i]:remove()
    end
end






----------------- collision handling----------------------------------------
function RNBody:addEventListener(Type)
    if (Type == "collision") then
        flist = self.fixturelist
        len = table.getn(flist)
        --for each fixture in in self.fixturelist
        for i = 1, len, 1 do

            --sets the fixture for callbacks
            currentfixture = flist[i].fixture
            currentfixture:setCollisionHandler(RNPhysics.LocalCollisionHandling, MOAIBox2DArbiter.ALL)
        end
    end
end


------------------- WORKING METHODS----------------------------------------

--if it's awake (returns boolean)

function RNBody:isAwake()
    return self.body:isAwake()
end


--sets the body as awake (true or false)
function RNBody:setAwake(value)
    self.body:setAwake(value)
end


--if it's active (returns boolean)

function RNBody:isActive()
    return self.body:isActive()
end

--sets the body as active (true or false)
function RNBody:setActive(value)
    self.body:setActive(value)
end


--if it's bullet
function RNBody:isBullet()
    return self.body:isBullet()
end


--sets the body as bullet[a bullet body is under continuous collision checking] (true or false)
function RNBody:setBullet(value)
    self.body:setBullet(value)
end

--if its rotation is fixed (returns boolean)
function RNBody:isFixedRotation()
    return self.body:isFixedRotation()
end

--prevents the body from rotation (true or false)
function RNBody:setFixedRotation(value)
    self.body:setFixedRotation(value)
end

--gets the angular velocity
function RNBody:getAngularVelocity()
    return self.body:getAngularVelocity()
end

--sets the angular velocity
function RNBody:setAngularVelocity(value)
    self.body:setAngularVelocity(value)
end

--gets the linear damping
function RNBody:getLinearDamping()
    return self.body:getLinearDamping()
end

--sets the linear damping
function RNBody:setLinearDamping(value)
    self.body:setLinearDamping(value)
end

--gets the angular damping
function RNBody:getAngularDamping()
    return self.body:getAngularDamping()
end

--sets the angular damping
function RNBody:setAngularDamping(value)
    self.body:setAngularDamping(value)
end


--gets the linear velocity
function RNBody:getLinearVelocity()
    return self.body:getLinearVelocity()
end

--sets the linear velocity
function RNBody:setLinearVelocity(valuex, valuey)
    self.body:setLinearVelocity(valuex, valuey)
end


--sets all fixture of this body as sensors
function RNBody:setSensor(value)
    len = table.getn(self.fixturelist)
    for i = 1, len, 1 do
        self.fixturelist[i].fixture:setSensor(value)
        self.fixturelist[i].sensor = value
    end
end










----- Additional working accessible proprieties and methods from MOAIbox2d (check moai documentation)

--body:getAngle()
function RNBody:getAngle()
    return self.body:getAngle()
end

--body:getLocalCenter()
function RNBody:getLocalCenter()
    return self.body:getLocalCenter()
end

--body:getPosition()
function RNBody:getPosition()
    return self.body:getPosition()
end

--body:getWorldCenter()
function RNBody:getWorldCenter()
    return self.body:getWorldCenter()
end

--body:resetMassData()
function RNBody:resetMassData()
    self.body:resetMassData()
end

--body:setMassData(number mass [, number I, number centerX, number centerY ])
function RNBody:setMassData(mass, I, centerX, centerY)
    if (I == nil) then self.body:setMassData(mass)
    elseif (centerX == nil) then self.body:setMassData(mass, I)
    elseif (centerY == nil) then self.body:setMassData(mass, I, centerX)
    else self.body:setMassData(mass, I, centerX, centerY)
    end
end


--body:setTransform([, number positionX, number positionY, number angle ])
function RNBody:setTransform(positionX, positionY, angle)
    if (positionX == nil) then self.body:setTransform()
    elseif (positionY == nil) then self.body:setTransform(positionX)
    elseif (angle == nil) then self.body:setTransform(positionX, positionY)
    else self.body:setTransform(positionX, positionY, angle)
    end
end



---------------------- Customized Transformation methods--------------------------------------
function RNBody:setAngle(Angle)
    local posx, posy = self:getWorldCenter()
    self:setTransform(posx, posy, Angle)
end

function RNBody:setX(value)
    local posx, posy = self:getWorldCenter()
    local angle = self:getAngle()
    self:setTransform(value, posy, angle)
end

function RNBody:setY(value)
    local posx, posy = self:getWorldCenter()
    local angle = self:getAngle()
    self:setTransform(posx, value, angle)
end

function RNBody:getX()
    local xx, yy = self.body:getPosition()
    return xx
end

function RNBody:getY()
    local xx, yy = self.body:getPosition()
    return yy
end








------ physic bodies common working methods--------------------------------------------




--body:applyForce(number forceX, number forceY [, number pointX, number pointY ] )
function RNBody:applyForce(forceX, forceY, pointX, pointY)
    if (pointX == nil) then self.body:applyForce(forceX, forceY)
    elseif (pointY == nil) then self.body:applyForce(forceX, forceY, pointX)
    else self.body:applyForce(forceX, forceY, pointX, pointY)
    end
end

--body:applyTorque(number torque)
function RNBody:applyTorque(value)
    self.body:applyTorque(value)
end

--body:applyLinearImpulse(number impulseX, number impulseY [, number pointX, number pointY ] )
function RNBody:applyLinearImpulse(impulseX, impulseY, pointX, pointY)
    if (pointX == nil) then self.body:applyLinearImpulse(impulseX, impulseY)
    elseif (pointY == nil) then self.body:applyLinearImpulse(impulseX, impulseY, pointX)
    else self.body:applyLinearImpulse(impulseX, impulseY, pointX, pointY)
    end
end

--body:applyAngularImpulse( number impulse )
function RNBody:applyAngularImpulse(value)
    self.body:applyAngularImpulse(value)
end




-- additional methods from last update
 	
function RNBody:getInertia()
	return self.body:getInertia()
end

function RNBody:getMass()
	return self.body:getInertia()
end

function RNBody:setMassData(mass,I,centerX,centerY )
	if I~=nil then
		self.body:setMassData(mass,I,centerX,centerY)
	else
	    self.body:setMassData(mass)
	end
end