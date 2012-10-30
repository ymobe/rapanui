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

RNMapLayer = {}

function RNMapLayer:new(o)
    o = o or {
        name = "",
        lastRenderedItems = {},
        lastRenderedBigTiles = {},
        lastRenderedTessellated = {},
        lastRenderedBigTilesSize = 0
    }
    setmetatable(o, self)
    self.__index = self
    self.objects = {}
    return o
end


function RNMapLayer:setLocatingMode(mode)
end


function RNMapLayer:setIDInScreen(id)
--    self.idInScreen = id
end


function RNMapLayer:updateLocation(mode)
end


function RNMapLayer:getProp()
    return self.prop
end


function RNMapLayer:setParentScene(scene)
    self.scene = scene
end


function RNMapLayer:init(map, screen)
    self.parentMap = map
    self.screen = screen
end


function RNMapLayer:getName()
    return self.name
end


function RNMapLayer:getTiles()
    return self.tiles
end


function RNMapLayer:getTilesCount()
    return self.tilesnumber
end


function RNMapLayer:getOrientation()
    return self.orientation
end


function RNMapLayer:getCols()
    return tonumber(self.width)
end


function RNMapLayer:getRows()
    return tonumber(self.height)
end




function RNMapLayer:getOpacity()
    if self.opacity ~= nil then
        return self.opacity
    else
        return 1
    end
end


function RNMapLayer:getTilesAt(row, col)
    return tonumber(self.tiles[(row * self.width) + col])
end


function RNMapLayer:getProperties()
    return self.properties
end

function RNMapLayer:getRowAndColFromCoordinates(xx, yy, aTileset)
    local map = self.parentMap
    local tileW = aTileset:getTileWidth()
    local tileH = aTileset:getTileHeight()
    for col = 0, map.layers[1]:getCols() - 1 do
        if xx >= tileW * (col + 1) - tileW + map.x and xx <= tileW * (col + 1) + map.x then
            for row = 0, map.layers[1]:getRows() - 1 do
                local tileIdx = map.layers[1]:getTilesAt(row, col)
                if yy >= tileH * (row + 1) - tileH + map.y and yy <= tileH * (row + 1) + map.y then
                    return row, col
                end
            end
        end
    end
end

function RNMapLayer:getTilePropertiesAt(xx, yy, aTileset)
    local row, col = self:getRowAndColFromCoordinates(xx, yy, aTileset)
    local tileId = self:getTilesAt(row, col)
    if aTileset:getPropertiesForTile(tileId) ~= nil then
        return aTileset:getPropertiesForTile(tileId)
    end
end

function RNMapLayer:getProperty(key)
    if self.propertiesSize > 0 then
        for lkey, lvalue in pairs(self.properties) do
            if lkey == key then
                return lvalue
            end
        end
    end
    return nil
end


function RNMapLayer:setLevel(level)
    self.prop:setPriority(level)
end

function RNMapLayer:getProp()
    return self.prop
end

function RNMapLayer:initLayer(x, y, tileset, drawmode)
    self.grid = MOAIGrid.new()
    self.grid:setRepeat(false)

    self.grid:setSize(self:getCols(), self:getRows(), tileset:getTileWidth(), tileset:getTileHeight(), 0, 0, tileset:getTileWidth(), tileset:getTileHeight())

    for row = 0, self:getRows() - 1 do
        local cols = {}
        for col = 0, self:getCols() - 1 do
            local tileIdx = self:getTilesAt(row, col)
            local tileIsPhysical = tileset:getPropertyValueForTile(tileIdx, "isPhysical")
            if tileIsPhysical == nil then
                table.insert(cols, tileIdx)
            else
                table.insert(cols, 0)
            end
        end
        self.grid:setRow(row + 1, unpack(cols))
    end

    self.prop = MOAIProp2D.new()
    self.prop:setDeck(tileset:getTileDeck2D())
    self.prop:setGrid(self.grid)
    self.screen:addRNObject(self)

    self.prop:setLoc(0, 0)

    self:drawPhysics(x, y, tileset)
end

function RNMapLayer:setAlpha(value)
    self.alpha = value
    self.prop:setColor(value, value, value, value, 0)
    if self.imagesToBePhysical ~= nil then
        for key, physicobj in pairs(self.imagesToBePhysical) do
            physicobj.image:setAlpha(value)
        end
    end
end


function RNMapLayer:drawLayerAt(x, y, tileset, drawmode)
    if self.prop == nil then
        self:initLayer(x, y, tileset, drawmode)
    end


    self.prop:setLoc(x, y)
end


function RNMapLayer:isRenderedTile(row, col)
    if self.lastRenderedTessellated[row] ~= nil
            and self.lastRenderedTessellated[row][col] ~= nil
    then
        --  print("tile at row:", row, "col:", col, "exists")
        return true
    else

        --    print("tile at row:", row, "col:", col, "isNew")
        return false
    end
end


function RNMapLayer:remove()
    self.parentMap = nil
    self.scene:removeRNObject(self)
    self.scene = nil
    self.prop:setDeck(nil)
    self.prop = nil
    self = nil
end


function RNMapLayer:drawPhysics(x, y, tileset)

    for col = 0, self:getCols() - 1 do
        local rowTiles = ""
        --local dummy1 = {}
        for row = 0, self:getRows() - 1 do
            local tileIdx = self:getTilesAt(row, col)

            local tileX = x + tileset:getTileWidth() * col
            local tileY = y + tileset:getTileHeight() * row



            local tileIsPhysical = tileset:getPropertyValueForTile(tileIdx, "isPhysical")
            --print("isPhysical", tileIsPhysical)
            if tileIsPhysical ~= nil then

                --we don't draw here the tiles that should be phsyical
                --but we store the their properties in a table

                --we create the table if nil
                if self.imagesToBePhysical == nil then
                    self.imagesToBePhysical = {}
                end

                --we create and draw the RNObject at right coordinates
                local mimage = tileset:getTileImage(tileIdx)
                mimage.x = tileX
                mimage.y = tileY

                --we take other physical properties
                local mrestitution = tileset:getPropertyValueForTile(tileIdx, "restitution")
                local mdensity = tileset:getPropertyValueForTile(tileIdx, "density")
                local mfriction = tileset:getPropertyValueForTile(tileIdx, "friction")
                local msensor = tileset:getPropertyValueForTile(tileIdx, "sensor")
                local mgroupIndex = tileset:getPropertyValueForTile(tileIdx, "groupIndex")
                local mtype = tileset:getPropertyValueForTile(tileIdx, "type")
                local mshape = tileset:getPropertyValueForTile(tileIdx, "shape")
                local obj = {}
                obj.image = mimage
                obj.restitution = mrestitution
                obj.density = mdensity
                obj.friction = mfriction
                obj.sensor = msensor
                obj.groupIndex = mgroupIndex
                obj.type = mtype
                obj.shape = mshape
                if obj.type == nil then
                    obj.type = "dynamic"
                end
                table.insert(self.imagesToBePhysical, obj)
            end
        end

        rowTiles = ""
    end

    self:createPhysicBodies()
end



function RNMapLayer:createPhysicBodies()
    --[[
        And here's a little snippet to create physical objects
        from the ones stored in the layer field.

        How to:

        In you tile layer
        add the property "isPhysical" to your tile and it'll become phsyical.

        you can also set
        friction
        desity
        restution
        sensor
        groupIndex
        type  ("static" or "dynamic")
        shape

    --]]
    local currentLayer = self
    if currentLayer.imagesToBePhysical ~= nil then
        for i = 1, table.getn(currentLayer.imagesToBePhysical), 1 do
            currentTile = currentLayer.imagesToBePhysical[i]
            RNPhysics.createBodyFromImage(currentTile.image, currentTile.type, { shape = currentTile.shape, density = tonumber(currentTile.density), restitution = tonumber(currentTile.restitution), friction = tonumber(currentTile.friction), sensor = currentTile.sensor, filter = { groupIndex = tonumber(currentTile.groupIndex) } })
        end
    end
end


function RNMapLayer:printToAscii()
    for row = 0, self:getCols() - 1 do
        local rowTiles = ""
        for col = 0, self:getRows() - 1 do
            rowTiles = rowTiles .. "[" .. string.format("%3d", self:getTilesAt(row, col)) .. "]"
        end
        print(rowTiles)
        rowTiles = ""
    end

    print("name:", self.name)
    print("tiles:", self.tilesnumber)
    print("cols:", self.width, "rows:", self.height)
    print("opacity:", self:getOpacity())

    if self.propertiesSize > 0 then
        for key, value in pairs(self.properties) do
            print(key, "=", value)
        end
    end
end

return RNMapLayer