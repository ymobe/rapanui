module(..., package.seeall)


-- Create a New Scene Object


function RNInputManager:new(o)

    o = o or {
        name = "RNInputManager",
        listeners = {},
        size = 0;
    }

    setmetatable(o, self)
    self.__index = self

    return o
end

innerInputManager = RNInputManager:new()


function init()
    MOAIInputMgr.device.touch:setCallback(onEvent)
end

function addListener(listener)
    innerInputManager:addListenerToList(listener)
end

function RNInputManager:addListenerToList(listener)
    print("Adding listener" .. listener:getImageName() .. " @" .. self.size)
    --print_r(listener)
    self.listeners[self.size] = listener
    self.size = self.size + 1
end

function RNInputManager:getListeners()
    return self.listeners
end

function onEvent(eventType, idx, x, y, tapCount)
    print("HERE!!!")
    for key, value in pairs(innerInputManager:getListeners())
    do
    --  print("key: ==================================")
    --  print_r(key)
    --   print("value: ==================================")
    --  print_r(value)
        value:onTouch(x, y)
    end
end


-- return first piece in the given coloumn
function getListenerSlotFree()

    local size = 0;
    for key, value in pairs(innerInputManager:getListeners())
    do
        if key ~= nil then
            size = size + 1
        end
    end
    return 0
end

RNInputManager.init()


--inputManager:init()
