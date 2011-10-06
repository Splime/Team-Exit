--We require more minerals
sprite = require "sprite"
physics = require "physics"
--Our own "classes" go here
local Cloud = require("cloud")
local Drill = require("drill")
local Rain = require("rain")
local Bird = require("bird")
local Crap = require("crap")
local Player = require("player")

--Start physics and other initializations
physics.start()
physics.setDrawMode("hybrid")
physics.setGravity(0, 0)
local background = display.newRect(0, 0, display.contentWidth, display.contentHeight)
background:setFillColor(0,100,200)
system.setIdleTimer(false) --No more screen going to sleep!

--sound effects
sounds = {
    drill_cloud = audio.loadSound("sounds/test.wav")
}


--Some variables
world_width = 1600
curr_y = 0 --The screen is a subset of the world, so store where the screen starts
cloud9 = Cloud:new(0, 10, 1)
balloon = Player:new(200, 200)
drillList = {}
rainList = {}
cloudList = {}
birdList = {}
crapList = {}
table.insert(cloudList, cloud9)

birdtest = Bird:new(display.contentWidth - 100, 10, -1)
table.insert(birdList, birdtest)

--On Accel, deals with accelerator input
-- local function onAccel(event)
    -- accelSpeed = centerX + (centerX * event.xGravity)
	-- -- Circle.y = centerY + (centerY * event.yGravity * -1)
-- end

--Update, happens every frame
local function update(event)
    --Clouds
    for key,aCloud in pairs(cloudList) do
        local toKeep = aCloud:update(event)
        if toKeep == false then
            table.remove(cloudList, key)
        end
        --Make it rain!
        if aCloud.img.mood == "sad" then
            table.insert(rainList, Rain:new(math.random(aCloud.img.x-aCloud.img.width/4, aCloud.img.x+aCloud.img.width/4), aCloud.img.y))
        end
    end
    --Birds
    for key,aBird in pairs(birdList) do
        local toKeep = aBird:update(event)
        if toKeep == false then
            table.remove(birdList, key)
        end
        --Make it rain!
        if math.random(1,10) == 1 then
            table.insert(crapList, Crap:new(math.random(aBird.img.x-aBird.img.width/4, aBird.img.x+aBird.img.width/4), aBird.img.y))
        end
    end
    --Drills
    for key,aDrill in pairs(drillList) do
        local toKeep = aDrill:update(event)
        if toKeep == false then
            table.remove(drillList, key)
        end
    end
    --Rains
    for key,aRain in pairs(rainList) do
        local toKeep = aRain:update(event)
        if toKeep == false then
            table.remove(rainList, key)
        end
    end
    --Craps
    for key,aCrap in pairs(crapList) do
        local toKeep = aCrap:update(event)
        if toKeep == false then
            table.remove(crapList, key)
        end
    end
    balloon:update(event, accelSpeed)
end


local function deleteImageFromTable(objList, img)
    for key,obj in pairs(objList) do
        if obj.img == img then
            img:removeSelf()
            table.remove(objList, key)
            break
        end
    end
end


local function onCollision(self, event)

    -- drill and cloud
    if self.name == "drill" and event.other.name == "cloud" then
        deleteImageFromTable(drillList, self)
        event.other.mood = "sad"
        audio.play(sounds.drill_cloud)
    end

    -- something else and something else
end



--What happens if we touch the creen
local function onTouch(event)
    table.insert(drillList, Drill:new(event.x, event.y, 0, onCollision))
end

--Put our event listeners here!
--Runtime:addEventListener("accelerometer", onAccel)
Runtime:addEventListener("enterFrame", update)
Runtime:addEventListener("touch", onTouch)
-- Runtime:addEventListener("collision", onCollision)
