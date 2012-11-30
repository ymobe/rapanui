-- Author: Marko Pukari
-- Date: 11/30/12

function createMockMOAILayer2D(...)

 	local MockMOAILayer2D = {
 		newCalled = false,
 		i=0,
 		layers = arg
 	}
	
	MockMOAILayer2D.new = function()
		MockMOAILayer2D.newCalled=true
		MockMOAILayer2D.i = MockMOAILayer2D.i + 1
		return MockMOAILayer2D.layers[MockMOAILayer2D.i]
	end

	function MockMOAILayer2D:reset()
		self.newCalled = false;
		self.i=0
	end

	return MockMOAILayer2D
end