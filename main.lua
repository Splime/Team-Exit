--We require more minerals
sprite = require "sprite"
physics = require "physics"
--Our own "classes" go here
local Cloud = require("cloud")
local Drill = require("drill")

--Start physics and other initializations
physics.start()
physics.setDrawMode("hybrid")
local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0,100,200)
system.setIdleTimer(false) --No more screen going to sleep!

world_width = 1600
curr_y = 0 --The screen is a subset of the world, so store where the screen starts
cloud9 = Cloud:new(0, 10, 1)
drillList = {}
numDrills = 0

local function onAccel(event)
    
end

local function update(event)
    cloud9.update(event)
    if #drillList ~= 0 then
        for key,aDrill in pairs(drillList) do
           aDrill:update(event) 
        end
    end
end

local function onTouch(event)
    numDrills = numDrills + 1
    drillList[numDrills] = Drill:new(display, math, event.x, event.y, 0)
end

--Put our event listeners here!
Runtime:addEventListener("accelerometer", onAccel)
Runtime:addEventListener("enterFrame", update)
Runtime:addEventListener("touch", onTouch)