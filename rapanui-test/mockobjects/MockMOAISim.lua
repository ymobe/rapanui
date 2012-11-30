-- Author: Marko Pukari
-- Date: 11/30/12

function createMockMOAISim()

 	local MockMOAISim = {
 		pushRenderPassCalled = false,
 	}

	MockMOAISim.pushRenderPass = function(layer)
		assert_not_nil(layer)
		MOAISim.pushRenderPassCalled = true
	end
	
	function MockMOAISim:reset()
		self.pushRenderPassCalled = false;
	end

	return MockMOAISim
end