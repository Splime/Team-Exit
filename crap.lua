module(..., package.seeall)


-- collisions
-- physics
-- update gravity based on time


function new(obj, x, y)

    local crapobj = { img = display.newImage("img/crap.png"), speed = 4}
    -- set location
    crapobj.img.x = x
    crapobj.img.y = y

    -- set scale
    crapobj.img.xScale = 5
    crapobj.img.yScale = 5



    
    --Update Function
    function crapobj:update(self, event)
        -- update speed based on gravity
        crapobj.speed = crapobj.speed + .1

        -- update location
        crapobj.img.y = crapobj.img.y + crapobj.speed

        -- delete self if offscreen
        if crapobj.img.y > display.contentHeight then
            crapobj.img:removeSelf()
            return false
        end


        -- do not remove this
        return true
    end
    
    -- event listeners
    Runtime:addEventListener("enterFrame", crapobj.update)

    return crapobj

end
