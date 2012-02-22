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

RNMapObjectGroup = {}

function RNMapObjectGroup:new(o)
    o = o or {
        name = ""
    }
    setmetatable(o, self)
    self.__index = self
    self.objects = {}
    return o
end

function RNMapObjectGroup:getName()
    return self.name
end

function RNMapObjectGroup:getObjects()
    return self.objects
end

function RNMapObjectGroup:getObject(index)
    return self.objects[index]
end

function RNMapObjectGroup:getFirstObjectByName(name)
    for key, value in pairs(self.objects) do
        if value.name == name then
            return value
        end
    end

    return nil
end

function RNMapObjectGroup:getPropertiesSize()
    return self.propertiesSize
end

function RNMapObjectGroup:getObjectsSize()
    return self.objectsSize
end


function RNMapObjectGroup:getProperties()
    return self.properties
end

function RNMapObjectGroup:getProperty(key)
    if self.propertiesSize > 0 then
        for lkey, lvalue in pairs(self.properties) do
            if lkey == key then
                return lvalue
            end
        end
    end
    return ""
end

return RNMapObjectGroup
