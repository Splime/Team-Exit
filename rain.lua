module(..., package.seeall)


-- collisions
-- physics
-- update gravity based on time


function new(obj, x, y, onCollision)

    local rainobj = { img = display.newImage("img/rain.png"), speed = 4}
    rainobj.name = "rain"
    -- set location
    rainobj.img.x = x
    rainobj.img.y = y

    -- set scale
    rainobj.img.xScale = 2
    rainobj.img.yScale = 2



    
    --Update Function
    function rainobj:update(self, event)
        -- update speed based on gravity
        rainobj.speed = rainobj.speed + .1

        -- update location
        rainobj.img.y = rainobj.img.y + rainobj.speed

        -- delete self if offscreen
        if rainobj.img.y > display.contentHeight then
            rainobj.img:removeSelf()
            return false
        end


        -- do not remove this
        return true
    end
    
    physics.addBody(rainobj.img)
    rainobj.img.collision = onCollision
    rainobj.img:addEventListener("collision", rainobj.img)

    return rainobj

end
