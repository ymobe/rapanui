-- Author: Marko Pukari
-- Date: 11/30/12

MockViewportConstants = {
	WIDTH=1, 
	HEIGHT=2,
	SCREENWIDTH=3, 
	SCREENHEIGHT=4,
	OFFSET_X = -1,
	OFFSET_Y = 1
}

function createViewport(name)
	local MVC = MockViewportConstants

	local MockViewport = {
		setSizeCalled = false,
		setScaleCalled = false,
		setOffsetCalled = false
	}

	function MockViewport:setSize(screenWidth,screenHeight)
		assert_that(screenWidth,is(equal_to(MVC.SCREENWIDTH)))
		assert_that(screenHeight,is(equal_to(MVC.SCREENHEIGHT)))
		MockViewport.setSizeCalled=true
	end

	function MockViewport:setScale(width,height)
		assert_that(width,is(equal_to(MVC.WIDTH)))
		assert_that(height,is(equal_to(-MVC.HEIGHT)))
		MockViewport.setScaleCalled=true	
	end

	function MockViewport:setOffset(offset_x,offset_y)
		assert_that(offset_x,is(equal_to(MVC.OFFSET_X)))
		assert_that(offset_y,is(equal_to(MVC.OFFSET_Y)))
		MockViewport.setOffsetCalled=true	
	end

	function MockViewport:reset()
		MockViewport.setSizeCalled = false
		MockViewport.setScaleCalled = false
		MockViewport.setOffsetCalled = false
	end

	MockViewport.name=name

	return MockViewport
end