-- Author: Marko Pukari
-- Date: 11/30/12

function createMockMOAIPartition(partition)
	local MockMOAIPartition = {
		newCalled = false,
		PARTITION = partition
	}

	function MockMOAIPartition.new()
		MockMOAIPartition.newCalled = true
		return MockMOAIPartition.PARTITION
	end

	function MockMOAIPartition:reset()
		self.newCalled = false
	end

	return MockMOAIPartition
end

