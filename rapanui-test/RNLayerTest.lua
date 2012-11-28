-- Author: Marko Pukari
-- Date: 11/25/12

package.path = package.path .. ";../?.lua;lunatest/?.lua;../rapanui-sdk/?.lua"
require('lunatest')
require('lunahamcrest')
require('RNLayer')

--MOCK OBJECTS
calledFunctions = nil
VIEWPORT = "VIEWPORT"
TEST_PARTITION="TEST_PARTITION"
i = 0

local function createTestLayer(name)
	local layer = {}

	function layer:setViewport(viewport)
		calledFunctions.setViewport = true
		assert_that(viewport,is(equal_to(VIEWPORT)))
	end

	function layer:setPartition(partition)
		assert_that(partition,is(equal_to(TEST_PARTITION))) 
		calledFunctions.setPartition = true
	end

	function layer:clear()
		calledFunctions.clearLayer = true
	end

	layer.name = name
	return layer
end

TEST_LAYER=createTestLayer("TEST_LAYER")
TEST_LAYER2=createTestLayer("TEST_LAYER2")

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

MOAIPartition = {}
MOAIPartition.new = function()
	calledFunctions.newPartition = true
	return TEST_PARTITION
end

--TEST INITS
local function initTestParameters()
	i=0

	calledFunctions = {
		newLayer = false,
		setViewport = false,
		pushRenderPass = false,
		newPartition = false,
		setPartition = false,
		clearLayer = false
	}

end

local function init()
	initTestParameters()
	return RNLayer:new()
end

function testThatCreateShouldCreateNewLayer()
	local rnlayer = init()
	rnlayer:createLayer("test",VIEWPORT)
	assert_true(calledFunctions.newLayer,true)
	assert_that(table.getn(rnlayer),equal_to(1))
end

function testThatCreatingMultipleLayersIncreaseContainerSize()
	local rnlayer = init()
	rnlayer:createLayer("test",VIEWPORT)
	rnlayer:createLayer("test2",VIEWPORT)
	assert_that(table.getn(rnlayer),equal_to(2))
end

function testThatCreateShouldReturnTheNewLayer()
	local rnlayer = init()
	returnedLayer = rnlayer:createLayer("test",VIEWPORT)
	assert_that(returnedLayer.name,is(equal_to(TEST_LAYER.name)))
end

function testThatViewportIsAddedToTheCreatedLayer()
	local rnlayer = init()
	rnlayer:createLayer("test",VIEWPORT)
	assert_true(calledFunctions.setViewport)
end

function testThatCreatedLayerIsPushedToTheMOAISim()
	local rnlayer = init()
	rnlayer:createLayer("test",VIEWPORT)
	assert_true(calledFunctions.pushRenderPass)
end

function testThatCreatedLayerIsFoundByName()
	local rnlayer = init()
	returnedLayer = rnlayer:createLayer("test",VIEWPORT)
	assert_that(rnlayer:get("test").name,is(equal_to(TEST_LAYER.name)))
end

function testThatAllCreatedLayersAreFoundByName()
	local rnlayer = init()
	rnlayer:createLayer("test",VIEWPORT)
	rnlayer:createLayer("test2",VIEWPORT)
	assert_that(rnlayer:get("test").name,is(equal_to(TEST_LAYER.name)))
	assert_that(rnlayer:get("test2").name,is(equal_to(TEST_LAYER2.name)))
end

function testThatCannotCreateLayerWithSameName()
	local rnlayer = init()
	rnlayer:createLayer("test",VIEWPORT)
	rnlayer:createLayer("test",VIEWPORT)
	assert_that(table.getn(rnlayer),equal_to(1))
end

function testThatCreateLayerWithSameNameReturnsNilAndErrorMessage()
	local rnlayer = init()
	rnlayer:createLayer("test",VIEWPORT)
	returnedlayer,msg = rnlayer:createLayer("test",VIEWPORT)
	assert_nil(returnedlayer)
	assert_that(msg,is(equal_to(rnlayer.LAYER_WITH_SAME_NAME_EXISTS)))
end

lunatest.run()