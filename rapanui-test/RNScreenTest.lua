-- Author: Marko Pukari
-- Date: 11/25/12

package.path = package.path .. ";../?.lua;lunatest/?.lua;../rapanui-sdk/?.lua"
require('lunatest')
require('lunahamcrest')
require('RNScreen')
require('RNLayer')

RNLayer:new()
--MOCK OBJECTS
calledFunctions = nil
i = 0
WIDTH=1 
HEIGHT=2
SCREENWIDTH=3 
SCREENHEIGHT=4
OFFSET_X = -1
OFFSET_Y = 1
PROP = {}

function createPartition(name)
	local partition = {}

	function partition:insertProp(property)
		calledFunctions.insertPropToMainPartition = true
	end

	partition.name = name

	return partition
end

function createViewport(name)

	local viewport = {}

	function viewport:setSize(screenWidth,screenHeight)
		assert_that(screenWidth,is(equal_to(SCREENWIDTH)))
		assert_that(screenHeight,is(equal_to(SCREENHEIGHT)))
		calledFunctions.viewportSetSize=true
	end

	function viewport:setScale(width,height)
		assert_that(width,is(equal_to(WIDTH)))
		assert_that(height,is(equal_to(-HEIGHT)))
		calledFunctions.viewportSetScale=true	
	end

	function viewport:setOffset(offset_x,offset_y)
		assert_that(offset_x,is(equal_to(OFFSET_X)))
		assert_that(offset_y,is(equal_to(OFFSET_Y)))
		calledFunctions.viewportSetOffset=true	
	end

	viewport.name=name

	return viewport
end

VIEWPORT = createViewport("viewport")

local function createTestLayer(name)
	local layer = {}

	function layer:setViewport(viewport)
		calledFunctions.setViewport = true
		assert_that(viewport.name,is(equal_to(VIEWPORT.name)))
	end

	function layer:setPartition(partition)
		assert_that(partition.name,is(equal_to(TEST_PARTITION.name))) 
		calledFunctions.setPartition = true
	end

	layer.name = name
	return layer
end

function createRNObject()
	local obj = {}
	
	function obj:getProp()
		return PROP
	end

	function obj:setLocatingMode(mode)
		calledFunctions.setLocatingMode = true
	end

	function obj:setParentScene(object)
		calledFunctions.setParentScene = true
	end

	function obj:updateLocation()
		calledFunctions.updateLocation=true
	end

	return obj
end

RNOBJECT = createRNObject()

TEST_LAYER=createTestLayer("TEST_LAYER")
TEST_LAYER2=createTestLayer("TEST_LAYER2")
TEST_PARTITION=createPartition("TEST_PARTITION")


layers={TEST_LAYER,TEST_LAYER2}

MOAILayer2D = { }	
MOAILayer2D.new = function()
	calledFunctions.newLayer=true
	i = i + 1
	return layers[i]
end

MOAISim = { }	
MOAISim.pushRenderPass = function(layer)
	assert_not_nil(layer)
	calledFunctions.pushRenderPass=true
end

MOAIViewport = {}
MOAIViewport.new = function()
	calledFunctions.newViewport = true
	return VIEWPORT
end

MOAIViewport.name = "testVP"

MOAIPartition = {}
MOAIPartition.new = function()
	calledFunctions.newPartition = true
	return TEST_PARTITION
end

--TEST INITS
local function initTestParameters()
	i=0

	calledFunctions = {
		newViewport = false,
		newLayer = false,
		viewportSetSize = false,
		viewportSetScale = false,
		viewportSetOffset = false,
		setViewport = false,
		pushRenderPass = false,
		newPartition = false,
		setPartition = false,
		setLocatingMode = false,
		setParentScene = false,
		updateLocation=false,
	}

end

local function init()
	initTestParameters()
	return RNScreen:new()
end

--TESTS

--RNScreen:initWith
function testThatScreenSizeIsSetCorrectly()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_that(rnscreen.width,is(equal_to(WIDTH)))	
	assert_that(rnscreen.height,is(equal_to(HEIGHT)))	
end

function testThatViewportIsCreated()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_true(calledFunctions.newViewport,true)
end

function testThatViewportSizeIsSet()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_true(calledFunctions.viewportSetSize,true)
end

function testThatViewportScaleIsSet()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_true(calledFunctions.viewportSetScale,true)
end

function testThatViewportOffsetIsSet()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_true(calledFunctions.viewportSetOffset,true)
end

function testThatLayerIsCreated() 
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_true(calledFunctions.newLayer,true)	
end

function testThatViewportIsSetToLayer() 
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_true(calledFunctions.setViewport,true)	
end

function testThatNewPartitionIsCreated()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_true(calledFunctions.newPartition,true)
end

function testThatNewPartitionIsSetToScreenMainPartitiob()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_that(rnscreen.mainPartition.name,is(equal_to(TEST_PARTITION.name)))
end

function testThatPartitionIsSetToLayer()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_true(calledFunctions.setPartition,true)
end

function testThatLayerIsPushedToMoaiSim()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_true(calledFunctions.pushRenderPass,true)
end

function testThatLayersAreStoredToScreen()
	local rnscreen = init()
	assert_nil(rnscreen.layers)	
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_not_nil(rnscreen.layers)	
end

function testThatMainPartitionIsFoundFromLayers()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	assert_not_nil(rnscreen.layers:get(RNLayer.MAIN_LAYER))		
end

--RNScreen:addRNObject
function testThatObjectLocationModeIsSet()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	rnscreen:addRNObject(RNOBJECT)
	assert_true(calledFunctions.setLocatingMode)
end

function testThatTheObjectIsAddedToMainPartition()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	rnscreen:addRNObject(RNOBJECT)
	assert_true(calledFunctions.insertPropToMainPartition)
end

function testThatTheObjectParentSceneIsSet()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	rnscreen:addRNObject(RNOBJECT)
	assert_true(calledFunctions.setParentScene)
end

function testThatObjectUpdateLocationIsCalled()
	local rnscreen = init()
	rnscreen:initWith(WIDTH, HEIGHT, SCREENWIDTH, SCREENHEIGHT)
	rnscreen:addRNObject(RNOBJECT)
	assert_true(calledFunctions.updateLocation)
end

lunatest.run()