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


RNTiledMapParser = {}

function RNTiledMapParser.printAttributes(attributes, indent)

    if attributes == nil then return end
    indent = indent or ""

    for key, value in pairs(attributes) do
        print(indent .. key .. " = " .. value)
    end
end

function RNTiledMapParser.load(map, filename)

    local xml = MOAIXmlParser.parseFile(filename)

    map.layersSize = 0
    map.objectgroupsSize = 0
    map.tilesetsSize = 0
    map.tilesets = {}
    map.layers = {}
    map.propertiesSize = 0
    map.objectgroups = {}


    RNTiledMapParser.parseNode(xml, map)
    return map
end

function RNTiledMapParser.parseNode(node, map)

    if node.type then
        if node.type == "map" then

            for key, value in pairs(node.attributes) do
                if tonumber(value) ~= nil then
                    map[key] = tonumber(value) --node.attributes.key
                else
                    map[key] = value --node.attributes.key
                end
            end

            if node.children.properties then
                map.properties = {}
                local size = RNTiledMapParser.loadNodeProperties(map.properties, node)
                map.propertiesSize = size
            end
        end

        -- TILESET NODES PARSING

        if node.type == "tileset" then

            map.tilesets[map.tilesetsSize] = RNMapTileset:new()

            for key, value in pairs(node.attributes) do
                if tonumber(value) ~= nil then
                    map.tilesets[map.tilesetsSize][key] = tonumber(value)
                else
                    map.tilesets[map.tilesetsSize][key] = value
                end
            end


            if node.children.image then
                map.tilesets[map.tilesetsSize].image = {}
                for key, value in pairs(node.children.image) do
                    for key, value in pairs(value.attributes) do
                        map.tilesets[map.tilesetsSize].image[key] = value
                    end
                end
            end

            -- find properties for tileset
            if node.children.properties then
                if map.tilesets[map.tilesetsSize].properties == nil then
                    map.tilesets[map.tilesetsSize].properties = {}
                end
                local propertiesSize = RNTiledMapParser.loadNodeProperties(map.tilesets[map.tilesetsSize].properties, node)
                map.tilesets[map.tilesetsSize].propertiesSize = propertiesSize
            end

            -- find properties for tileset's tiles
            if node.children.tile ~= nil then
                for key, value in pairs(node.children.tile) do
                    if map.tilesets[map.tilesetsSize].tilesproperties == nil then
                        map.tilesets[map.tilesetsSize].tilesproperties = {}
                    end

                    if map.tilesets[map.tilesetsSize].tilesproperties[tonumber(value.attributes.id)] == nil then
                        map.tilesets[map.tilesetsSize].tilesproperties[tonumber(value.attributes.id)] = {}
                    end

                    local size = RNTiledMapParser.loadNodeProperties(map.tilesets[map.tilesetsSize].tilesproperties[tonumber(value.attributes.id)], value)
                    map.tilesets[map.tilesetsSize].tilespropertiesSize = size
                end
            end
            map.tilesetsSize = map.tilesetsSize + 1
        end

        -- LAYER NODES PARSING

        if node.type == "layer" then

            map.layers[map.layersSize] = RNMapLayer:new()

            for key, value in pairs(node.attributes) do
                map.layers[map.layersSize][key] = value
            end

            -- setup tiles number
            map.layers[map.layersSize].tilesnumber = 0
            map.layers[map.layersSize].tiles = {}
            map.layers[map.layersSize].propertiesSize = 0


            if node.children.properties then
                if map.layers[map.layersSize].properties == nil then
                    map.layers[map.layersSize].properties = {}
                end
                local propertiesSize = RNTiledMapParser.loadNodeProperties(map.layers[map.layersSize].properties, node)
                map.layers[map.layersSize].propertiesSize = propertiesSize
            end

            if node.children.data then
                for key, value in pairs(node.children.data) do
                    for key, value in pairs(value) do
                        -- check for all tile nodes
                        if type(value) == "table" then
                            for key, value in pairs(value) do
                                for key, value in pairs(value) do
                                    map.layers[map.layersSize].tiles[map.layers[map.layersSize].tilesnumber] = tonumber(value.attributes.gid)
                                    map.layers[map.layersSize].tilesnumber = map.layers[map.layersSize].tilesnumber + 1
                                end
                            end
                        end
                    end
                end
            end

            map.layersSize = map.layersSize + 1
        end

        -- OBJECTS NODES PARSING

        if node.type == "objectgroup" then

            map.objectgroups[map.objectgroupsSize] = RNMapObjectGroup:new()

            for key, value in pairs(node.attributes) do
                if tonumber(value) ~= nil then

                    map.objectgroups[map.objectgroupsSize][key] = tonumber(value)
                else
                    map.objectgroups[map.objectgroupsSize][key] = value
                end
            end


            map.objectgroups[map.objectgroupsSize].objectsSize = 0
            map.objectgroups[map.objectgroupsSize].objects = {}

            if node.children.properties then
                if map.objectgroups[map.objectgroupsSize].properties == nil then
                    map.objectgroups[map.objectgroupsSize].properties = {}
                end
                local size = RNTiledMapParser.loadNodeProperties(map.objectgroups[map.objectgroupsSize].properties, node)
                map.objectgroups[map.objectgroupsSize].propertiesSize = size
            end

            -- map.objectgroups[map.objectgroupsSize].objects.objectsInGroupSize = 0

            if node.children.object then
                for key, value in pairs(node.children.object) do

                    -- check for all objects nodes
                    if type(value) == "table" then

                        local currentName = map.objectgroups[map.objectgroupsSize].objectsSize

                        map.objectgroups[map.objectgroupsSize].objects[currentName] = RNMapObject:new()
                        map.objectgroups[map.objectgroupsSize].objectsSize = map.objectgroups[map.objectgroupsSize].objectsSize + 1

                        for key, value in pairs(value.attributes) do
                            if tonumber(value) ~= nil then
                                map.objectgroups[map.objectgroupsSize].objects[currentName][key] = tonumber(value)
                            else
                                map.objectgroups[map.objectgroupsSize].objects[currentName][key] = value
                            end
                        end

                        if value.children ~= nill and value.children.properties ~= nil then
                            if map.objectgroups[map.objectgroupsSize].objects[currentName].properties == nil then
                                map.objectgroups[map.objectgroupsSize].objects[currentName].properties = {}
                            end
                            local size = RNTiledMapParser.loadNodeProperties(map.objectgroups[map.objectgroupsSize].objects[currentName].properties, value)
                            map.objectgroups[map.objectgroupsSize].objects[currentName].propertiesSize = size
                        end
                    end
                    --map.objectgroups[map.objectgroupsSize].objects.objectsInGroupSize = map.objectgroups[map.objectgroupsSize].objects.objectsInGroupSize + 1
                end
            end
            map.objectgroupsSize = map.objectgroupsSize + 1
        end
    end

    if node.children == nil then return end

    for key, value in pairs(node.children) do
        for key, value in ipairs(value) do
            if type(value) == "table" then
                RNTiledMapParser.parseNode(value, map)
            end
        end
    end
end

function RNTiledMapParser.loadNodeProperties(targetMapItem, node)
    local propertiesFound = 0

    for key, value in ipairs(node.children.properties) do
        if type(value) == "table" then
            for key, value in ipairs(value.children.property) do
                if type(value) == "table" then
                    targetMapItem[value.attributes.name] = value.attributes.value
                    propertiesFound = propertiesFound + 1
                end
            end
        end
    end

    return propertiesFound
end

return RNTiledMapParser