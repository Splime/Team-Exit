module(..., package.seeall)


-- collisions
-- physics
-- update gravity based on time


function new(obj, x, y, frz)

    local rainobj = { img = display.newImage("img/raindrop.png"), speed = 4}
    if frz then
        rainobj.img = display.newImage("img/snowflake.png")
        rainobj.speed = 2
    end
    rainobj.img.name = "rain"
    rainobj.img.frozen = frz
    -- set location
    rainobj.img.x = x
    rainobj.img.y = y

    -- set scale
    rainobj.img.xScale = 1
    rainobj.img.yScale = 1


    function rainobj:thaw(self)
        if not rainobj.img.frozen then
            return
        end
        x = rainobj.img.x
        y = rainobj.img.y
        rainobj.img:removeSelf()
        rainobj.img = display.newImage("img/raindrop.png")
        rainobj.img.name = "rain"
        rainobj.img.x = x
        rainobj.img.y = y
        rainobj.img.frozen = false
        physics.addBody(rainobj.img)
    end
    
    --Update Function
    function rainobj:update(self, event)
        -- update speed based on gravity
        if not rainobj.img.frozen then
            rainobj.speed = rainobj.speed + .1
        end

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
