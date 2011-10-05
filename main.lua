--We require more minerals
sprite = require "sprite"
physics = require "physics"
--Our own "classes" go here
local Cloud = require("cloud")
local Drill = require("drill")
local Rain = require("rain")

--Start physics and other initializations
physics.start()
physics.setDrawMode("hybrid")
local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0,100,200)
system.setIdleTimer(false) --No more screen going to sleep!

--Some variables
world_width = 1600
curr_y = 0 --The screen is a subset of the world, so store where the screen starts
cloud9 = Cloud:new(0, 10, 1)
drillList = {}
rainList = {}
cloudList = {}
table.insert(cloudList, cloud9)

--On Accel, deals with accelerator input
local function onAccel(event)
    
end

--Update, happens every frame
local function update(event)
    for key,aCloud in pairs(cloudList) do
        aCloud:update(event)
        --Make it rain!
        table.insert(rainList, Rain:new(math.random(aCloud.img.x-aCloud.img.width/4, aCloud.img.x+aCloud.img.width/4), aCloud.img.y))
    end
    for key,aDrill in pairs(drillList) do
        aDrill:update(event) 
    end
    for key,aRain in pairs(rainList) do
        toKeep = aRain:update(event)
        if toKeep == false then
            table.remove(rainList, key)
        end
    end
end

--What happens if we touch the creen
local function onTouch(event)
    table.insert(drillList, Drill:new(event.x, event.y, 0))
end

--Put our event listeners here!
Runtime:addEventListener("accelerometer", onAccel)
Runtime:addEventListener("enterFrame", update)
Runtime:addEventListener("touch", onTouch)