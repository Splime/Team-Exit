module(..., package.seeall)

function new()
    local cloudobj = { img = display.newImage("img/detailed_cloud.png"), speed = 1}
    print(speed)
    cloudobj.img.x = 0
    cloudobj.img.y = 10
    cloudobj.img.xScale = 0.5
    cloudobj.img.yScale = 0.5
    
    setmetatable(cloudobj, { __index = Cloud } )
    --print("creating cloud")
    
    --Update Function...
    function cloudobj:update(event)
        cloudobj.img.x = cloudobj.img.x + cloudobj.speed
    end
    
    function cloudobj:onGyroscopeUpdate(event)
        --code courtesy of ansca sample--
        local deltaRadians = event.zRotation * event.deltaTime
        local deltaDegrees = deltaRadians * (180 / math.pi)
        cloudobj.img.rotate(deltaDegrees)
    end
    
    Runtime:addEventListener("enterFrame", cloudobj.update)
    if system.hasEventSource("gyroscope") then
        Runtime:addEventListener("gyroscope", cloudobj.onGyroscopeUpdate)
    end
    
    return cloudobj

end



