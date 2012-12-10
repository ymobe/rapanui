--[[
--
-- RapaNui
--
-- by Ymobe ltd  (http://ymobe.co.uk)
--
-- LICENSE:
--
-- RapaNui uses the Common Public Attribution License Version 1.0 (CPAL) http://www.opensource.org/licenses/cpal_1.0.
-- CPAL is an Open Source Initiative approved
-- license based on the Mozilla Public License, with the added requirement that you attribute
-- Moai (http://getmoai.com/) and RapaNui in the credits of your program.
]]

--Touch/Collision Handling sample

boxTouched = false
--add images
background = RNFactory.createImage("rapanui-samples/physics/background-purple.png")
box = RNFactory.createImage("rapanui-samples/physics/box.png"); box.x = 170; box.y = 80;
ball = RNFactory.createImage("rapanui-samples/physics/ball.png"); ball.x = 240; ball.y = 80;
triangle = RNFactory.createImage("rapanui-samples/physics/poly.png"); triangle.x = 80; triangle.y = 80; triangle.rotation = 190
floor = RNFactory.createImage("rapanui-samples/physics/floor.png"); floor.x = 160; floor.y = 400;

--starts simulation
RNPhysics.start()


--set images as physics objects
RNPhysics.createBodyFromImage(box)
RNPhysics.createBodyFromImage(ball, { shape = "circle" })
RNPhysics.createBodyFromImage(triangle, { shape = { -32, 32, 0, -32, 32, 32 }, restitution = 0.3, friction = 0.1 })
RNPhysics.createBodyFromImage(floor, "static")
box.restitution = 0.5
ball.restitution = 0.3
triangle.restitution = 0.3


function screen_touch(event)
    --if you touch the box,you move it
    --(this is not really a precise touching function)
    --(the real one  should be done with object:addEventListener("touch")
    --so we receive callback only if the specified object is touched.
    --if the box is touched we apply a force toward the touch to it.
    local xx = event.x
    local yy = event.y
    local xx2 = box.x
    local yy2 = box.y
    local fx = xx - xx2
    local fy = yy - yy2
    --receiveing from touch:
    if event.phase == "began" then
        print(event.phase .. " touch event at " .. event.x .. "  " .. event.y)
        --if we are close to the box we set it to move
        if (math.abs(yy - yy2) < 32) and (math.abs(xx - xx2) < 32) then
            boxTouched = true
            print("touching the box, moving it")
        else
            --else we create a ball
            create_ball(xx, yy)
            print("not touching the box, creating a ball")
        end
    end
    if event.phase == "moved" and boxTouched == true then
        box:applyForce(fx * 200, fy * 200, xx, yy)
    end
    if event.phase == "ended" then
        boxTouched = false
    end
end


--add a listener for touching the screen
RNListeners:addEventListener("touch", screen_touch)


function removeBall(self, event)
    --removes the ball if it touches the floor
    if (event.other.name == "rapanui-samples/physics/floor.png") then self:remove() end
end


function create_ball(xx, yy)
    --each ball calls the remove ball each collision
    local bb = RNFactory.createImage("rapanui-samples/physics/ball.png"); bb.x = xx; bb.y = yy;
    RNPhysics.createBodyFromImage(bb, { radius = 21, restitution = 0.9, density = 1, friction = 0.3 })
    bb.collision = removeBall
    bb:addEventListener("collision")
end


--Click to add a bouncing ball, self destroyed when touching the floor
--Click the box to move move it toward the mouse.
