module(..., package.seeall)

defCloud = {img = display.newImage("img/detailed_cloud.png"), speed = 1}

function new()
    local cloudobj = { img = display.newImage("img/detailed_cloud.png"), speed = 1}
    print(speed)
    cloudobj.img.x = 0
    cloudobj.img.y = 10
    cloudobj.img.xScale = 0.5
    cloudobj.img.yScale = 0.5
    
    setmetatable(cloudobj, { __index = defCloud } )
    --print("creating cloud")
    
    --Update Function...
    function cloudobj:update(event)
        cloudobj.img.x = cloudobj.img.x + cloudobj.speed
    end
    
    
    Runtime:addEventListener("enterFrame", cloudobj.update)

    
    return cloudobj

end



