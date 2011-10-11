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

--startGame: Starts the game (put in a function so it won't happen pre-menu)
function startGame(event)
    --Start physics and other initializations
    physics.start()
    physics.setDrawMode("hybrid")
    physics.setGravity(0, 0)
    background:removeSelf()
    button:removeSelf()
    system.setIdleTimer(false) --No more screen going to sleep!
    
    background = display.newImage("img/temp_bg.png", true) --Background image, covers up all the black space
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2
    --Now some quick shortcut variables for figuring out the min/max coords for objects to be at before removal
    maxX = display.contentWidth/2 + background.contentWidth/2
    minX = display.contentWidth/2 - background.contentWidth/2
    maxY = display.contentHeight/2 + background.contentHeight/2
    minY = display.contentHeight/2 - background.contentHeight/2

    --cloud9 = Cloud:new(0, 10, 1)
    --table.insert(cloudList, cloud9)
    --birdtest = Bird:new(display.contentWidth - 100, 10, -1)
    --table.insert(birdList, birdtest)

    balloon = Player:new(200, 200)
    
    startListeners()
    
    --start the actual game
    loadLevel()
    audio.play(sounds.music1, {loops=-1})

end

--Menu function! Right now, only works as a starting menu, not a pause menu
function displayMenu()
    background = display.newImage("img/temp_bg.png", true) --Background image, covers up all the black space
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2
    --Make a big red button
    button = display.newImage("img/temp_button.png")
    button.x = display.contentWidth/2
    button.y = display.contentHeight/2
    --Make the button do something
    button:addEventListener("touch", startGame)
end



--sound effects
sounds = {
    music1 = audio.loadSound("level1song.wav"),
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

num_frames = 0--number of frames

--outOfBounds: Takes one of our classes, figures out if it's out of bounds or not (usually for removal purposes)
--obj MUST HAVE a field obj.img
function outOfBounds(obj)
    if obj.img.x < minX - obj.img.contentWidth/2 or obj.img.x > maxX + obj.img.contentWidth/2 or 
        obj.img.y < minY - obj.img.contentHeight/2 or obj.img.y > maxY + obj.img.contentHeight/2 then
        return true
    end
    
    return false
end

--loads a level from a text file
--note that time is in frames each of which is 33 milliseconds, 30 frames a second
function loadLevel()
    --start by clearing the level
    levelList={}
    num_frames = 0
    -- print ("loading a level")
    startlevel = startlevel + 1
    if(startlevel > maxlevel) then
        print ("no more levels to load")
        return
    end
    local pathval = (levelkey[1] .. startlevel .. levelkey[2])
    -- print (pathval)
    local path = system.pathForFile(pathval)--system.ResourceDirectory
    -- local file = io.open(path, "r")
    -- if not file then
        -- print("error loading level, game aborted")
        -- os.exit()
    -- else
        -- print("file exists")
        -- print(file.path)
    -- end
    io.input(path, "r")
    
    --first get our level
    -- local levelVal = assert (io.read("*l"), "error reading the file")
    local levelVal = io.read("*l")
    --string stripping operation from http://lua-users.org/wiki/StringTrim
    --levelVal = levelVal:match'^%s*(.*%S)'
    -- print(levelVal)
    local levelDescription = Split(levelVal, delimiter)
    --set the description of the level
    levelList[levelDescription[1]] = {levelDescription[2], levelDescription[3]}
    --establish variable to decide whether or not we are done reading
    local eof = false
    local wave = {}
    local obj = {}
    wave["time"] = 0
    local fullLine = io.read("*l")
    while fullLine ~= nil do
        local splitLine = Split(fullLine, delimiter)
        if(fullLine == "ENDWAVE" ) then
            table.insert(levelList, wave["time"], wave)
        elseif (splitLine[1] == "BEGINWAVE") then
            wave={}
            if (splitLine[2] == nil) then
                wave["time"] = 0
            else
                wave["time"] = splitLine[2]
            end--else we have a class to add to the wave
        elseif (splitLine[1] == "Cloud") then--cloud, x pos, y pos, speed
            obj={}
            table.insert(obj, splitLine[1])
            table.insert(obj, splitLine[2])
            table.insert(obj, splitLine[3])
            table.insert(obj, splitLine[4])
            table.insert(obj, splitLine[5])
            table.insert(wave, obj)
        elseif (splitLine[1] == "Bird") then--bird, x pos, y pos, speed
            obj={}
            table.insert(obj, splitLine[1])
            table.insert(obj, splitLine[2])
            table.insert(obj, splitLine[3])
            table.insert(obj, splitLine[4])
            table.insert(wave, obj)
        else
            print("error reading file")
        end
        
        fullLine = io.read("*l")
        
    end
    
    wave={}
    obj={}
    -- file:close()
    

end

--Update, happens every frame
function update(event)
    num_frames = num_frames + 1
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
        if aCloud.mood == "sad" and ( (num_frames - aCloud.hitFrame) < aCloud.hitDiff ) then
            table.insert(rainList, Rain:new(math.random(aCloud.img.x-aCloud.img.width/4, aCloud.img.x+aCloud.img.width/4), aCloud.img.y, onRainCollision))
        end
        if aCloud.mood == "angry" and math.random(1,45) == 1 then
            table.insert(boltList, Lightning:new(aCloud.img.x, aCloud.img.y, balloon.img.x, balloon.img.y))
            num_frames = 0
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

function populate(event)
    if (levelList[event.count] == nil) then
        return--then there is no wave at this time
    else
        print("waveFound")
        for index, value in ipairs(levelList[event.count]) do
            if (value[1] == "Cloud") then
                print("inserting cloud")
                local newCloud = Cloud:new(value[2], value[3], value[4], value[5])
                table.insert(cloudList, newCloud)
            elseif (value[1] == "Bird") then
                print("inserting bird")
                local newBird = Bird:new(value[2], value[3], value[4])
                table.insert(birdList, newBird)
            else
                return
            end
            
        end
    
    end

end


function deleteImageFromTable(objList, img)
    for key,obj in pairs(objList) do
        if obj.img == img then
            img:removeSelf()
            table.remove(objList, key)
            break
        end
    end
end



function onCollision(event)
    -- drill and not clouds
    if (event.object1.name == "drill" and event.object2.name ~= "cloud") or (event.object2.name == "drill" and event.object1.name ~= "cloud") then
        event.object1.isSensor = true
        return
    end
    -- drill and cloud
    if event.object1.name == "drill" and event.object2.name == "cloud" then
        local numval = num_frames
        deleteImageFromTable(drillList, event.object1)
        local val = event.object2:takeDrillHit(numval)
        if (val == false) then
            deleteImageFromTable(cloudList, event.object2)
        end
        audio.play(sounds.drill_cloud)
        return
    elseif event.object2.name == "drill" and event.object1.name == "cloud" then
        local numval = num_frames
        deleteImageFromTable(drillList, event.object2)
        local val = event.object1:takeDrillHit(numval)
        if (val == false) then
            deleteImageFromTable(cloudList, event.object1)
        end
        audio.play(sounds.drill_cloud)
        return
    end


    -- rain/crap and not player
    if ((event.object1.name == "rain" or event.object1.name == "crap" or event.object1.name == "lightning") and event.object2.name ~= "player") or ((event.object2.name == "rain" or event.object2.name == "crap" or event.object2.name == "lightning") and event.object1.name ~= "player") then
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

    -- crap and player
    if event.object1.name == "lightning" and event.object2.name == "player" then
        deleteImageFromTable(boltList, event.object1)
        event.object2.stuntime = 30
        return
    elseif event.object2.name == "lightning" and event.object1.name == "player" then
        deleteImageFromTable(boltList, event.object2)
        event.object1.stuntime = 30
        return
    end

    

end



--What happens if we touch the screen
function onTouch(event)
    aimposx = event.x
    aimposy = event.y
    if balloon.img.stuntime == 0 then
        if event.y > display.contentHeight - 80 then
            print("PRESS A BUTTON")
        elseif drillCooldown <= 0 and event.phase == "began" then
            table.insert(drillList, Drill:new(balloon.img.x, balloon.img.y, aimposx, aimposy))
            drillCooldown = maxDrillDelay
        end
    end
end
local function onAccel(event)
    balloon:movement(event, event.yGravity)
end


--Put our event listeners here!
function startListeners()
    Runtime:addEventListener("accelerometer", onAccel)
    -- Runtime:addEventListener("enterFrame", update)
    Runtime:addEventListener("touch", onTouch)
    Runtime:addEventListener("collision", onCollision)
    --start our timer
    timer.performWithDelay(33, update, 0)
    timer.performWithDelay(33, populate, 0)
end

--And now the actual main code:
displayMenu()
