module(..., package.seeall)




function new(predatorizzle, anx, any, anspeed)
    local predatorobj = { img = display.newImage("img/temp_bird.png"), speed = anspeed}
    predatorobj.img.x = anx
    predatorobj.img.y = any
    predatorobj.img.xScale = 1
    predatorobj.img.yScale = 1
    



    --Update Function...
    function predatorobj:update(predatorizzle, event)
        birdobj.img.x = birdobj.img.x + birdobj.speed

        if outOfBounds(predatorobj) then
            predatorobj.img:removeSelf()
            return false
        end
        
        return true
    end
    
    

    
    return predatorobj

end
