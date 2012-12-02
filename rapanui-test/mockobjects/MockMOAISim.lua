-- Author: Marko Pukari
-- Date: 11/30/12

function createMockMOAISim()

 	local MockMOAISim = {
 		pushRenderPassCalled = 0,
 		openWindowCalled = 0
 	}

	MockMOAISim.pushRenderPass = function(layer)
		assert_not_nil(layer)
		MockMOAISim.pushRenderPassCalled = MOAISim.pushRenderPassCalled + 1
	end
	
	function MockMOAISim.openWindow(name, screenlwidth, screenHeight)
		assert_that(screenlwidth,is(equal_to(MockConstants.SCREENWIDTH)))
		assert_that(screenHeight,is(equal_to(MockConstants.SCREENHEIGHT)))
		assert_that(name,is(equal_to(MockConstants.WINDOWNAME)))
		MockMOAISim.openWindowCalled = MockMOAISim.openWindowCalled + 1
	end

	function MockMOAISim:reset()
		self.pushRenderPassCalled = 0
		self.openWindowCalled = 0 
	end

	return MockMOAISim
end