freeImage = RNFactory.createImage("images/background-blue.png")



groupY = 100


group = RNGroup:new()

text = RNFactory.createText("Touch on buttons", { size = 9, top = 400, left = 5, width = 250, height = 50 })

nextText = "Click to move Down"

button = RNFactory.createButton("images/button-plain.png", { text = nextText, imageOver = "images/button-over.png", top = 20, left = 10, size = 8, width = 200, height = 50 })
--button.x = 10


button2 = RNFactory.createButton("images/button-plain.png", { text = "Button 2", imageOver = "images/button-over.png", top = 90, left = 10, size = 8, width = 200, height = 50 })
--button2.x = 10
--button2.y = 96


group:insert(button)
group:insert(button2)


print("group one size: " .. group:getSize())


function button1TouchDown(event)
    text:setText("Button 1 touch down!")
    group.y = group.y + groupY
    groupY = -groupY
    if nextText == "Click to move Down" then
        nextText = "Click to move Up"
    elseif nextText == "Click to move Up" then
        nextText = "Click to move Down"
    end
    button:setText(nextText)
end

function button1UP(event)

    text:setText("Button 1 touch Up!")
end


button:setOnTouchDown(button1TouchDown)
button:setOnTouchUp(button1UP)
