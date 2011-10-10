module(..., package.seeall)

function new(playa, zx, zy)
    local balloon = { img = display.newImage("img/player_sub.png"), speed = 0}
    balloon.img.name = "player"
    balloon.img.rain = 0
    balloon.img.health = 100

    balloon.img.x = zx
    balloon.img.y = zy
    balloon.img.xScale = 0.5
    balloon.img.yScale = 0.5
    
    function balloon:newlevel()
        balloon.img.rain = 0
        balloon.img.health = 100
    end

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

    function balloon:movement(event, accel)
        balloon.speed = (balloon.img.x * accel)
    end
    
  --Runtime:addEventListener("enterFrame", cloudobj.update)

    physics.addBody(balloon.img, "static")
    
    return balloon

end

