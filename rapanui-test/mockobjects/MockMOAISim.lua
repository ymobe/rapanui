-- Author: Marko Pukari
-- Date: 11/30/12

function createMockMOAISim()

 	local MockMOAISim = {
 		pushRenderPassCalled = 0,
 	}

	MockMOAISim.pushRenderPass = function(layer)
		assert_not_nil(layer)
		MOAISim.pushRenderPassCalled = MOAISim.pushRenderPassCalled + 1
	end
	
	function MockMOAISim:reset()
		self.pushRenderPassCalled = 0;
	end

	return MockMOAISim
end