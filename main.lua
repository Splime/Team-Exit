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
    drill_cloud = audio.loadSound("test.wav")
}


--Some variables
maxDrillDelay = 100
aimposx = 0
aimposy = 0
lastFrameTime = 0
cloud9 = Cloud:new(0, 10, 1)
drillCooldown = 0
balloon = Player:new(200, 200)
drillList = {}
rainList = {}
cloudList = {}
birdList = {}
crapList = {}
table.insert(cloudList, cloud9)

birdtest = Bird:new(display.contentWidth - 100, 10, -1)
table.insert(birdList, birdtest)

--Update, happens every frame
local function update(event)
    timePassed = (event.time-lastFrameTime)
    --Adjust cooldown
    if drillCooldown > 0 then
        drillCooldown = drillCooldown - timePassed
    end
    --Clouds
    for key,aCloud in pairs(cloudList) do
        local toKeep = aCloud:update(event)
        if toKeep == false then
            table.remove(cloudList, key)
        end
        --Make it rain!
        if aCloud.img.mood == "sad" then
            table.insert(rainList, Rain:new(math.random(aCloud.img.x-aCloud.img.width/4, aCloud.img.x+aCloud.img.width/4), aCloud.img.y, onCollision))
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
            table.insert(crapList, Crap:new(math.random(aBird.img.x-aBird.img.width/4, aBird.img.x+aBird.img.width/4), aBird.img.y, onCollision))
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
    --Player
    balloon:update(event, accelSpeed)
    --Finished updating? Now change the previous time
    lastFrameTime = event.time
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

    -- drill and not clouds
    if self.name == "drill" and event.other.name ~= "cloud" then
        self.isSensor = true
        return
    end

    -- drill and cloud
    if self.name == "drill" and event.other.name == "cloud" then
        deleteImageFromTable(drillList, self)
        event.other.mood = "sad"
        audio.play(sounds.drill_cloud)
        return
    end


    -- rain/crap and not player
    if (self.name == "rain" or self.name == "crap") and event.other.name ~= "player" then
        self.isSensor = true
        return
    end

    

end



--What happens if we touch the creen
local function onTouch(event)
    aimposx = event.x
    aimposy = event.y
    if drillCooldown <= 0 and event.phase == "began" then
        table.insert(drillList, Drill:new(balloon.img.x, balloon.img.y, aimposx, aimposy, onCollision))
        drillCooldown = maxDrillDelay
    end
end
local function onAccel(event)
    balloon:movement(event, event.yGravity)
end


--Put our event listeners here!
Runtime:addEventListener("accelerometer", onAccel)
Runtime:addEventListener("enterFrame", update)
Runtime:addEventListener("touch", onTouch)
Runtime:addEventListener("collision", onCollision)
