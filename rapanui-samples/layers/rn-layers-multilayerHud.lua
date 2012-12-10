--[[
-------------------------------------------------------------------------
-- Date: 12/05/2012
-- @Author: Marko Pukari
-- Multilayer is used to create HUD layer which stays stationary.
-- all objects added to he HUD layer will move with the camera movement
--
--------------------------------------------------------------------------
--]]

-- variables to make our work easier
local screen = RNFactory.screen
local viewport = screen.viewport
local layers = screen.layers
local mainlayer = layers:get(RNFactory.MAIN_LAYER)

-- create camera and place it to the main layer
local camera = MOAICamera2D.new()

layers:get(RNLayer.MAIN_LAYER):setCamera(camera)

--create new layer for hud
local hudlayer = layers:createLayerWithPartition(RNLayer.HUD_LAYER, viewport)

--create backgroud
--if you don't give the layer to the create, the image will be added to the mainlayer
local background = RNFactory.createImageFrom("images/background-landscape-hd.png", mainlayer)
local gamegroup = RNGroup:new()

--create new image to the game/mainlayer
local gameobject = RNFactory.createImageFrom("images/tile0.png", mainlayer)
gameobject.x = 100
gameobject.y = 100

--create new image to the hudlayer
local hudobject = RNFactory.createImageFrom("images/tile1.png", hudlayer)
hudobject.x = 200
hudobject.y = 300

--move camera. Hud image stays on the same place while the camera moves acros the 
--background. Images on game/mainlayer stays where they where placed
camera:seekLoc(100, 100, 5)
