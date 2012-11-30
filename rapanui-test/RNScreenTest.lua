-- Author: Marko Pukari
-- Date: 11/25/12

package.path = package.path .. ";../?.lua;lunatest/?.lua;mockobjects/?.lua;../rapanui-sdk/?.lua"
require('lunatest')
require('lunahamcrest')
require('RNScreen')
require('RNLayer')
require('MockPartition')
require('MockViewport')
require('MockLayer')
require('MockRNObject')
require('MockMOAILayer2D')
require('MockMOAISim')
require('MockMOAIViewport')
require('MockMOAIPartition')


RNLayer:new()

local MVC = MockViewportConstants
PROP = {}

VIEWPORT = createViewport("viewport")
TEST_PARTITION=createPartition("TEST_PARTITION")
TEST_LAYER=createTestLayer("TEST_LAYER",VIEWPORT,TEST_PARTITION)
TEST_LAYER2=createTestLayer("TEST_LAYER2",VIEWPORT,TEST_PARTITION)
RNOBJECT = createRNObject("RNOBJECT",PROP)

MOAILayer2D = createMockMOAILayer2D(TEST_LAYER,TEST_LAYER2)
MOAISim = createMockMOAISim()
MOAIViewport = createMockMOAIViewport(VIEWPORT)
MOAIPartition = createMockMOAIPartition(TEST_PARTITION)

local function init()
	MOAILayer2D:reset()
	MOAISim:reset()
	MOAIViewport:reset()
	MOAIPartition:reset()
	return RNScreen:new()
end

--TESTS

--RNScreen:initWith
function testThatScreenSizeIsSetCorrectly()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(rnscreen.width,is(equal_to(MVC.WIDTH)))	
	assert_that(rnscreen.height,is(equal_to(MVC.HEIGHT)))	
end

function testThatViewportIsCreated()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_true(MOAIViewport.newCalled,true)
end

function testThatViewportSizeIsSet()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_true(VIEWPORT.setSizeCalled,true)
end

function testThatViewportScaleIsSet()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_true(VIEWPORT.setScaleCalled,true)
end

function testThatViewportOffsetIsSet()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_true(VIEWPORT.setOffsetCalled,true)
end

function testThatLayerIsCreated() 
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_true(MOAILayer2D.newCalled,true)	
end

function testThatViewportIsSetToLayer() 
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_true(TEST_LAYER.setViewportCalled,true)	
end

function testThatNewPartitionIsCreated()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_true(MOAIPartition.newCalled,true)
end

function testThatNewPartitionIsSetToScreenMainPartitiob()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_that(rnscreen.mainPartition.name,is(equal_to(TEST_PARTITION.name)))
end

function testThatPartitionIsSetToLayer()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_true(TEST_LAYER.setPartitionCalled,true)
end

function testThatLayerIsPushedToMoaiSim()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_true(MOAISim.pushRenderPassCalled,true)
end

function testThatLayersAreStoredToScreen()
	local rnscreen = init()
	assert_nil(rnscreen.layers)	
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_not_nil(rnscreen.layers)	
end

function testThatMainPartitionIsFoundFromLayers()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	assert_not_nil(rnscreen.layers:get(RNLayer.MAIN_LAYER))		
end

--RNScreen:addRNObject
function testThatObjectLocationModeIsSet()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	rnscreen:addRNObject(RNOBJECT)
	assert_true(RNOBJECT.setLocatingModeCalled)
end

function testThatTheObjectIsAddedToMainPartition()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	rnscreen:addRNObject(RNOBJECT)
	assert_true(TEST_PARTITION.insertPropCalled)
end

function testThatTheObjectParentSceneIsSet()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	rnscreen:addRNObject(RNOBJECT)
	assert_true(RNOBJECT.setParentSceneCalled)
end

function testThatObjectUpdateLocationIsCalled()
	local rnscreen = init()
	rnscreen:initWith(MVC.WIDTH, MVC.HEIGHT, MVC.SCREENWIDTH, MVC.SCREENHEIGHT)
	rnscreen:addRNObject(RNOBJECT)
	assert_true(RNOBJECT.updateLocationCalled)
end

lunatest.run()