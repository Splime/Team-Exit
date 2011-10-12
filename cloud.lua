module(..., package.seeall)



function new(cloudizzle, anx, any, anspeed, mood)
    local cloudobj = { speed = anspeed, mood = mood, health = 1, angryThreshold = 7, happyThreshold = 7, frozen = false, hitFrame=0, hitDiff = 15}
    
    if mood == "angry" then
        cloudobj.img = sprite.newSprite(angryCloudSet)
        cloudobj.health = 10--
        cloudobj.frozen = false
        cloudobj.img:prepare("angry")
    elseif mood == "frozen" then
        cloudobj.img = sprite.newSprite(frozenCloudSet)
        cloudobj.mood = "happy"
        cloudobj.health = 9
        cloudobj.frozen = true
        cloudobj.img:prepare("happy")
    else--if the cloud is happy
        cloudobj.cloudType = math.random(1, 2)
        if cloudobj.cloudType == 1 then
            cloudobj.img = sprite.newSprite(happyCloudSet)
            cloudobj.img:prepare("happy")
        else
            cloudobj.img = sprite.newSprite(happyCloudSet2)
            cloudobj.img:prepare("happy2")
        end
        cloudobj.health = 9
        cloudobj.frozen = false
    end

    cloudobj.img.name = "cloud"
    cloudobj.img.x = anx
    cloudobj.img.y = any
    cloudobj.img:play()

    
    setmetatable(cloudobj, { __index = defCloud } )
    --print("creating cloud")
    
    --Update Function...
    function cloudobj:update(cloudizzle, event)
        cloudobj.img.x = cloudobj.img.x + cloudobj.speed
        if outOfBounds(cloudobj) then
            cloudobj.img:removeSelf()
            return false
        end
        return true
    end
    
    function cloudobj.img:takeDrillHit(num_frames)
        if cloudobj.frozen == true then
            return true
        end
        --otherwise the cloud is vulnerable to drills
        cloudobj.health = cloudobj.health-1
        cloudobj.hitFrame = num_frames
        if (cloudobj.mood == "sad") then
            if (cloudobj.health < 1) then
                return false
            end
            if cloudobj.cloudType ~= nil and cloudobj.cloudType == 2 then
                    cloudobj.img:prepare("cry2")
                else
                    cloudobj.img:prepare("cry")
                end
            cloudobj.img:play()
            return true
        elseif (cloudobj.mood == "angry") then--then that means they are not in danger of dying
            if(cloudobj.health < cloudobj.angryThreshold) then
                print_d("change to sad")
                cloudobj.mood = "sad"
                cloudobj.img:prepare("cry")
                cloudobj.img:play()
                return true
            end
        else
            if(cloudobj.health < cloudobj.happyThreshold) then
                print_d("change to sad")
                cloudobj.mood = "sad"
                cloudobj.img:prepare("cry")
                cloudobj.img:play()
            elseif cloudobj.health > cloudobj.happyThreshold then
                cloudobj.mood = "neutral"
                if cloudobj.cloudType ~= nil and cloudobj.cloudType == 2 then
                    cloudobj.img:prepare("neutral2")
                else
                    cloudobj.img:prepare("neutral")
                end
                cloudobj.img:play()
            else
                cloudobj.mood = "sad"
                if cloudobj.cloudType ~= nil and cloudobj.cloudType == 2 then
                    cloudobj.img:prepare("cry2")
                else
                    cloudobj.img:prepare("cry")
                end
                cloudobj.img:play()
            end
            return true
        end
            
    end
    
    --Runtime:addEventListener("enterFrame", cloudobj.update)

    physics.addBody(cloudobj.img, "static")

    return cloudobj

end



