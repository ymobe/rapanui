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
module(..., package.seeall)

require("RNTiledMapParser")
require("RNTiledLuaMapParser")

TILED = "tiled"
TILEDLUA = "tiledlua"

function loadMap(type, filename)

    local map = RNMap:new()
    if type == TILED then
        RNTiledMapParser.load(map, filename)
        return map
    end

     if type == TILEDLUA then
        RNTiledLuaMapParser.load(map, filename)
        return map
    end

    return map
end



