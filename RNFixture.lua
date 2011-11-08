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

    if key ~= nil and key == "restitution" then
        self:setRestitution(value)
    end
    if key ~= nil and key == "density" then
        self:setDensity(value)
    end
    if key ~= nil and key == "friction" then
        self:setFriction(value)
    end
    if key ~= nil and key == "sensor" then
        self:setSensor(value)
    end
    if key ~= nil and key == "filter" then
        self:setFilter(value)
    end
end


local function fieldAccessListener(self, key)

    local object = getmetatable(self).__object

    --[[
    if key ~= nil and key == "key" then
        object.key = object:getSomething()
    end
    --]]


    return getmetatable(self).__object[key]
end

-- Create a new proxy


function RNFixture:new(o)
    local fixture = RNFixture:innerNew(o)
    local proxy = setmetatable({}, { __newindex = fieldChangedListener, __index = fieldAccessListener, __object = fixture })
    return proxy, physicObject
end



function RNFixture:innerNew(o)

    o = o or {
        name = "",
        myName = "",
        userdata = nil,
        fixture = nil,
        filter = {},
        density = 0,
        friction = 0,
        shape = nil,
        sensor = false,
        restitution = 0,
        radius = 0,
        parentBody = nil,
        indexinlist = 0,
    }
    setmetatable(o, self)
    self.__index = self
    return o
end




--Methods
--fixture is nil during body creation
--so we need to check it

function RNFixture:setCollisionHandler()
    --can be set through physical bodies
end

function RNFixture:destroy()
    --Fixture is destroyed with body:removeSelf()
end

function RNFixture:setDensity(value)
    if self.fixture ~= nil then self.fixture:setDensity(value) end
end

function RNFixture:setFilter(value)
    --value should be a table {categoryBits,maskBitsgroupIndex}
    if self.fixture ~= nil then self.fixture:setFilter(value) end
end

function RNFixture:setFriction(value)
    if self.fixture ~= nil then self.fixture:setFriction(value) end
end

function RNFixture:setRestitution(value)
    if self.fixture ~= nil then self.fixture:setRestitution(value) end
end

function RNFixture:setSensor(value)
    if self.fixture ~= nil then self.fixture:setSensor(value) end
end

