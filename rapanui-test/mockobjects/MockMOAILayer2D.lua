-- Author: Marko Pukari
-- Date: 11/30/12

function createMockMOAILayer2D(...)

 	local MockMOAILayer2D = {
 		newCalled = 0,
 		i=0,
 		layers = arg
 	}
	
	MockMOAILayer2D.new = function()
		MockMOAILayer2D.newCalled = MockMOAILayer2D.newCalled + 1
		MockMOAILayer2D.i = MockMOAILayer2D.i + 1
		return MockMOAILayer2D.layers[MockMOAILayer2D.i]
	end

	function MockMOAILayer2D:reset()
		self.newCalled = 0;
		self.i=0
	end

	return MockMOAILayer2D
end