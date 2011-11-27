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

RNMap = {}

function RNMap:new(o)
    o = o or {
        name = ""
    }
    setmetatable(o, self)
    self.__index = self
    self.objects = {}
    return o
end

function RNMap:getLayers()
    return self.layers
end

function RNMap:getLayersSize()
    return self.layersSize
end


function RNMap:getOrientation()
    return self.orientation
end

function RNMap:getCols()
    return self.width
end

function RNMap:getRows()
    return self.height
end

function RNMap:getTileWidth()
    return self.tilewidth
end

function RNMap:getTileHeight()
    return self.tileheight
end

function RNMap:getTileset(index)
    return self.tilesets[index]
end

function RNMap:getTilesetSize()
    return self.tilesetsSize
end

function RNMap:getProperties()
    return self.properties
end

function RNMap:getProperty(key)
    if self.propertiesSize > 0 then
        for lkey, lvalue in pairs(self.properties) do
            if lkey == key then
                return lvalue
            end
        end
    end
    return ""
end

function RNMap:getFirstLayerByName(name)
    for key, value in pairs(self.layers) do
        if value.name == name then
            return value
        end
    end
    return {}
end

function RNMap:getFirstObjectGroupByName(name)
    for key, value in pairs(self.objectgroups) do
        if value.name == name then
            return value
        end
    end
    return {}
end

function RNMap:drawMapAt(x, y, tileset)
    local layersSize = self:getLayersSize()

    for i = 0, layersSize - 1 do
        local layer = self.layers[i]
        layer:drawLayerAt(x, y, tileset)
    end
end


