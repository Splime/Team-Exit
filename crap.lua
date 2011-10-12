module(..., package.seeall)


-- collisions
-- physics
-- update gravity based on time


function new(obj, x, y)

    local crapobj = { img = display.newImage("img/poop.png"), speed = 4}
    crapobj.img.name = "crap"
    -- set location
    crapobj.img.x = x
    crapobj.img.y = y

    -- set scale
    crapobj.img.xScale = 1
    crapobj.img.yScale = 1



    
    --Update Function
    function crapobj:update(self, event)
        -- update speed based on gravity
        crapobj.speed = crapobj.speed + .1

        -- update location
        crapobj.img.y = crapobj.img.y + crapobj.speed

        -- delete self if offscreen
        if outOfBounds(crapobj) then
            crapobj.img:removeSelf()
            return false
        end


        -- do not remove this
        return true
    end
    

    physics.addBody(crapobj.img)

    return crapobj

end
