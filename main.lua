--We require more minerals
sprite = require "sprite"
physics = require "physics"
--Our own "classes" go here
local Cloud = require("Cloud")

module("Main", package.seeall)

--Start physics and other initializations
physics.start()
physics.setDrawMode("hybrid")
local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0,100,200)
system.setIdleTimer(false) --No more screen going to sleep!
--system.orentation = "landscapeRight"

world_width = 1600
curr_y = 0 --The screen is a subset of the world, so store where the screen starts
cloud9 = Cloud:new()


local function onGyroscopeUpdate(event)
    print("event.x is " + (event.xRotation * event.deltaTime * (180/math.pi) ) )
    print("event.y is " + (event.yRotation * event.deltaTime * (180/math.pi) ) )
    print("event.z is " + (event.zRotation * event.deltaTime * (180/math.pi) ) )
end




--Put our event listeners here!

if system.hasEventSource("gyroscope") then
    Runtime:addEventListener("gyroscope", onGyroscopeUpdate)
else
    print("no gyroscope found")
end
