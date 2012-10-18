--- -sets the sprites
background = RNFactory.createImage("rapanui-samples/physics/background-purple.png")
box = RNFactory.createImage("rapanui-samples/physics/box.png"); box.x = 160; box.y = 80;
ball = RNFactory.createImage("rapanui-samples/physics/ball.png"); ball.x = 210; ball.y = 0;
ball2 = RNFactory.createImage("rapanui-samples/physics/ball.png"); ball2.x = 150; ball2.y = 0;
poly = RNFactory.createImage("rapanui-samples/physics/poly.png"); poly.x = 100; poly.y = 0;
bpoly = RNFactory.createImage("rapanui-samples/physics/poly.png"); bpoly.x = 210; bpoly.y = -100;
floor = RNFactory.createImage("rapanui-samples/physics/floor.png"); floor.x = 160; floor.y = 400;
box2 = RNFactory.createImage("rapanui-samples/physics/box.png"); box2.x = 50; box2.y = 400;
ball3 = RNFactory.createImage("rapanui-samples/physics/ball.png"); ball3.x = 10; ball3.y = -60;
----- setting up the physic world

RNPhysics.start()
RNPhysics.setMeters(60)
----- add bodies

--adds some bodies
--simple rectangular body and some changing attributes examples of visibility and grouping
RNPhysics.createBodyFromImage(box)
box.rotation = 10
box.isSensor = false
box.visible = false
box.isVisible = true
--there are 2 ways to set and get body's fixture's properties:
--MODE1>change> obj.fixture[i].field=value  / MODE1>access> obj.fixture[i].value  and
--MODE2>change> obj.field=value  / MODE2>access> obj.field
box.fixture[1].restitution = 0 --MODE 1 (specific) --set and get the specified property for the specified fixture(working for each fixture's field restituion,density,filter,sensor,friction)
box.density = 1 --MODE 2 (global) --set and get the specified property for each fixture in this body.(working for each fixture's field restituion,density,filter,sensor,friction)
--so MODE2 get will work better if you used MODE2 set (because all fixtures have the same field properties)
--simply care when you use MODE1 and MODE2 togheter.
--circle body with proprieties and restituion
RNPhysics.createBodyFromImage(ball2, "dynamic", { density = 1, friction = 0.3, restitution = 0.8, sensor = false, radius = 21 })
--triangle polygon
RNPhysics.createBodyFromImage(poly, { density = 1, friction = 0.3, restitution = 0, sensor = false, shape = { -32, 32, 0, -32, 32, 32 } })
--circle body and polygon bouncing body both with groupIndex filters set to -1 so
--they won't collide.
RNPhysics.createBodyFromImage(ball, "dynamic", { density = 1, friction = 0.3, restitution = 0, filter = { groupIndex = -1 }, sensor = false, shape = "circle" })
RNPhysics.createBodyFromImage(bpoly, "dynamic", { density = 1, friction = 0.3, restitution = 0.5, filter = { groupIndex = -1 }, sensor = false, shape = { -32, 32, 0, -32, 32, 32 } })
--static and complex body
--(more than one fixture in one body, each with his own proprieties-->check it in debug draw)
RNPhysics.createBodyFromImage(floor, "static", { density = 1, friction = 0.3, restitution = 0, sensor = false, shape = { -128, -16, 128, -16, 128, 16, -128, 16 } }, { density = 1, friction = 0.3, restitution = 0.5, sensor = false, shape = { -32, 32, 32, 32, 0, 64 } })
--kinematic simple body (but it can be  polygon ,a circle and complex as well if you want)
--a kinematic body doesn't collide with static and kinematic bodies
--a kinematic body can be moved only by setting his velocity(it doesnt respond to forces)
RNPhysics.createBodyFromImage(box2, "kinematic")
--a simple circle sensor (it generates collision but its not affected to them)
--only dynamics and static bodies can be sensors
RNPhysics.createBodyFromImage(ball3, { density = 1, friction = 0.3, restitution = 0, sensor = true, shape = "circle" })



---------------------------- RNPhysics joints------------------------------------------


--revolute  (type,bodyA,bodyB,anchorX,anchorY)
--j1 = RNPhysics.createJoint("revolute", box, ball2, 100, 100)

--distance  (type,bodyA,bodyB,anchorA_X.anchorA_Y,anchorB_X,anchorB_Y[,frequency,damping])
--j2=RNPhysics.createJoint("distance",box,ball2,box:getX(),box:getY(),ball2:getX(),ball2:getY())

--prismatic (type,bodyA,bodyB,anchorA_X,anchorA_Y,axisA,axisB)
--j3=RNPhysics.createJoint("prismatic",box,ball2,box.x,box.y,10,10)

--friction  (type,bodyA,bodyB,anchorX,anchorY[, number maxForce, number maxTorque ] )
--j4=RNPhysics.createJoint("friction",box,ball2,10,10)

--weld  (type,bodyA,bodyB,anchorX,anchorY)
--j5=RNPhysics.createJoint("weld",box,ball2,10,10)

--wheel  (type,bodyA,bodyB,anchorX,anchorY,axisX,axisY)
--j6=RNPhysics.createJoint("wheel",box,ball2,10,10,10,10)

--pulley (type,bodyA,bodyB,groundAnchorA_X,groundAnchorA_Y,groundAnchorB_X,groundAnchorB_Y,anchorA_X,anchorA_Y,anchorB_X,anchorB_Y[,ratio,maxLength1,maxLength2])
--j7=RNPhysics.createJoint("pulley",box,ball2,200,50,10,50,box:getX(),box:getY(),ball2:getX(),ball2:getY(),1)

--gear (type,jointA,jointB,ratio)
--j8=RNPhysics.createJoint("gear",j1,j2,1)

--mouse (type,bodyA,bodyB,targetX,targetY,maxForce [,frequencyHz,dampingRatio ] )
--j9=RNPhysics.createJoint("mouse",box,ball,box.x,box.y,10,10,10)







--------------------- Debug Draw-----------------------------------------------------


--remove "--" to start box2d debug draw
--RNPhysics.setDebugDraw(RNFactory.screen)







------------------------ global collision handling------------------------------------------


--how to do collision handling: 
--simply create a function for collision's callbacks 
function onCollide(event)
    --print things (if objects are still there after collision)
    --only in pre_solve and post_solve phase event can find a force and a friction
    if (event.phase == "begin") then
        print(event.phase .. " collision between fixture number " .. event.fixture1.indexinlist .. " of " .. event.object1.name .. " and fixture number " .. event.fixture2.indexinlist .. " of " .. event.object2.name .. "---with a force of " .. event.force .. " and a friction of " .. event.friction)
    end
    --remove the bouncing ball at floor collision
    if (event.object1 == ball2) and (event.object2 == floor) then ball2:remove() end
end

--and set it for receiveing callbacks
RNPhysics.addEventListener("collision", onCollide)


-------------------------- local collision handling----------------------------------------

--create a function for collision's callbacks
function onLocalCollide(self, event)
    if (event.self ~= nil) and (event.other ~= nil) and (event.phase == "begin") then
        print("Hi, I'm a " .. self.name .. " and im calling a " .. event.phase .. " local collision event between my fixture number " .. event.selfFixture.indexinlist .. " and fixture number " .. event.otherFixture.indexinlist .. " of " .. event.other.name .. " with a force of " .. event.force .. " and a friction of " .. event.friction)
    end
end

--set the RNBody.collision field to the function you just created
box.collision = onLocalCollide
box:addEventListener("collision")

--you can create as many local collision handlers as you want (one for each object)


--NB:global and local collision handlers override themselves
--so if you set the fixtures of an object for callbacks on functionA and then you set all the fixtures
--for callbacks on functionB, the fixtures of the object will give callbacks only to fixtureB
--else if you set functionB for all fixtures callbacks and then funcionA only for a specifi object's
--fixture callback, the fixture collision callback is only given to functionA.
--that's because each fixture can have set on it just one callback function at time.

--useful things we can do with local collision handling:
--(check the code below "testing touch")
--instead of checking each collision and each fixture and the names of the collision objects
--we are always sure that "self" is the object wich is collideing.
--so we don't even need to know his name or store references to it
--(all balls are in a local bb variable)



------------------------- testing touch-------------------------------------
function screen_touch(event)
    --receiveing from touch
    print(event.phase .. " touch event at " .. event.x .. "  " .. event.y)
    --if the box is touched we apply a force toward the touch to it.
    local xx = event.x
    local yy = event.y
    local xx2 = box.x
    local yy2 = box.y
    local fx = xx - xx2
    local fy = yy - yy2
    --if you touch the box,you move it
    --(this is not really a precise touching function)
    --(the real one  should be done with object:addEventListener("touch")
    --so we receive callback only if the specified object is touched.
    if (math.abs(yy - yy2) < 32) and (math.abs(xx - xx2) < 32) then
        box:applyForce(fx * 2000, fy * 2000, xx, yy)
        print("touching the box, moving it")
    else
        --else we create a ball
        create_ball(xx, yy)
        print("not touching the box")
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


--- -Click to add a bouncing ball, self destroyed when touching the floor
---- Click the box to move move it toward the mouse.

------------------------------- Animation Test---------------------------------


--display.newAnim(filename,sizex,sizey[,posx,posy,scaleX,scaleY])
--size is the size of each frame;scale is the size of the rect containing the animation.
--if scale is changed after the anim become physical, the physical body size won't change.
--animObject.frame is the current animation frame.Change this and the animation will jump
--to that frame.

--setting up a sequence brench for char
function onEndS1()
    char:play("walkBack")
end

function onEndS2()
    char:play("walkLeft")
end

function onEndS3()
    char:play("walkRight")
end

function onEndS4()
    char:stop()
end

--physical animation with many sequences
--newAnim(file,sizeX,sizeY[,posx,posy,scaleX,scaleY])
char = RNFactory.createAnim("images/char.png", 42, 32, 100, -200, 0.27, 0.5)
RNPhysics.createBodyFromImage(char)
char.restitution = 0.1
--newSequence(name,frameOrder,speed,repeatTimes,onStopFunction)
char:newSequence("walkFront", { 7, 8, 9 }, 6, 10, onEndS1)
char:newSequence("walkBack", { 1, 2, 3 }, 6, 10, onEndS2)
char:newSequence("walkLeft", { 4, 5, 6 }, 6, 10, onEndS3)
char:newSequence("walkRight", { 10, 11, 12 }, 6, 10, onEndS4)
char:play("walkFront")




--simple animation which plays the default sequence
char2 = RNFactory.createAnim("images/char2.png", 42, 32)
char2.x = 100; char2.y = 100; char2.rotation = 30;
char2.scalex = 1; char2.scaley = 2
char2.frame = 1
char2:flipHorizontal()
char2:flipVertical()
--here default sequence will be used
char2:play() --plays the default sequence
char2:togglePause() --pause
char2:togglePause() --unpause
char2:togglePause() --pause
char2:play("default", 12, 5) --plays "default" sequence by calling it and sets a new speed and repeat times to it.

char2:newSequence("try") --adds a newSequence
char2:removeSequence("try") --removes the sequence