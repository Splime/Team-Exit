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
local ClickableButton = require("clickablebutton")
local EMP = require("emp")
local Drone = require("drone")


linesPrinted = 0
line = {}

function print_d(text)
    --OOPS! I switched debug mode off! :D
    --[[print(text)
    if linesPrinted >= 100 then
        line[linesPrinted%100 + 1]:removeSelf()
    end
    line[linesPrinted%100 + 1] = display.newText(text, 0, 20*(linesPrinted%100), native.systemFont, 16)
    linesPrinted = linesPrinted + 1]]
end

--Some global spriteset variables
--Birds
birdSheet = sprite.newSpriteSheet("img/goose_sheet_15fps.png", 53, 35)
birdSet = sprite.newSpriteSet(birdSheet, 1, 14)
sprite.add(birdSet, "birdfly", 1, 14, 1000)
--Clouds
cloudSheet = sprite.newSpriteSheet("img/happysad_cloud_sheet(anim_frames4-7).png", 156, 76)
happyCloudSet = sprite.newSpriteSet(cloudSheet, 1, 7)
cloudSheet2 = sprite.newSpriteSheet("img/small_cloud_sheet.png", 99, 64)
happyCloudSet2 = sprite.newSpriteSet(cloudSheet2, 1, 4)
sprite.add(happyCloudSet, "happy", 1, 1, 1)
sprite.add(happyCloudSet2, "happy2", 1, 1, 1)
sprite.add(happyCloudSet, "neutral", 2, 1, 1)
sprite.add(happyCloudSet2, "neutral2", 2, 1, 1)
sprite.add(happyCloudSet, "cry", 3, 4, 400, -1)
sprite.add(happyCloudSet2, "cry2", 4, 1, 400, -1)
frozenCloudSheet = sprite.newSpriteSheet("img/frozen_sheet.png", 153, 73)
frozenCloudSet = sprite.newSpriteSet(frozenCloudSheet, 1, 4)
sprite.add(frozenCloudSet, "happy", 1, 1, 1)
sprite.add(frozenCloudSet, "neutral", 2, 1, 1)
sprite.add(frozenCloudSet, "cry", 3, 2, 400, -1)
angryCloudSheet = sprite.newSpriteSheet("img/angry_cloud_sheet2.png", 163, 186)
angryCloudSet = sprite.newSpriteSet(angryCloudSheet, 1, 13)
sprite.add(angryCloudSet, "angry", 1, 10, 1000, 0)
sprite.add(angryCloudSet, "cry", 12, 2, 400, -1)
--Drills
drillSheet = sprite.newSpriteSheet("img/drill_sheet.png", 17, 23)
drillSet = sprite.newSpriteSet(drillSheet, 1, 2)
sprite.add(drillSet, "drill", 1, 2, 133)
--Player
playerSheet = sprite.newSpriteSheet("img/blimp_sheet.png", 113, 72)
playerSet = sprite.newSpriteSet(playerSheet, 1, 5)
sprite.add(playerSet, "left", 1, 2, 133)
sprite.add(playerSet, "idle", 3, 1, 1)
sprite.add(playerSet, "right", 4, 2, 133)

--level loading related variables
local maxlevel = 4--the last level in the game
local startlevel = 0
local levelkey = {"level", ".txt"}
local delimiter = "^"

--level requirements variables

local rainRequirement = 0
local levelTime = 10000--in frames

--[[
the following string splitting function for level reading, attributed to http://lua-users.org/wiki/SplitJoin
]]
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
--[[
end code that was lifted from the internet
]]

function clearEverything()

    audio.stop(backgroundmusichannel)
    lastFrameTime = 0
    drillCooldown = 0
    for key,thing in pairs(boltList) do
        thing.img:removeSelf()
        boltList[key] = nil
    end
    for key,thing in pairs(drillList) do
        thing.img:removeSelf()
        drillList[key] = nil
    end
    for key,thing in pairs(rainList) do
        thing.img:removeSelf()
        rainList[key] = nil
    end
    for key,thing in pairs(cloudList) do
        thing.img:removeSelf()
        cloudList[key] = nil
    end
    for key,thing in pairs(birdList) do
        thing.img:removeSelf()
        birdList[key] = nil
    end
    for key,thing in pairs(crapList) do
        thing.img:removeSelf()
        crapList[key] = nil
    end
    boltList = {}
    drillList = {}
    rainList = {}
    cloudList = {}
    birdList = {}
    crapList = {}
    num_frames = 0
    if balloon ~= nil then
        balloon.img:removeSelf()
        balloon = nil
    end
    if emp_button ~= nil then
        emp_button:removeSelf()
        emp_button = nil
    end
    if fire_button ~= nil then
        fire_button:removeSelf()
        fire_button = nil
    end
    if sunset ~= nil then
        sunset:removeSelf()
        sunset = nil
    end
    if raincount ~= nil then
        raincount:removeSelf()
        raincount = nil
    end
    if rainbase ~= nil then
        rainbase:removeSelf()
        rainbase = nil
    end

end

--startGame: Starts the game (put in a function so it won't happen pre-menu)
function startGame(event)
    --Start physics and other initializations
    physics.start()
    --physics.setDrawMode("hybrid")
    physics.setGravity(0, 0)
    if background ~= nil then
        background:removeSelf()
    end
    if button ~= nil then
        button:removeSelf()
    end
    if titleimg ~= nil then
        titleimg:removeSelf()
    end
    if instbutton ~= nil then
        instbutton:removeSelf()
        instbutton = nil
    end
    system.setIdleTimer(false) --No more screen going to sleep!
    
    background = display.newImage("img/bg_day.png", true) --Background image, covers up all the black space
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

    clearEverything()
    
    
    startlevel = 0

    --start the actual game
    loadLevel()
    timer.performWithDelay(33, update, 0)
end

--Menu function! Right now, only works as a starting menu, not a pause menu
function displayMenu()
    background = display.newImage("img/bg_day.png", true) --Background image, covers up all the black space
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2
    titleimg = display.newImage("img/title2.png", true) --Background image, covers up all the black space
    titleimg.x = display.contentWidth/2
    titleimg.y = display.contentHeight/2
    --Make a play button
    button = display.newImage("img/play_button.png")
    button.x = display.contentWidth/2
    button.y = display.contentHeight/2
    --Make the button do something
    button:addEventListener("touch", startGame)
    --Make an instructions button
    instbutton = display.newImage("img/instructions_button.png")
    instbutton.x = display.contentWidth/2
    instbutton.y = display.contentHeight - 100
    --Make the button do something
    instbutton:addEventListener("touch", displayInst)
end

function displayInst()
    if background ~= nil then
        background:removeSelf()
    end
    if button ~= nil then
        button:removeSelf()
    end
    if instbutton ~= nil then
        instbutton:removeSelf()
        instbutton = nil
    end
    if titleimg ~= nil then
        titleimg:removeSelf()
    end
    background = display.newImage("img/bg_day.png", true) --Background image, covers up all the black space
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2
    titleimg = display.newImage("img/instructions_screen.png", true) --Background image, covers up all the black space
    titleimg.x = display.contentWidth/2
    titleimg.y = display.contentHeight/2
    --Make a play button
    button = display.newImage("img/play_button.png")
    button.x = display.contentWidth - 128
    button.y = display.contentHeight - 32
    --Make the button do something
    button:addEventListener("touch", startGame)
    --Make buttons for page 1, 2, and 3 (hehehehe)
    button1 = display.newImage("img/1.png")
    button1.x = 64
    button1.y = display.contentHeight - 32
    button2 = display.newImage("img/2.png")
    button2.x = 128
    button2.y = display.contentHeight - 32
    button3 = display.newImage("img/3.png")
    button3.x = 192
    button3.y = display.contentHeight - 32
    --Make the buttons do something
    button1:addEventListener("touch", button1act)
    button2:addEventListener("touch", button2act)
    button3:addEventListener("touch", button3act)
end

function button1act()
    titleimg:removeSelf()
    titleimg = display.newImage("img/instructions_screen.png", true)
    titleimg.x = display.contentWidth/2
    titleimg.y = display.contentHeight/2
    titleimg:toBack()
    background:toBack()
end

function button2act()
    titleimg:removeSelf()
    titleimg = display.newImage("img/instructions_screen2.png", true)
    titleimg.x = display.contentWidth/2
    titleimg.y = display.contentHeight/2
    titleimg:toBack()
    background:toBack()
end

function button3act()
    titleimg:removeSelf()
    titleimg = display.newImage("img/instructions_screen3.png", true)
    titleimg.x = display.contentWidth/2
    titleimg.y = display.contentHeight/2
    titleimg:toBack()
    background:toBack()
end

function gameOvar()
    background = display.newImage("img/bg_night.png", true) --Background image, covers up all the black space
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2
    titleimg = display.newImage("img/game_over.png", true) --Background image, covers up all the black space
    titleimg.x = display.contentWidth/2
    titleimg.y = display.contentHeight/2
end

function youWin()
    clearEverything()
    background = display.newImage("img/bg_day.png", true) --Background image, covers up all the black space
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2
    titleimg = display.newImage("img/youwin.png", true) --Background image, covers up all the black space
    titleimg.x = display.contentWidth/2
    titleimg.y = display.contentHeight/2
    
    timer.performWithDelay(3000, displayMenu, 1)
end

function nextLevel()
    --[[background = display.newImage("img/bg_day.png", true) --Background image, covers up all the black space
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2]]
    titleimg = display.newImage("img/nextlevel.png", true) --Background image, covers up all the black space
    titleimg.x = display.contentWidth/2
    titleimg.y = display.contentHeight/2
end

function endLevelFailure()
    print("you have lost the game")
    clearEverything()
    gameOvar()
    timer.performWithDelay(2000, displayMenu, 1)
end

function endLevelSuccess()
    print_d("you have won the game")
    print_d(balloon.img.rain)
    clearEverything()
    nextLevel()
    timer.performWithDelay(2000, clearNextLevel, 1)
    loadLevel()
    timer.performWithDelay(2000, startupagain, 1)
    
end

function startupagain()
    if startlevel <= maxlevel then
        timer.performWithDelay(33, update, 0)
    end
end

function clearNextLevel()
    if titleimg ~= nil then
        titleimg:removeSelf()
        titleimg = nil
    end
end


--sound effects
sounds = {
    music1 = audio.loadSound("level1song.mp3"),
    music2 = audio.loadSound("level2song.mp3"),
    music3 = audio.loadSound("level3song.mp3"),
    music4 = audio.loadSound("level4song.mp3"),
    drill_cloud = audio.loadSound("test.wav"),
    lightning = audio.loadSound("lightning.wav"),
    emp = audio.loadSound("emp.wav"),
    fire = audio.loadSound("fire.wav"),
    rain = {audio.loadSound("rain1.wav"), audio.loadSound("rain2.wav"), audio.loadSound("rain3.wav"), audio.loadSound("rain4.wav")}
}

backgroundmusichannel = audio.findFreeChannel()


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
droneList = {}

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
    print_d("LOADING...")
    --start by clearing the level
    levelList={}
    num_frames = 0
    startlevel = startlevel + 1
    if(startlevel > maxlevel) then
        --print_d ("no more levels to load")
        youWin()
        return
    end
    local pathval = (levelkey[1] .. startlevel .. levelkey[2])
    local path = system.pathForFile(pathval)
    --Print the whole file
    --local file = io.input(path, "r")
    --local levelVal = file:read("*a")
    --print_d("LEVEL"..levelVal)
    --Carry on...
    local file = io.input(path, "r")
    --first get our level
    local levelVal = file:read("*l")
    --print_d("levelVal: "..levelVal)
    local levelDescription = Split(levelVal, delimiter)
    --set the description of the level
    levelList[levelDescription[1]] = {levelDescription[2], levelDescription[3]}
    --set the variables for this level
    rainRequirement = 0 + levelDescription[3]--force number
    --print_d(rainRequirement)
    levelTime = 0 + levelDescription[2]--force number, in frames
    --print_d(levelTime)
    --establish variable to decide whether or not we are done reading
    local eof = false
    local wave = {}
    local obj = {}
    wave["time"] = 0
    local fullLine = file:read("*l")
    --print_d("fullLine = "..fullLine)
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
            print_d("A wave is going to start at "..wave["time"])
        elseif (splitLine[1] == "Cloud") then--cloud, x pos, y pos, speed
            obj={}
            table.insert(obj, splitLine[1])
            table.insert(obj, splitLine[2])
            table.insert(obj, splitLine[3])
            table.insert(obj, splitLine[4])
            table.insert(obj, splitLine[5])
            table.insert(wave, obj)
            print_d("Cloud at "..splitLine[2]..", "..splitLine[3])
        elseif (splitLine[1] == "Bird") then--bird, x pos, y pos, speed
            obj={}
            table.insert(obj, splitLine[1])
            table.insert(obj, splitLine[2])
            table.insert(obj, splitLine[3])
            table.insert(obj, splitLine[4])
            table.insert(wave, obj)
            print_d("Bird at "..splitLine[2]..", "..splitLine[3])
        else
            print_d("error reading file")
            print_d("fullLine = "..fullLine)
            table.insert(levelList, wave["time"], wave)
        end
        
        fullLine = file:read("*l")
        if fullLine ~= nil then
            --print_d("fullLine = "..fullLine)
        end
    end
    
    wave={}
    obj={}
    -- file:close()

    sunset = display.newImage("img/bg_night.png", true)
    sunset.alpha = 0
    sunset.x = display.contentWidth/2
    sunset.y = display.contentHeight/2
    transition.to(sunset, {time = 60000, alpha = 1})

    balloon = Player:new(200,240)

    emp_button = display.newImage("img/emp_button.png")
    emp_button.x = 32
    emp_button.y = display.contentHeight - 16
    emp_button:addEventListener("touch", useEMP)
    fire_button = display.newImage("img/fire_button.png")
    fire_button.x = display.contentWidth - 32
    fire_button.y = display.contentHeight - 16
    fire_button:addEventListener("touch", useFire)
    --Setup for rain counter
    --raincount = display.newText("Rain Collected: "..balloon.img.rain.."/"..rainRequirement, 80, display.contentHeight-32, native.systemFont, 32)
    raincount = display.newImage("img/rainbar.png")
    raincount.xScale = 1
    raincount.x = display.contentWidth/2
    raincount.y = display.contentHeight - 24
    rainbase = display.newImage("img/status_bar.png")
    rainbase.x = display.contentWidth/2
    rainbase.y = display.contentHeight - 24
    local soundCue = "music"
    local soundCue2 = soundCue..startlevel
    
    backgroundmusichannel = audio.play(sounds[soundCue2], {loops=-1})

end

--Update, happens every frame
function update(event)
    num_frames = num_frames + 1
    populate(event)
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
        if (aCloud.mood == "sad" and ( (num_frames - aCloud.hitFrame) < aCloud.hitDiff )) or aCloud.frozen then
            table.insert(rainList, Rain:new(math.random(aCloud.img.x-aCloud.img.width/4, aCloud.img.x+aCloud.img.width/4), aCloud.img.y, aCloud.frozen))
        end
        if aCloud.mood == "angry" and math.random(1,45) == 1 then
            table.insert(boltList, Lightning:new(aCloud.img.x, aCloud.img.y, aCloud.img.x, aCloud.img.y + 1))
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
    --Fix rain
    if balloon.img.rain > 0 then
        raincount.xScale = (300*balloon.img.rain)/rainRequirement
    end
    if raincount.xScale >= 300 then
        raincount:removeSelf()
        raincount = display.newImage("img/rainbarfull.png")
        raincount.x = display.contentWidth/2
        raincount.y = display.contentHeight - 24
        raincount.xScale = 300
        rainbase:toFront()
        
    end
    --Finished updating? Now change the previous time
    lastFrameTime = event.time
    
    --check whether the level is over or not

    if balloon.img.cooldown > 0 or balloon.img.stuntime > 0 then
        emp_button.alpha = .25
        fire_button.alpha = .25
    else
        emp_button.alpha = 1
        fire_button.alpha = 1
    end
    
    checkLevel(event)
end

function populate(event)
    if (levelList[event.count] == nil) then
        return--then there is no wave at this time
    else
        print_d("waveFound")
        for index, value in ipairs(levelList[event.count]) do
            if (value[1] == "Cloud") then
                --print_d("inserting cloud")
                local newCloud = Cloud:new(value[2], value[3], value[4], value[5])
                table.insert(cloudList, newCloud)
            elseif (value[1] == "Bird") then
                --print_d("inserting bird")
                local newBird = Bird:new(value[2], value[3], value[4])
                table.insert(birdList, newBird)
            else
                return
            end
            
        end
    
    end

end

function checkLevel(event)
    if(event.count == levelTime) then
        timer.cancel(event.source)--cancel the timer
        if (balloon.img.rain >= rainRequirement) then
            endLevelSuccess()
        else
            --print("rain is "..balloon.img.rain.."and reqd is "..rainRequirement)
            endLevelFailure()
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
    if (event.object1.name == "drill" and event.object2.name ~= "cloud" and event.object2.name ~= "drone") or (event.object2.name == "drill" and event.object1.name ~= "cloud" and event.object1.name ~= "drone") then
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
        if not event.object1.frozen then
            event.object2.rain = event.object2.rain + 1
        end
        deleteImageFromTable(rainList, event.object1)
        audio.play(sounds.rain[math.random(1,4)])
        return
    elseif event.object2.name == "rain" and event.object1.name == "player" then
        if not event.object2.frozen then
            event.object1.rain = event.object1.rain + 1
        end
        deleteImageFromTable(rainList, event.object2)
        audio.play(sounds.rain[math.random(1,4)])
        return
    end

    -- crap and player
    if event.object1.name == "crap" and event.object2.name == "player" then
        deleteImageFromTable(crapList, event.object1)
        event.object2.rain = event.object2.rain - 5
        return
    elseif event.object2.name == "crap" and event.object1.name == "player" then
        deleteImageFromTable(crapList, event.object2)
        event.object1.rain = event.object1.rain - 5
        return
    end

    -- lightning and player
    if event.object1.name == "lightning" and event.object2.name == "player" then
        deleteImageFromTable(boltList, event.object1)
        event.object2.stuntime = 30
        audio.play(sounds.lightning)
        return
    elseif event.object2.name == "lightning" and event.object1.name == "player" then
        deleteImageFromTable(boltList, event.object2)
        event.object1.stuntime = 30
        audio.play(sounds.lightning)
        return
    end

    

end


function useEMP()
    if balloon.img.stuntime > 0 or balloon.img.cooldown > 0 then
        return
    end
    print_d("EMP")
    audio.play(sounds.emp)
    emp_image = display.newImage("img/empring.png", true)
    emp_image.x = balloon.img.x
    emp_image.y = balloon.img.y
    emp_image.xScale = .1
    emp_image.yScale = .1
    transition.to(emp_image, {time = 500, xScale = 2, yScale = 2, alpha = 0.0})
    balloon.img.cooldown = 150
    for key,aBolt in pairs(boltList) do
        aBolt.img:removeSelf()
        table.remove(boltList, key)
    end
    for key,aCloud in pairs(cloudList) do
        while aCloud.mood == "angry" do
            aCloud.img:takeDrillHit(num_frames)
        end
    end
end

function useFire()
    if balloon.img.stuntime > 0 or balloon.img.cooldown > 0 then
        return
    end
    print_d("FIRE")
    audio.play(sounds.fire)
    fire_image = display.newImage("img/firering.png")
    fire_image.x = balloon.img.x
    fire_image.y = balloon.img.y
    fire_image.xScale = .1
    fire_image.yScale = .1
    transition.to(fire_image, {time = 500, xScale = 2, yScale = 2, alpha = 0.0})
    balloon.img.cooldown = 150
    for key,aRain in pairs(rainList) do
        aRain:thaw()
    end
    for key,aCloud in pairs(cloudList) do
        aCloud.frozen = false
    end
end




--What happens if we touch the screen
function onTouch(event)
    if num_frames == 0 then
        return
    end
    aimposx = event.x
    aimposy = event.y
    if balloon.img.stuntime == 0 then
        if drillCooldown <= 0 and event.phase == "began" then
            table.insert(drillList, Drill:new(balloon.img.x, balloon.img.y, aimposx, aimposy))
            drillCooldown = maxDrillDelay
        end
    end
end
local function onAccel(event)
    if num_frames == 0 then
        return
    end
    balloon:movement(event, event.yGravity)
end


--Put our event listeners here!
function startListeners()
    Runtime:addEventListener("accelerometer", onAccel)
    -- Runtime:addEventListener("enterFrame", update)
    Runtime:addEventListener("touch", onTouch)
    Runtime:addEventListener("collision", onCollision)
    --start our timer
    
end

--And now the actual main code:
startListeners()
displayMenu()
