module(..., package.seeall)

--defCloud = {img = display.newImage("img/detailed_cloud.png"), speed = 1}

function new(cloudizzle, anx, any, anspeed)
    local cloudobj = { img = display.newImage("img/detailed_cloud.png"), speed = anspeed}
    cloudobj.img.x = anx
    cloudobj.img.y = any
    cloudobj.img.xScale = 0.5
    cloudobj.img.yScale = 0.5
    
    setmetatable(cloudobj, { __index = defCloud } )
    --print("creating cloud")
    
    --Update Function...
    function cloudobj:update(cloudizzle, event)
        cloudobj.img.x = cloudobj.img.x + cloudobj.speed
    end
    
    
    --Runtime:addEventListener("enterFrame", cloudobj.update)

    
    return cloudobj

end



