module(..., package.seeall)


-- collisions
-- physics
-- update gravity based on time


function new(obj, x, y)

    local rainobj = { img = display.newImage("rain.png"), speed = 4}
    -- set location
    rainobj.img.x = x
    rainobj.img.y = y

    -- set scale
    rainobj.img.xScale = 5
    rainobj.img.yScale = 5



    
    --Update Function
    function rainobj:update(event)
        -- update speed based on gravity
        rainobj.speed = rainobj.speed + .1

        -- update location
        rainobj.img.y = rainobj.img.y + rainobj.speed

    end
    
    -- event listeners
    Runtime:addEventListener("enterFrame", rainobj.update)

    return rainobj

end
