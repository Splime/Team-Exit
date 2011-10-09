module(..., package.seeall)

function new(playa, zx, zy)
    local balloon = { img = display.newImage("img/player_sub.png"), speed = 0}
    balloon.img.name = "player"
    balloon.img.x = zx
    balloon.img.y = zy
    balloon.img.xScale = 0.5
    balloon.img.yScale = 0.5
    
    --Update Function...
    function balloon:update(playa, event, speed)
        balloon.img.x = balloon.img.x + balloon.speed
        if balloon.img.x <= 0 then
            balloon.img.x = 0
        end
        if balloon.img.x >= display.contentWidth then
            balloon.img.x = display.contentWidth
        end
    end
    
    function movement(event, accel)
        balloon.speed = (accel * -.5)
    end
    
  --Runtime:addEventListener("enterFrame", cloudobj.update)

    physics.addBody(balloon.img, "static")
    
    return balloon

end


