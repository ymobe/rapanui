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

RNTiledLuaMapParser = {}


function RNTiledLuaMapParser.printAttributes(attributes, indent)

    if attributes == nil then return end
    indent = indent or ""

    for key, value in pairs(attributes) do
        print(indent .. key .. " = " .. value)
    end
end

function RNTiledLuaMapParser.load(map, filename)
    --  local xml = MOAIXmlParser.parseFile(filename)

    map.layersSize = 0
    map.objectgroupsSize = 0
    map.tilesetsSize = 0
    map.tilesets = {}
    map.layers = {}
    map.propertiesSize = 0
    map.objectgroups = {}

    --local mapLua = require(filename)
    local mapLua = dofile(filename)

    -- map     --

    for key, value in pairs(mapLua) do
        if type(value) ~= "table" then
            map[key] = value --node.attributes.key
        end
    end

    if mapLua.properties then
        map.properties = {}
        local size = RNTiledLuaMapParser.loadProperties(map.properties, mapLua.properties)
        map.propertiesSize = size
    end

    -- tileset --

    if mapLua.tilesets then

        for key, value in pairs(mapLua.tilesets) do
            -- setup tilesets
            map.tilesets[map.tilesetsSize] = RNMapTileset:new()

            for key, value in pairs(value) do

                --setup all the properties
                if type(value) == "string" or type(value) == "number" then
                    map.tilesets[map.tilesetsSize][key] = value
                end
            end

            map.tilesets[map.tilesetsSize].image = {}
            map.tilesets[map.tilesetsSize].image.source = value.image

            map.tilesets[map.tilesetsSize].image.height = value.imageheight
            map.tilesets[map.tilesetsSize].image.width = value.imagewidth

            -- setup tiles properties
            if value.tiles then

                for key, aTileValue in pairs(value.tiles) do

                    if map.tilesets[map.tilesetsSize].tilesproperties == nil then
                        map.tilesets[map.tilesetsSize].tilesproperties = {}
                    end

                    if map.tilesets[map.tilesetsSize].tilesproperties[aTileValue.id] == nil then
                        map.tilesets[map.tilesetsSize].tilesproperties[aTileValue.id] = {}
                    end

                    local size = RNTiledLuaMapParser.loadProperties(map.tilesets[map.tilesetsSize].tilesproperties[aTileValue.id], aTileValue.properties)
                    map.tilesets[map.tilesetsSize].tilespropertiesSize = size
                end
            end

            map.tilesetsSize = map.tilesetsSize + 1
        end
    end

    -- layers  --

    if mapLua.layers then
        for key, value in pairs(mapLua.layers) do

            if value.type == "tilelayer" then
                map.layers[map.layersSize] = RNMapLayer:new()

                for key, value in pairs(value) do
                    if type(value) == "string" or type(value) == "number" then
                        map.layers[map.layersSize][key] = value
                    end
                end

                -- setup tiles number
                map.layers[map.layersSize].tilesnumber = 0
                map.layers[map.layersSize].tiles = {}
                map.layers[map.layersSize].propertiesSize = 0

                if value.properties then
                    if map.layers[map.layersSize].properties == nil then
                        map.layers[map.layersSize].properties = {}
                    end
                    local propertiesSize = RNTiledLuaMapParser.loadProperties(map.layers[map.layersSize].properties, value.properties)

                    map.layers[map.layersSize].propertiesSize = propertiesSize
                end

                if value.data then
                    for key, value in pairs(value.data) do
                        map.layers[map.layersSize].tiles[map.layers[map.layersSize].tilesnumber] = value
                        map.layers[map.layersSize].tilesnumber = map.layers[map.layersSize].tilesnumber + 1
                    end
                end

                map.layersSize = map.layersSize + 1

                -- object layers  --

            elseif value.type == "objectgroup" then

                map.objectgroups[map.objectgroupsSize] = RNMapObjectGroup:new()

                for key, value in pairs(value) do
                    if type(value) == "string" or type(value) == "number" then
                        map.objectgroups[map.objectgroupsSize][key] = value
                    end
                end
                map.objectgroups[map.objectgroupsSize].objectsSize = 0
                map.objectgroups[map.objectgroupsSize].objects = {}

                if value.properties then
                    if map.objectgroups[map.objectgroupsSize].properties == nil then
                        map.objectgroups[map.objectgroupsSize].properties = {}
                    end
                    local size = RNTiledLuaMapParser.loadProperties(map.objectgroups[map.objectgroupsSize].properties, value.properties)
                    map.objectgroups[map.objectgroupsSize].propertiesSize = size
                end

                if value.objects then
                    for key, value in pairs(value.objects) do
                        local currentName = map.objectgroups[map.objectgroupsSize].objectsSize

                        map.objectgroups[map.objectgroupsSize].objects[currentName] = RNMapObject:new()

                        for key, value in pairs(value) do
                            map.objectgroups[map.objectgroupsSize].objects[currentName][key] = value
                        end

                        if value.properties then
                            if map.objectgroups[map.objectgroupsSize].objects[currentName].properties == nil then
                                map.objectgroups[map.objectgroupsSize].objects[currentName].properties = {}
                            end
                            local size = RNTiledLuaMapParser.loadProperties(map.objectgroups[map.objectgroupsSize].objects[currentName].properties, value.properties)
                            map.objectgroups[map.objectgroupsSize].objects[currentName].propertiesSize = size
                        end

                        map.objectgroups[map.objectgroupsSize].objectsSize = map.objectgroups[map.objectgroupsSize].objectsSize + 1
                    end
                end

                map.objectgroupsSize = map.objectgroupsSize + 1
            end
        end
    end



    return map
end

function RNTiledLuaMapParser.loadProperties(targetMapItem, value)
    local propertiesFound = 0

    for key, aValue in pairs(value) do
        targetMapItem[key] = aValue
        propertiesFound = propertiesFound + 1
    end

    return propertiesFound
end

return RNTiledLuaMapParser