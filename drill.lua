module(..., package.seeall)

--defDrill = {x = 0, y = 0, xvcomp = 1, xycomp = 0, speed = 1, img = display.newImage("img/detailed_cloud.png")}

function new(drizzil, ax, ay, degrees)--x and y are the location of the center, degrees is the 
    local drillobj = { img = display.newImage("img/drill_proxy.png"), speed = 3, x = ax, y = ay, xvcomp = math.cos(math.rad(degrees)), yvcomp = math.sin(math.rad(degrees)), speed = 1}
    drillobj.img.x = ax
    drillobj.img.y = ay
    drillobj.img.xScale = 1
    drillobj.img.yScale = 1
    
    --Update Function...
    function drillobj:update(drizzil, event)
        
        drillobj.x = drillobj.x + drillobj.xvcomp*drillobj.speed
        drillobj.y = drillobj.y + drillobj.yvcomp*drillobj.speed
        drillobj.img.x = drillobj.img.x + drillobj.xvcomp*drillobj.speed
        drillobj.img.y = drillobj.img.y + drillobj.yvcomp*drillobj.speed
        
        if drillobj.img.x < 0 or drillobj.img.x > display.contentWidth or 
            drillobj.img.y < 0 or drillobj.img.y > display.contentHeight then
            drillobj.img:removeSelf()
            return false
        end
        
        return true
    
    end
    
    physics.addBody(drillobj.img, {density = 1, friction = 1, bounce = 1})
    
    return drillobj
    
end

