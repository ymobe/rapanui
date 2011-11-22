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

RNMapTileset = {}

function RNMapTileset:new(o)
    o = o or {
        name = ""
    }
    setmetatable(o, self)
    self.__index = self
    self.objects = {}
    return o
end

function RNMapTileset:getTilesets()
    return self.tilesets
end

function RNMapTileset:getFirstGid()

    return self.firstgid
end

function RNMapTileset:getTileWidth()
    return self.tilewidth
end

function RNMapTileset:getTileHeight()
    return self.tileheight
end

function RNMapTileset:getTilesetsSize()
    return self.tilesetsSize
end

-- returns the properties configured in the tileset for the given tile with id
function RNMapTileset:getPropertiesForTile(id)
    if self.tilesproperties[id] ~= nil then
        return self.tilesproperties[id]
    else
        return {}
    end
end

function RNMapTileset:getImage()
    return self.image.source
end

function RNMapTileset:getWidth()
    return self.image.width
end

function RNMapTileset:getHeight()
    return self.image.height
end

-- returns the list of tiles with properties configured in the tileset
function RNMapTileset:getAllTilesProperties()
    if self.tilesproperties ~= nil then
        return self.tilesproperties
    else
        return {}
    end
end

function RNMapTileset:getName()
    return self.name
end


