-- Author: Marko Pukari
-- Date: 11/25/12

package.path = package.path .. ";../?.lua;lunatest/?.lua;mockobjects/?.lua;../rapanui-sdk/?.lua"
require('lunatest')
require('lunahamcrest')
require('RNLayer')
require('MockPartition')
require('MockViewport')
require('MockLayer')
require('MockMOAILayer2D')
require('MockMOAISim')
require('MockMOAIPartition')

--MOCK OBJECTS
VIEWPORT = createViewport("viewport")
TEST_PARTITION = createPartition("TEST_PARTITION")
TEST_LAYER = createTestLayer("TEST_LAYER",VIEWPORT,TEST_PARTITION)
TEST_LAYER2 = createTestLayer("TEST_LAYER2",VIEWPORT,TEST_PARTITION)

--Mocked MOIA classes
MOAILayer2D = createMockMOAILayer2D(TEST_LAYER,TEST_LAYER2)
MOAISim = createMockMOAISim()
MOAIPartition = createMockMOAIPartition(TEST_PARTITION)

local function init()
    MOAILayer2D:reset()
    MOAISim:reset()
    MOAIPartition:reset()
    return RNLayer:new()
end

function testThatCreateShouldCreateNewLayer()
    local rnlayer = init()
    rnlayer:createLayer("test",VIEWPORT)
    assert_that(MOAILayer2D.newCalled,is(greater_than(0)))
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
    assert_that(TEST_LAYER.setViewportCalled,is(greater_than(0)))
end

function testThatCreatedLayerIsPushedToTheMOAISim()
    local rnlayer = init()
    rnlayer:createLayer("test",VIEWPORT)
    assert_that(MOAISim.pushRenderPassCalled,is(greater_than(0)))
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

function testThatLayerCanBeCreatedWithPartition() 
    local rnlayer = init()
    returnnedLayer,returnnedPartition = rnlayer:createLayerWithPartition("test",VIEWPORT)
    assert_that(MOAILayer2D.newCalled,is(greater_than(0)))
    assert_that(MOAISim.pushRenderPassCalled,is(greater_than(0)))
    assert_that(MOAIPartition.newCalled,is(greater_than(0)))
    assert_that(TEST_LAYER.setPartitionCalled ,is(greater_than(0)))
    assert_that(returnedLayer.name,is(equal_to(TEST_LAYER.name)))
    assert_that(returnnedPartition.name,is(equal_to(TEST_PARTITION.name)))
end

function testThatLayerCanBeRemoved() 
    local rnlayer = init()
    returnedLayer = rnlayer:createLayer("test",VIEWPORT)
    returnedLayer2 = rnlayer:createLayer("test2",VIEWPORT)
    assert_that(table.getn(rnlayer),equal_to(2))

    rnlayer:remove(returnedLayer2)
    assert_that(table.getn(rnlayer),equal_to(1))
    assert_nil(rnlayer:get("test2"))
    assert_not_nil(rnlayer:get("test")) 
end

function testThatLayerContainerIsProperlyCleared() 
    local rnlayer = init()
    returnedLayer = rnlayer:createLayer("test",VIEWPORT)
    container = rnlayer[1]

    assert_not_nil(container.name)
    assert_not_nil(container.layer)

    rnlayer:remove(returnedLayer)

    assert_nil(container.name)
    assert_nil(container.layer)
end

function testThatLayerIsClearedWhenLayerIsRemoved()
    local rnlayer = init()
    returnedLayer = rnlayer:createLayer("test",VIEWPORT)
    rnlayer:remove(returnedLayer)
    assert_that(TEST_LAYER.clearCalled,is(greater_than(0)))
end

function testThatAllLayersAreDeletedAtOnce()
    local rnlayer = init()
    rnlayer:createLayer("test",VIEWPORT)
    rnlayer:createLayer("test2",VIEWPORT)
    assert_that(table.getn(rnlayer),equal_to(2))

    rnlayer:removeAll()
    assert_that(table.getn(rnlayer),equal_to(0))

end

lunatest.run()