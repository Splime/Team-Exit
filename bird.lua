module(..., package.seeall)




function new(birdizzle, anx, any, anspeed)
    local birdobj = { speed = anspeed}
    birdobj.img = sprite.newSprite(birdSet)
    if anspeed > "0" then
        birdobj.img:scale(-1,1)
    end
    birdobj.img.x = anx
    birdobj.img.y = any
    birdobj.img:prepare("birdfly")
    birdobj.img:play()

    
    --TODO: Adjust image based on direction!


    --Update Function...
    function birdobj:update(birdizzle, event)
        birdobj.img.x = birdobj.img.x + birdobj.speed

        if outOfBounds(birdobj) then
            birdobj.img:removeSelf()
            return false
        end
        
        return true
    end
    
    

    
    return birdobj

end



