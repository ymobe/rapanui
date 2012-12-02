-- Author: Marko Pukari
-- Date: 12/2/12

function createMockRNInputManager()
	MockRNInputManager = {
		setGlobalRNScreenCalled = 0
	}

	function MockRNInputManager.setGlobalRNScreen(screen)
		assert_true(screen == RNScreen)
		MockRNInputManager.setGlobalRNScreenCalled = MockRNInputManager.setGlobalRNScreenCalled  + 1
		return self
	end

	function MockRNInputManager:reset()
		MockRNInputManager.setGlobalRNScreenCalled = 0
	end

	return MockRNInputManager
end