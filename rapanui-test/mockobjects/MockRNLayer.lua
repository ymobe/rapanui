function createMockRNLayer(expectGetBytName)
	
	MockRNLayer = {
		getCalled = 0,
		expectName = expectGetBytName,
		MAIN_LAYER = "mainlayer"
	}

	function MockRNLayer.new()
		return MockRNLayer
	end
	function MockRNLayer:get(name)
		assert_that(name,is(equal_to(self.expectName)))
		return createTestLayer("main",{},{})
	end

	return MockRNLayer
end

