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


RNMapFactory = {}

RNMapFactory.TILED = "tiled"
RNMapFactory.TILEDLUA = "tiledlua"
MAP_DRAW_MODE_FULLIMAGE = "FullImage"
MAP_DRAW_MODE_BIGTILED = "BigTiled"
MAP_DRAW_MODE_TESSELLATED = "Tessellated"


function RNMapFactory.loadMap(type, filename, drawmode)

    print("before", type)

    local map = RNMap:new()

    if type == RNMapFactory.TILED then
        print("callit")
        RNTiledMapParser.load(map, filename)
    end

    if type == RNMapFactory.TILEDLUA then
        RNTiledLuaMapParser.load(map, filename)
    end

    print_r(map)

    map:init(RNFactory.getCurrentScreen())

    return map
end

return RNMapFactory



