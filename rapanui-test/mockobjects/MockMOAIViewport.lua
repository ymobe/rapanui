-- Author: Marko Pukari
-- Date: 11/30/12

function createMockMOAIViewport(viewport)

	MockMOAIViewport = {
		newCalled = 0,
		VIEWPORT = viewport,
		name="testViewport"
	}
	
	MockMOAIViewport.new = function()
		MockMOAIViewport.newCalled = MockMOAIViewport.newCalled + 1
		return MockMOAIViewport.VIEWPORT
	end

	function MockMOAIViewport:reset()
		self.newCalled = 0
	end

	return MockMOAIViewport
end