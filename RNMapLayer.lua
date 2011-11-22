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

function RNMapLayer:new(o)
    o = o or {
        name = ""
    }
    setmetatable(o, self)
    self.__index = self
    self.objects = {}
    return o
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
    return self.tiles[index]
end

function RNMapLayer:getOpacity()
    if self.opacity ~= nil then
        return self.opacity
    else
        return 1
    end
end

function RNMapLayer:getTilesAt(row, col)
    return self.tiles[(row * self.width) + col]
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
    return ""
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