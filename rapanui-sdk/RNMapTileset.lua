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


function RNMapTileset:getBlankTileId()
    if self.blankTileId ~= nil then
        return self.blankTileId
    end
    return 0
end

function RNMapTileset:setBlankTileId(id)
    self.blankTileId = id
end

-- eturns the properties configured in the tileset for the given tile with id
function RNMapTileset:getPropertyValueForTile(id, property)
    if self.tilesproperties ~= nil and self.tilesproperties[id - 1] ~= nil then
        return self.tilesproperties[id - 1][property]
    else
        return nil
    end
end

function RNMapTileset:getPropertiesForTile(id)
    if self.tilesproperties[id - 1] ~= nil then
        return self.tilesproperties[id - 1]
    else
        return nil
    end
end

function RNMapTileset:getTileImage(tileid)

    if self.image.source ~= nil then
        if self.srcMoaiImage == nil then
            local src = RNFactory.createMoaiImage(self.image.source)
            local width, height = src:getSize()
            self.image.width = width
            self.image.height = height
            self.srcMoaiImage = src
            self.tilescols = self.image.width / self.tilewidth
            self.tilesrows = self.image.height / self.tileheight

            --self.tiles[(row * self.width) + col]
            self.srcMoaiImage = src
        end

        self.tilescols = self.image.width / self.tilewidth
        self.tilesrows = self.image.height / self.tileheight

        local row = math.ceil(tileid / self.tilescols) - 1 -- Returns the smallest integer larger than or equal to the division result

        local moduleRows = tileid % self.tilescols

        local col

        if (moduleRows > 0) then
            col = moduleRows - 1
        else
            col = self.tilescols - 1
        end

        local srcXMin = col * self.tilewidth
        local srcXMax = srcXMin + self.tilewidth

        local srcYMin = row * self.tileheight
        local srcYMax = srcYMin + self.tileheight

        local params = {
            top = 0,
            left = 0,
            srcXMin = srcXMin,
            srcYMin = srcYMin,
            srcXMax = srcXMax,
            srcYMax = srcYMax,
            destXMin = 0,
            destYMin = 0
        }

        return RNFactory.createCopyRect(self.srcMoaiImage, params)
    end
end




function RNMapTileset:getTileDeck2D()
    if self.tileDeck == nil then
        self.tileDeck = MOAITileDeck2D.new()
        self.tileDeck:setTexture(self.image.source)
        self.tileDeck:setSize(self.image.width / self:getTileWidth(), self.image.height / self:getTileHeight())
        self.tileDeck:setRect(-0.5, 0.5, 0.5, -0.5)
    end

    return self.tileDeck
end

function RNMapTileset:updateImageSource(image)

    -- check the new size of the image and update the width height
    self.image.source = image
    local moaiimage = MOAIImage.new()
    moaiimage:load(image, MOAIImage.TRUECOLOR + MOAIImage.PREMULTIPLY_ALPHA)
    self.image.width, self.image.height = moaiimage:getSize()

    if self.tileDeck ~= nil then
        self.tileDeck = MOAITileDeck2D.new()
        self.tileDeck:setTexture(self.image.source)
        self.tileDeck:setSize(self.image.width / self:getTileWidth(), self.image.height / self:getTileHeight())
        self.tileDeck:setRect(-0.5, 0.5, 0.5, -0.5)
    end
end

function RNMapTileset:getImage()
    return self.image.source
end

function RNMapTileset:getWidth()
    return tonumber(self.image.width)
end

function RNMapTileset:getHeight()
    return tonumber(self.image.height)
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


return RNMapTileset
