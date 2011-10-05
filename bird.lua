module(..., package.seeall)




function new(birdizzle, anx, any, anspeed)
    local birdobj = { img = display.newImage("img/temp_bird.png"), speed = anspeed}
    birdobj.img.x = anx
    birdobj.img.y = any
    birdobj.img.xScale = 1
    birdobj.img.yScale = 1
    



    --Update Function...
    function birdobj:update(birdizzle, event)
        birdobj.img.x = birdobj.img.x + birdobj.speed

        if birdobj.img.x < 0 or birdobj.img.x > display.contentWidth then
            birdobj.img:removeSelf()
            return false
        end
        
        return true
    end
    
    

    
    return birdobj

end



