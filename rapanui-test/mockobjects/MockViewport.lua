-- Author: Marko Pukari
-- Date: 11/30/12

require('MockConstants')
function createViewport(name)
	local MockViewport = {
		setSizeCalled = 0,
		setScaleCalled = 0,
		setOffsetCalled = 0
	}

	function MockViewport:setSize(screenWidth,screenHeight)
		assert_that(screenWidth,is(equal_to(MockConstants.SCREENWIDTH)))
		assert_that(screenHeight,is(equal_to(MockConstants.SCREENHEIGHT)))
		MockViewport.setSizeCalled = MockViewport.setSizeCalled + 1
	end

	function MockViewport:setScale(width,height)
		assert_that(width,is(equal_to(MockConstants.WIDTH)))
		assert_that(height,is(equal_to(-MockConstants.HEIGHT)))
		MockViewport.setScaleCalled = MockViewport.setScaleCalled + 1
	end

	function MockViewport:setOffset(offset_x,offset_y)
		assert_that(offset_x,is(equal_to(MockConstants.OFFSET_X)))
		assert_that(offset_y,is(equal_to(MockConstants.OFFSET_Y)))
		MockViewport.setOffsetCalled = MockViewport.setOffsetCalled + 1	
	end

	function MockViewport:reset()
		MockViewport.setSizeCalled = 0
		MockViewport.setScaleCalled = 0
		MockViewport.setOffsetCalled = 0
	end

	MockViewport.name=name

	return MockViewport
end