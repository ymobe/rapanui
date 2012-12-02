-- Author: Marko Pukari
-- Date: 12/2/12

package.path = package.path .. ";../?.lua;lunatest/?.lua;mockobjects/?.lua;../rapanui-sdk/?.lua"
require('lunatest')
require('lunahamcrest')
require('MockRNScreen')
require('MockRNGroup')
require('MockMOAISim')
require('MockRNInputManager')
require('MockConstants')

lunatest.suite("RNFactory-hooks")


RNGroup = createMockRNGroup()
RNScreen = createMockRNScreen()
MOAISim = createMockMOAISim()
RNInputManager = createMockRNInputManager()

MOAIEnvironment = {
	screenWidth = MockConstants.SCREENWIDTH, 
	screenHeight = MockConstants.SCREENHEIGHT
}

config = {
	stretch = {}
}


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

lunatest.run()
