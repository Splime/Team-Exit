module(..., package.seeall)

function new(playa, zx, zy)
    local balloon = { img = display.newImage("img/player_sub.png"), speed = 0}
    balloon.img.name = "player"
    balloon.img.rain = 0
    balloon.img.health = 100
    balloon.img.stuntime = 0
    balloon.img.cooldown = 0

    balloon.img.x = zx
    balloon.img.y = zy
    
    function balloon:newlevel()
        balloon.img.rain = 0
        balloon.img.health = 100
        balloon.img.stuntime = 0
    end

    --Update Function...
    function balloon:update(playa, event, speed)
        if balloon.img.stuntime > 0 then
            balloon.img.stuntime = balloon.img.stuntime - 1
        end
        if balloon.img.cooldown > 0 then
            balloon.img.cooldown = balloon.img.cooldown - 1
        end

        balloon.img.x = balloon.img.x + balloon.speed
        if balloon.img.x <= 0 then
            balloon.img.x = 0
        end
        if balloon.img.x >= display.contentWidth then
            balloon.img.x = display.contentWidth
        end
    end

    function balloon:movement(event, accel)
        --Some debug accels
        --local accel = .2
        local maxSpeed = 10
        local minSpeed = -10
        balloon.speed = (-30 * accel)
        if balloon.speed > maxSpeed then
            balloon.speed = maxSpeed
        end
        if balloon.speed < minSpeed then
            balloon.speed = minSpeed
        end
    end
    
  --Runtime:addEventListener("enterFrame", cloudobj.update)

    physics.addBody(balloon.img, "static")
    
    return balloon

end
