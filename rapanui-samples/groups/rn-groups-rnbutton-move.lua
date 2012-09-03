freeImage = RNFactory.createImage("images/background-blue.png")

freeImage = RNFactory.createImage("images/image.png")

group = RNGroup:new()

button = RNFactory.createButton("images/button-plain.png", { text = "Button 1", imageOver = "images/button-over.png", top = 250, left = 10, size = 16, width = 200, height = 50 })
--button.x = 10
button.y = 90

button2 = RNFactory.createButton("images/button-plain.png", { text = "Button 2", imageOver = "images/button-over.png", top = 150, left = 10, size = 16, width = 200, height = 50 })
--button2.x = 10
--button2.y = 96


group:insert(button)
group:insert(button2)


print("group one size: " .. group:getSize())



local myListener = function(event)
    group.x = event.x
    group.y = event.y

--    print("group x: " .. group.x .. " y: " .. group.y)

--    print("anImageTest1 x: " .. anImageTest1.x .. " y: " .. anImageTest1.y)
--    print("anImageTest2 x: " .. anImageTest2.x .. " y: " .. anImageTest2.y)
--    print("anImageTest3 x: " .. anImageTest3.x .. " y: " .. anImageTest3.y)
--    print("anImageTest4 x: " .. anImageTest4.x .. " y: " .. anImageTest4.y)
end

RNListeners:addEventListener("touch", myListener)
