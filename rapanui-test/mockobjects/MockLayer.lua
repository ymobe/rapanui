-- Author: Marko Pukari
-- Date: 11/30/12

function createTestLayer(name,viewport,partition)
	local MockLayer = {
		setPartitionCalled = false,
		setViewportCalled = false,
		clearCalled = false,
		VIEWPORT = viewport,
		PARTITION = partition

	}

	function MockLayer:setViewport(viewport)
		MockLayer.setViewportCalled = true
		assert_that(viewport.name,is(equal_to(VIEWPORT.name)))
	end

	function MockLayer:setPartition(partition)
		assert_that(partition.name,is(equal_to(MockLayer.PARTITION.name))) 
		MockLayer.setPartitionCalled = true
	end

	function MockLayer:clear()
		MockLayer.clearCalled=true
	end

	function MockLayer:reset()
		self.setPartitionCalled = false
		self.setViewportCalled = false
		self.clearCalled = false		
	end

	MockLayer.name = name
	return MockLayer
end
