-- Author: Marko Pukari
-- Date: 11/30/12

function createMockMOAIViewport(viewport)

	MockMOAIViewport = {
		newCalled = false,
		VIEWPORT = viewport,
		name="testViewport"
	}
	
	MockMOAIViewport.new = function()
		MockMOAIViewport.newCalled = true
		return MockMOAIViewport.VIEWPORT
	end

	function MockMOAIViewport:reset()
		self.newCalled = false
	end

	return MockMOAIViewport
end