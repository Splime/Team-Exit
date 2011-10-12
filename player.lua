module(..., package.seeall)

function new(playa, zx, zy)
    local balloon = { speed = 0}
    balloon.img = sprite.newSprite(playerSet)
    balloon.img:prepare("idle")
    balloon.img:play()
    balloon.img.name = "player"
    balloon.img.rain = 0
    balloon.img.stuntime = 0
    balloon.img.cooldown = 0

    balloon.img.x = zx
    balloon.img.y = zy

    balloon.direction = 1
    balloon.state = "right"
    
    function balloon:newlevel()
        balloon.img.rain = 0
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

        if balloon.direction * balloon.speed < 0 then
            balloon.direction = balloon.direction * -1
            if balloon.state == "left" then
                balloon.state = "right"
            else
                balloon.state = "left"
            end
            balloon.img:prepare(balloon.state)
            balloon.img:play()
        end

    end

    function balloon:movement(event, accel)
        --Some debug accels
        --local accel = .2
        local maxSpeed = 20
        local minSpeed = -20
        balloon.speed = (-40 * accel)
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

