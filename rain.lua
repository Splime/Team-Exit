module(..., package.seeall)


-- collisions
-- physics
-- update gravity based on time


function new(obj, x, y, frz)

    local rainobj = { img = display.newImage("img/raindrop.png"), speed = 4}
    rainobj.img.name = "rain"
    rainobj.img.frozen = frz
    -- set location
    rainobj.img.x = x
    rainobj.img.y = y

    -- set scale
    rainobj.img.xScale = 1
    rainobj.img.yScale = 1



    
    --Update Function
    function rainobj:update(self, event)
        -- update speed based on gravity
        rainobj.speed = rainobj.speed + .1

        -- update location
        rainobj.img.y = rainobj.img.y + rainobj.speed

        -- delete self if offscreen
        if outOfBounds(rainobj) then
            rainobj.img:removeSelf()
            return false
        end


        -- do not remove this
        return true
    end
    
    physics.addBody(rainobj.img)

    return rainobj

end
