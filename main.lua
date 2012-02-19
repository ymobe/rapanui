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
--]]

---[[ Uncomment to override the default print() function
function print(...)
    local toPrint = ""
    for i = 1, #arg do
        if arg[i] == nil then arg[i] = "not defined" end --difference between "nil" and nil.
        toPrint = toPrint .. tostring(arg[i]) .. "\t"
    end
    return io.stdout:write(string.format(toPrint .. "\n"))
end      --]]

require("RNUtil")
require("RNThread")
require("RNGroup")
require("RNFactory")
require("RNListeners")
require("RNTransition")
require("RNMainThread")
require("RNDirector")
require ("RNPhysics")


require("lua/main")
-- RapaNui demos:

-- Anim

--require("rapanui-samples/anim/rn-anim")
--require("rapanui-samples/anim/rn-anim2")

-- Basics

--require("rapanui-samples/basic/rn-images")
--require("rapanui-samples/basic/rn-images-rotate")
--require("rapanui-samples/basic/rn-levels")
--require("rapanui-samples/basic/rn-text")
--require("rapanui-samples/basic/rn-shapes")

-- Groups

--require("rapanui-samples/groups/rn-groups")
--require("rapanui-samples/groups/rn-map-group")

-- Director

--require("rapanui-samples/director/rn-director-basic")
--require("rapanui-samples/director/rn-director-touch")
--require("rapanui-samples/director/rn-director-touch-listener")
--require("rapanui-samples/director/rn-director-loop")

-- Timer

--require("rapanui-samples/timer/rn-timer")
--require("rapanui-samples/timer/rn-timer-stop")
--require("rapanui-samples/timer/rn-timer-remove")


-- Transition

--require("rapanui-samples/transition/rn-transition-alpha")
--require("rapanui-samples/transition/rn-transition-combined")
--require("rapanui-samples/transition/rn-transition-move")
--require("rapanui-samples/transition/rn-transition-rotate")
--require("rapanui-samples/transition/rn-transition-scale")

--NOTE: now only works on simple 2D maps, still buggy with physics maps
--require("rapanui-samples/transition/rn-transition-map-alpha")
--require("rapanui-samples/transition/rn-transition-map-rotate")
--require("rapanui-samples/transition/rn-transition-map-scale")
--require("rapanui-samples/transition/rn-transition-map-move")

-- Touch

--require("rapanui-samples/touch/rn-touch-buttons")
--require("rapanui-samples/touch/rn-touch")
--NOTE: anim prop it's upsidedown to receive touch due to a MOAI bug already fixed in moai dev branch
--require("rapanui-samples/touch/rn-buttons-animated")

-- listeners

--require("rapanui-samples/listeners/rn-listener-touch-remove")
--require("rapanui-samples/listeners/rn-listener-enterFrame-remove")

-- RapaNui Physics demos:

--require("rapanui-samples/physics/rn-physics-shapes")
--require("rapanui-samples/physics/rn-physics-types")
--require("rapanui-samples/physics/rn-physics-fixtures")
--require("rapanui-samples/physics/rn-physics-forces")
--require("rapanui-samples/physics/rn-physics-complex")
--require("rapanui-samples/physics/rn-physics-filters")
--require("rapanui-samples/physics/rn-physics-joints")
--require("rapanui-samples/physics/rn-physics-collisionhandling")
--require("rapanui-samples/physics/rn-physics-touchtest")
--require("rapanui-samples/physics/rn-physics-animation")
--require("rapanui-samples/physics/rn-physics-setup")
--require("rapanui-samples/physics/rn-physics-lists")
--require("rapanui-samples/physics/rn-physics-physicsEditor")
--require("rapanui-samples/physics/test")


-- RapaNui sample games:

--require("rapanui-samples/games/brick2d/brick2d")
--require("rapanui-samples/games/SunGolf/SunGolf")
--require("rapanui-samples/games/AngryDogsAgainstMoais/AngryDogsAgainstMoais")

-- Maps

--require("rapanui-samples/maps/rn-basic-map")
--require("rapanui-samples/maps/rn-basic-map-alpha")
--require("rapanui-samples/maps/rn-scrolling-map")
--require("rapanui-samples/maps/rn-tileset")
--require("rapanui-samples/maps/rn-physics-map")
--require("rapanui-samples/maps/rn-physics-map-alpha")
--require("rapanui-samples/maps/rn-scrolling-physics-map")

-- These two tests have only text output
--require("rapanui-samples/maps/rn-tiledmap-parser-xml")
--require("rapanui-samples/maps/rn-tiledmap-parser-lua")

-- Mem Tests
--require("rapanui-samples/test/maptest")