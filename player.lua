module(..., package.seeall)

--defCloud = {img = display.newImage("img/detailed_cloud.png"), speed = 1}

function new(playa, zx, zy)
    local balloon = { img = display.newImage("img/player_sub.png"), speed = 0}
    balloon.img.x = zx
    balloon.img.y = zy
    balloon.img.xScale = 0.5
    balloon.img.yScale = 0.5
    
    --Update Function...
    function balloon:update(playa, event, speed)
        balloon.img.x = balloon.img.x + balloon.speed
    end
    
    
  --Runtime:addEventListener("enterFrame", cloudobj.update)

   -- physics.addBody(balloon.img, {density = 1, friction = 1, bounce = 1})
    
    return balloon

end

function movement(event, accel)
    balloon.speed = (zx * event.yGravity * -1)
end