-- Author: Marko Pukari
-- Date: 12/2/12

package.path = package.path .. ";../?.lua;lunatest/?.lua;mockobjects/?.lua;../rapanui-sdk/?.lua"
require('lunatest')
require('lunahamcrest')
require('MockRNLayer')
require('MockRNScreen')
require('MockRNGroup')
require('MockMOAISim')
require('MockRNInputManager')
require('MockConstants')
require('MockRNObject')
require('MockLayer')

lunatest.suite("RNFactory-hooks")


RNLayer = createMockRNLayer(MockConstants.MAIN_LAYER)
RNGroup = createMockRNGroup()
RNScreen = createMockRNScreen()
MOAISim = createMockMOAISim()
RNInputManager = createMockRNInputManager()
RNObject = createRNObject()

MOAIEnvironment = {
    screenWidth = MockConstants.SCREENWIDTH, 
    screenHeight = MockConstants.SCREENHEIGHT
}

config = {
    stretch = {}
}
function init()
    RNObject:reset()
end

--RNFactory default creation
function testRNScreenIsCreatedWhenRNFactoryIsCreated()
    assert_that(RNScreen.newCalled,is(greater_than(0)))
end

function testThatRNGroupIsCreateWhenRNFactoryIsCreated()
    assert_that(RNGroup.newCalled,is(greater_than(0)))
end

function testThatCreateRNFactoryOpensNewMOAISimWindow()
    assert_that(MOAISim.openWindowCalled,is(greater_than(0)))
end

function testThatRNScreenInitWithIsCalled()
    assert_that(RNScreen.initWithCalled,is(greater_than(0)))
    local params = RNScreen.initWithParams
end

function testThatSetGlobalRNScreenIsCalled()
    assert_that(MockRNInputManager.setGlobalRNScreenCalled,is(greater_than(0)))
end

--RNFactory:createImage()

function testThatCreateImageCreatesNewObject()
    init()
    RNFactory.createImage("img")
    assert_that(RNObject.newCalled,is(greater_than(0)))
end

function testThatCreateImageInitsTheCreatedObject()
    init()
    RNFactory.createImage("img")
    assert_that(RNObject.initWithImage2Called,is(greater_than(0)))
end

function testThatCreateImageAddsObjectToTheScreen()
    init()
    RNFactory.createImage("img")
    assert_that(RNScreen.addRNObjectCalled,is(greater_than(0)))
end

function testThatCreateImageAddsObjectToTheMainGroup()
    init()
    RNFactory.createImage("img")
    assert_that(RNGroup.insertCalled,is(greater_than(0)))
end

function testThatCreateImageReturnsProperDeckAndRNObject()
    init()
    local rnobject,deck = RNFactory.createImage("img")
    assert_not_nil(rnobject)
    assert_not_nil(deck)
    assert_true(rnobject == RNObject)
end

function testThatCreateImageFromReturnsProperDeckAndRNObject()
    init()
    local rnobject,deck = RNFactory.createImageFrom("img")
    assert_not_nil(rnobject)
    assert_not_nil(deck)
    assert_true(rnobject == RNObject)
end

lunatest.run()
