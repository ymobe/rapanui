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

RNMapLayer = {}
local R
function RNMapLayer:new(o)
if not R then R = RN end
    o = o or {
        name = "",
        lastRenderedItems = {}
    }
    setmetatable(o, self)
    self.__index = self
    self.objects = {}
    return o
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
    return self.width
end

function RNMapLayer:getRows()
    return self.height
end

function RNMapLayer:getTilesAt(index)
    return tonumber(self.tiles[index])
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

function RNMapLayer:cleanLastRendering()
    for key, value in pairs(self.lastRenderedItems) do
        value:remove()
    end
end

--[[
function RNMapLayer:drawLayerAt_tileByTile(x, y, tileset)
    self:cleanLastRendering()
    self.lastRenderedItemSize = 0
    for col = 0, self:getCols() - 1 do
        local rowTiles = ""
        for row = 0, self:getRows() - 1 do
            local tileIdx = self:getTilesAt(row, col)
            local tileX = x + tileset:getTileWidth() * col + tileset:getTileWidth() / 2
            local tileY = y + tileset:getTileHeight() * row + tileset:getTileHeight() / 2

            if tileX > -tileset:getTileWidth() and tileX < config.width + tileset:getTileWidth() and
                    tileY > -tileset:getTileHeight() and tileY < config.height + tileset:getTileWidth() and tileIdx ~= tileset:getBlankTileId()
            then
                local aTile = tileset:getTileImage(tileIdx)
                self.lastRenderedItems[self.lastRenderedItemSize] = aTile
                self.lastRenderedItemSize = self.lastRenderedItemSize + 1
                aTile.x = tileX
                aTile.y = tileY
            end
        end
        rowTiles = ""
    end
end
]]

function RNMapLayer:drawLayerAt(x, y, tileset)
    if self.renderedMap ~= nil then
        self.renderedMap:remove()
    end

    local newMap = R.Factory.createBlankMoaiImage(config.width + tileset:getTileWidth(), config.height + tileset:getTileHeight())
    --collectgarbage("step")

    if self.aTileSample == nil then
        self.aTileSample = tileset:getTileImage(1)
        self.aTileSample:remove()
    end

    for col = 0, self:getCols() - 1 do
        local rowTiles = ""
        --local dummy1 = {}
        for row = 0, self:getRows() - 1 do
            local tileIdx = self:getTilesAt(row, col)

            local tileX = x + tileset:getTileWidth() * col
            local tileY = y + tileset:getTileHeight() * row

            if tileX > -tileset:getTileWidth() and tileX < config.width + tileset:getTileWidth() and
                    tileY > -tileset:getTileHeight() and tileY < config.height + tileset:getTileWidth() and tileIdx ~= tileset:getBlankTileId()
            then

                local tilerow = math.ceil(tileIdx / tileset.tilescols) - 1 -- Returns the smallest integer larger than or equal to the division result

                local tilemoduleRows = tileIdx % tileset.tilescols

                local tilecol

                if (tilemoduleRows > 0) then
                    tilecol = tilemoduleRows - 1
                else
                    tilecol = tileset.tilescols - 1
                end

                local tilesrcXMin = tilecol * tileset:getTileWidth()
                local tilesrcXMax = tilesrcXMin + tileset:getTileWidth()

                local tilesrcYMin = tilerow * tileset:getTileHeight()
                local tilesrcYMax = tilesrcYMin + tileset:getTileHeight()
                --   local dummy2 = {}




                local tileIsPhysical = tileset:getPropertyValueForTile(tileIdx, "isPhysical")
                if tileIsPhysical == nil then
                    newMap:copyBits(tileset.srcMoaiImage, tilesrcXMin, tilesrcYMin, tileX, tileY, tonumber(tileset:getTileWidth()), tonumber(tileset:getTileHeight()))
                else
                	--we don't draw here the tiles that should be phsyical
                	--but we store the their properties in a table
                	
                   	--we create the table if nil
                   	if self.imagesToBePhysical==nil then 
					   self.imagesToBePhysical={}
					end
					
					--we create and draw the RNObject at right coordinates
					local mimage=tileset:getTileImage(tileIdx)
                   	mimage.x=tileX
                   	mimage.y=tileY
                   	
                   	--we take other physical properties
                   	local mrestitution=tileset:getPropertyValueForTile(tileIdx, "restitution")  
                   	local mdensity=tileset:getPropertyValueForTile(tileIdx, "density")
                   	local mfriction=tileset:getPropertyValueForTile(tileIdx, "friction")
                   	local msensor=tileset:getPropertyValueForTile(tileIdx, "sensor")
                   	local mgroupIndex=tileset:getPropertyValueForTile(tileIdx, "groupIndex")
                   	local mtype=tileset:getPropertyValueForTile(tileIdx, "type")
                   	local mshape=tileset:getPropertyValueForTile(tileIdx, "shape")
                   	obj={}
                   	obj.image=mimage
                   	obj.restitution=mrestitution
                   	obj.density=mdensity
                   	obj.friction=mfriction
                   	obj.sensor=msensor
                   	obj.groupIndex=mgroupIndex
                   	obj.type=mtype
                   	obj.shape=mshape
                   	if obj.type==nil then
                   		obj.type="dynamic"
                   	end                  	
                   	table.insert(self.imagesToBePhysical,obj)
                end
            end
        end

        rowTiles = ""
        
        
    end

    self.renderedMap = R.Factory.createImageFromMoaiImage(newMap)
    self.renderedMap.x = self.renderedMap.x
    self.renderedMap.y = self.renderedMap.y
    
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
		currentLayer=self
		if currentLayer.imagesToBePhysical~=nil then
			for i=1,table.getn(currentLayer.imagesToBePhysical),1 do
				currentTile=currentLayer.imagesToBePhysical[i]			
				R.Physics.createBodyFromImage(currentTile.image,currentTile.type,{shape=currentTile.shape,density=tonumber(currentTile.density),restitution=tonumber(currentTile.restitution),friction=tonumber(currentTile.friction),sensor=currentTile.sensor,filter={groupIndex=tonumber(currentTile.groupIndex)}})	
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