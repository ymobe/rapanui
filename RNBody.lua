----------------------------------------------------------------
-- RapaNui Framework
--
-- https://github.com/eljeko/rapanui/
--
----------------------------------------------------------------


module(..., package.seeall)

function RNBody:new(o)

    o = o or {
        sprite = nil, --RNSprite
        body = nil, --physic Body
        type = nil, -- dynamic, static or kinematic
        name = "",
        parentList = nil,
        indexinlist = 0,
        fixturelist = {} --a table containing body's fixtures
    }

    setmetatable(o, self)
    self.__index = self
    return o
end

function RNBody:removeSelf()
    self.body:destroy()
    self.sprite:setAlpha(1)
    len = table.getn(self.parentList)
    ind = self.indexinlist
    for i = 1, len, 1 do
        if (i == ind) then
            for k = ind, len, 1
            do
                self.parentList[k - 1] = self.parentList[k] self.parentList[k].indexinlist = k - 1
            end
            self.parentList[len] = nil
        end
    end


    for i, v in ipairs(self.parentList) do
        v.indexinlist = i
    end
end

-------------------WORKING METHODS----------------------------------------
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
function RNBody:setLinearVelocity(value)
    self.body:setLinearVelocity(value)
end

-----Additional working accessible proprieties and methods from MOAIbox2d (check moai documentation)
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



----------------------Customized Transformation methods--------------------------------------


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

------physic bodies common working methods--------------------------------------------
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
function RNBody:applyLinearImpulse(impulseX, impulseX, pointX, pointY)
    if (pointX == nil) then self.body:applyLinearImpulse(impulseX, impulseX)
    elseif (pointY == nil) then self.body:applyLinearImpulse(impulseX, impulseX, pointX)
    else self.body:applyLinearImpulse(impulseX, impulseX, pointX, pointY)
    end
end

--body:applyAngularImpulse( number impulse )
function RNBody:applyAngularImpulse(value)
    self.body:applyAngularImpulse(value)
end

