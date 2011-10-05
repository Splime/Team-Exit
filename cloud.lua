module(..., package.seeall)

defCloud = {img = display.newImage("img/detailed_cloud.png"), speed = 1}

function new()
    local cloudobj = { img = display.newImage("img/detailed_cloud.png"), speed = 1}
    cloudobj.img.x = display.contentWidth / 2
    cloudobj.img.y = 0
    cloudobj.img.xScale = 1
    cloudobj.img.yScale = 1
    
    setmetatable(cloudobj, { __index = defCloud } )
    --print("creating cloud")
    
    --Update Function...
    function cloudobj:update(event)
        cloudobj.img.y = cloudobj.img.y + cloudobj.speed
    end
    
    
    Runtime:addEventListener("enterFrame", cloudobj.update)

    
    return cloudobj

end



