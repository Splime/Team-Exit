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
local Lightning = require("lightning")

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
boltList = {}
drillList = {}
rainList = {}
cloudList = {}
birdList = {}
crapList = {}
table.insert(cloudList, cloud9)
atk_clk = 0

birdtest = Bird:new(display.contentWidth - 100, 10, -1)
table.insert(birdList, birdtest)

--On Accel, deals with accelerator input
-- local function onAccel(event)
    -- accelSpeed = centerX + (centerX * event.xGravity)
	-- -- Circle.y = centerY + (centerY * event.yGravity * -1)
-- end

--Update, happens every frame
local function update(event)
    atk_clk = atk_clk + 1
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
            table.insert(rainList, Rain:new(math.random(aCloud.img.x-aCloud.img.width/4, aCloud.img.x+aCloud.img.width/4), aCloud.img.y, onRainCollision))
        end
        if aCloud.img.mood == "angry" and atk_clk == 100 then
            table.insert(boltList, Lightning:new(aCloud.img.x, aCloud.img.y, balloon.img.x, balloon.img.y))
            atk_clk = 0
            if cloud
        end
    end
    --Birds
    for key,aBird in pairs(birdList) do
        local toKeep = aBird:update(event)
        if toKeep == false then
            table.remove(birdList, key)
        end
        --Make it rain!
        if math.random(1,20) == 1 then
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
    --Lightning
    for key,aLightning in pairs(boltList) do
        local toKeep = aLightning:update(event)
        if toKeep == false then
            table.remove(boltList, key)
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


local function onCollision(event)

    -- drill and not clouds
    if (event.object1.name == "drill" and event.object2.name ~= "cloud") or (event.object2.name == "drill" and event.object1.name ~= "cloud") then
        event.object1.isSensor = true
        return
    end

    -- drill and cloud
    if event.object1.name == "drill" and event.object2.name == "cloud" then
        if (event.object2.mood == "happy" or event.object2.mood == "sad") then
            deleteImageFromTable(drillList, event.object1)
            event.object2.mood = "sad"
            audio.play(sounds.drill_cloud)
            return
        elseif (event.object2.mood == "angry") then
            event.object2.hp = event.object2.hp - 1
            return
        end
    elseif event.object2.name == "drill" and event.object1.name == "cloud" then
        if (event.object1.mood == "happy" or event.object1.mood == "sad") then
            deleteImageFromTable(drillList, event.object2)
            event.object1.mood = "sad"
            audio.play(sounds.drill_cloud)
            return
         elseif (event.object1.mood == "angry") then
            event.object1.hp = event.object1.hp - 1
            return
        end
    end


    -- rain/crap and not player
    if ((event.object1.name == "rain" or event.object1.name == "crap") and event.object2.name ~= "player") or ((event.object2.name == "rain" or event.object2.name == "crap") and event.object1.name ~= "player") then
        event.object1.isSensor = true
        return
    end

    -- rain and player
    if event.object1.name == "rain" and event.object2.name == "player" then
        deleteImageFromTable(rainList, event.object1)
        event.object2.rain = event.object2.rain + 1
        return
    elseif event.object2.name == "rain" and event.object1.name == "player" then
        deleteImageFromTable(rainList, event.object2)
        event.object1.rain = event.object1.rain + 1
        return
    end

    -- crap and player
    if event.object1.name == "crap" and event.object2.name == "player" then
        deleteImageFromTable(crapList, event.object1)
        event.object2.health = event.object2.health - 5
        return
    elseif event.object2.name == "crap" and event.object1.name == "player" then
        deleteImageFromTable(crapList, event.object2)
        event.object1.health = event.object1.health - 5
        return
    end

    

end



--What happens if we touch the screen
local function onTouch(event)
    aimposx = event.x
    aimposy = event.y
    if drillCooldown <= 0 and event.phase == "began" then
        table.insert(drillList, Drill:new(balloon.img.x, balloon.img.y, aimposx, aimposy))
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
