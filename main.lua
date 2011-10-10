--We require more minerals
sprite = require "sprite"
physics = require "physics"
string = require "string"
--Our own "classes" go here
local Cloud = require("cloud")
local Drill = require("drill")
local Rain = require("rain")
local Bird = require("bird")
local Crap = require("crap")
local Player = require("player")
local Lightning = require("lightning")

--level loading related variables
local maxlevel = 1--the last level in the game
local startlevel = 0
local levelkey = {"level", ".txt"}
local delimiter = "^"

--string splitting function for level reading, attributed to http://lua-users.org/wiki/SplitJoin

function Split(str, delim, maxNb)
    --print(str)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

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
drillCooldown = 0
boltList = {}
drillList = {}
rainList = {}
cloudList = {}
birdList = {}
crapList = {}
levelList = {}

atk_clk = 0

cloud9 = Cloud:new(0, 10, 1)
table.insert(cloudList, cloud9)
birdtest = Bird:new(display.contentWidth - 100, 10, -1)
table.insert(birdList, birdtest)


balloon = Player:new(200, 200)

--On Accel, deals with accelerator input
-- local function onAccel(event)
    -- accelSpeed = centerX + (centerX * event.xGravity)
	-- -- Circle.y = centerY + (centerY * event.yGravity * -1)
-- end

--loads a level from a text file
--note that time is in frames each of which is 33 milliseconds, 30 frames a second
local function loadLevel()
    --start by clearing the level
    levelList={}
    print ("loading a level")
    startlevel = startlevel + 1
    if(startlevel > maxlevel) then
        print ("no more levels to load")
        return
    end
    local pathval = (levelkey[1] .. startlevel .. levelkey[2])
    print (pathval)
    local path = system.pathForFile(pathval)--system.ResourceDirectory
    local file = io.open(path, "r")
    if not file then
        print("error loading level, game aborted")
        --os.exit()
    else
        print("file exists")
        print(file.path)
    end
    
    --first get our level
    local levelVal = assert (io.read("*l"), "error reading the file")
    --string stripping operation from http://lua-users.org/wiki/StringTrim
    --levelVal = levelVal:match'^%s*(.*%S)'
    print(levelval)
    local levelDescription = Split(levelVal, delimiter)
    --set the description of the level
    levelList[levelDescription[1]] = {levelDescription[2], levelDescription[3]}
    --establish variable to decide whether or not we are done reading
    local eof = false
    local wave = {}
    local obj = {}
    wave["time"] = 0
    local fullLine = ''
    while not eof do
        fullLine = assert(io.read("*l"), "error reading the file")
        if (fullLine ~= nil) then
            fullLine = Split(fullLine, delimiter)
            if(fullLine[1] == "ENDWAVE" ) then
                levelList[wave["time"]] = wave
            elseif (fullLine[1] == "BEGINWAVE") then
                wave={}
                if (fullLine[2] == nil) then
                    wave["time"] = 0
                else
                    wave["time"] = fullLine[2]
                end--else we have a class to add to the wave
            elseif (fullLine[1] == "Cloud") then--cloud, x pos, y pos, speed
                obj={}
                table.insert(obj, fullLine[1])
                table.insert(obj, fullLine[2])
                table.insert(obj, fullLine[3])
                table.insert(obj, fullLine[4])
                table.insert(wave, obj)
            elseif (fullLine[1] == "Bird") then--bird, x pos, y pos, speed
                obj={}
                table.insert(obj, fullLine[1])
                table.insert(obj, fullLine[2])
                table.insert(obj, fullLine[3])
                table.insert(obj, fullLine[4])
                table.insert(wave, obj)
            else
                print("error reading file")
            end
        else
            eof = true
        
        end
        
    end
    
    
    wave={}
    obj={}
    file:close()
    

end

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

local function populate(event)
    if (levelList[event.count] == nil) then
        return--then there is no wave at this time
    else
        for index, value in ipairs(levelList[event.count]) do
            if (value[1] == "Cloud") then
                local newCloud = Cloud:new(value[2], value[3], value[4])
                table.insert(birdList, newBird)
            else if (value[1] == "Bird") then
                local newBird = Bird:new(value[2], value[3], value[4])
                table.insert(birdList, newBird)
            else
                return
            end
            
        end
    
    end

end

end--?why do we need this end i don't even


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
    if event.object1.name == "drill" and event.object2.name == "cloud" and (event.object2.mood == "happy" or event.object1.mood == "sad") then
        deleteImageFromTable(drillList, event.object1)
        event.object2.mood = "sad"
        audio.play(sounds.drill_cloud)
        return
    elseif event.object2.name == "drill" and event.object1.name == "cloud" and (event.object1.mood == "happy" or event.object1.mood == "sad") then
        deleteImageFromTable(drillList, event.object2)
        event.object1.mood = "sad"
        audio.play(sounds.drill_cloud)
        return
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
--start our timer
--timer.performWithDelay(33, update, 0)
--timer.performWithDelay(33, populate, 0)


--start the actual game
--loadLevel()
