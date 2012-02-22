--[[
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
]]

RNMapObject = {}

function RNMapObject:new(o)
    o = o or {
        name = ""
    }
    setmetatable(o, self)
    self.__index = self
    self.objects = {}
    return o
end

function RNMapObject:getName()
    return self.name
end

function RNMapObject:getProperties()
    return self.properties
end

function RNMapObject:getPropertiesSize()
    return self.propertiesSize
end


function RNMapObject:getGid()
    return self.gid
end

function RNMapObject:getX()
    return self.x
end

function RNMapObject:getY()
    return self.y
end

function RNMapObject:getType()
    return self.type
end

function RNMapObject:getProperty(key)
    if self.propertiesSize > 0 then
        for lkey, lvalue in pairs(self.properties) do
            if lkey == key then
                return lvalue
            end
        end
    end
    return ""
end

return RNMapObject
