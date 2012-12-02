-- Author: Marko Pukari
-- Date: 12/2/12

function createMockRNScreen()
	MockRNScreen = {
		newCalled = 0,
		initWithCalled = 0,
		addRNObjectCalled = 0,
		layers = MockRNLayer.new()
	}

	function MockRNScreen:new()
		self.newCalled = self.newCalled + 1 
		return self
	end

	function MockRNScreen:initWith(lwidth, lheight, screenlwidth, screenHeight)
		assert_that(lwidth,is(equal_to(MockConstants.SCREENWIDTH)))
		assert_that(lheight,is(equal_to(MockConstants.SCREENHEIGHT)))
 		assert_that(screenlwidth,is(equal_to(MockConstants.SCREENWIDTH)))
 		assert_that(screenHeight,is(equal_to(MockConstants.SCREENHEIGHT)))

		self.initWithCalled = self.initWithCalled + 1
	end

	function MockRNScreen:addRNObject(rnobject,mode,layer)
		assert_true(rnobject == RNObject)
		assert_nil(mode)
		self.addRNObjectCalled = self.addRNObjectCalled + 1
	end

	function MockRNScreen:reset()
		--MockRNScreen.newCalled = 0
		MockRNScreen.initWithCalled = 0
		self.addRNObjectCalled = 0
	end

	return MockRNScreen
end