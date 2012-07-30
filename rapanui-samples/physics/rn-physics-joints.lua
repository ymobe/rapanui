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

--Joint creation sample


--add images
background = RNFactory.createImage("rapanui-samples/physics/background-purple.png")
box = RNFactory.createImage("rapanui-samples/physics/box.png"); box.x = 170; box.y = 80;
ball = RNFactory.createImage("rapanui-samples/physics/ball.png"); ball.x = 240; ball.y = 80;
triangle = RNFactory.createImage("rapanui-samples/physics/poly.png"); triangle.x = 80; triangle.y = 80; triangle.rotation = 190
floor = RNFactory.createImage("rapanui-samples/physics/floor.png"); floor.x = 160; floor.y = 400;

--starts simulation
RNPhysics.start()

tempJoint = nil
--set images as physics objects
RNPhysics.createBodyFromImage(box)
RNPhysics.createBodyFromImage(ball, { shape = "circle" })
RNPhysics.createBodyFromImage(triangle, { shape = { -32, 32, 0, -32, 32, 32 }, restitution = 0.3, friction = 0.1 })
RNPhysics.createBodyFromImage(floor, "static")
box.restitution = 0.5
ball.restitution = 0.3
triangle.restitution = 0.3



--set debud draw on screen
RNPhysics.setDebugDraw(RNFactory.screen)


--add Joints! Remove comments to add joints

--revolute  (type,bodyA,bodyB,anchorX,anchorY)
--j1 = RNPhysics.createJoint("revolute", box, triangle, 100, 100)

--distance  (type,bodyA,bodyB,anchorA_X.anchorA_Y,anchorB_X,anchorB_Y[,frequency,damping])
--j2 = RNPhysics.createJoint("distance", box, triangle, box.x, box.y, triangle.x, triangle.y)

--prismatic (type,bodyA,bodyB,anchorA_X,anchorA_Y,axisA,axisB)
--j3=RNPhysics.createJoint("prismatic",box,triangle,box.x,box.y,10,10)

--friction  (type,bodyA,bodyB,anchorX,anchorY[, number maxForce, number maxTorque ] )
--j4=RNPhysics.createJoint("friction",box,triangle,10,10)

--weld  (type,bodyA,bodyB,anchorX,anchorY)
--j5=RNPhysics.createJoint("weld",box,triangle,10,10)

--wheel  (type,bodyA,bodyB,anchorX,anchorY,axisX,axisY)
--j6=RNPhysics.createJoint("wheel",box,triangle,10,10,10,10)

--pulley (type,bodyA,bodyB,groundAnchorA_X,groundAnchorA_Y,groundAnchorB_X,groundAnchorB_Y,anchorA_X,anchorA_Y,anchorB_X,anchorB_Y[,ratio,maxLength1,maxLength2])
--j7 = RNPhysics.createJoint("pulley", box, triangle, 100, 100, 200, 100, box:getX(), box:getY(), triangle:getX(), triangle:getY(), 1)


--gear (type,jointA,jointB,ratio)
--works only with revolute and/or prismatic joints
--j8= RNPhysics.createJoint("gear",j1,j3,5)

--rope(type,bodyA,bodyB,maxLength,[,anchorAX,anchorAY,anchorBX,anchorBY])
j10= RNPhysics.createJoint("rope",box,triangle,10,box.x,box.y,triangle.x,triangle.y)

--remove joint tutorial
--Remove Join doesnt work, it throws an exception:
--PANIC: unprotected error in call to Lua API (error loading module 'RNObject' from file './RNObject.lua':
--	./RNObject.lua:880: ')' expected (to close '(' at line 879) near 'self')

j10:remove()





--[[ Mouse Joint Testing

ground=RNFactory.createImage("RapaNui-samples/physics/floor.png");ground.x=0;ground.y=0;
ground.visible=false
RNPhysics.createBodyFromImage(ground,"kinematic",{shape={0,0,320,0,320,480,0,480},sensor=true })

function touchH(event)
        local body = box
        local phase = event.phase

        if "began" == phase then
                -- Create a temporary touch joint and store it in the object for later reference
                tempJoint = RNPhysics.createJoint( "mouse", ground,body, event.x/60, event.y/60,9999999999999999)
                print("event "..event.x,event.y)
                tempJoint.setTarget(tempJoint,event.x,event.y)
                local xxx,yyy=tempJoint:getTarget()
                print("joint "..xxx,yyy)
		end
		if "moved" == phase then

                        -- Update the joint to track the touch
                        print("event "..event.x,event.y)
                		tempJoint.setTarget(tempJoint,event.x,event.y)
                		local xxx,yyy=tempJoint:getTarget()
                		print("joint "..xxx,yyy)

		end
        if "ended" == phase then

                        -- Remove the joint when the touch ends
                        tempJoint:remove()
        end

end





RNListeners:addEventListener("touch",touchH)

]] --

--[[

    Mouse Joint, Rope Joint and Gear Joint Under Development.


	Mouse Joint Problems:
	Several. ;P

	Gear Joint Problem:
	Due to a bug, the gear Joint is only added to the global joint list and not to
	its joint jointlist. And it's not removed from global joint list when is destroyed
	by removing the joints it connect.


	

	Check other samples for joint list access tutorial.



]] --

