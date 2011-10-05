module(..., package.seeall)

defDrill = {x = 0, y = 0, xvcomp = 1, xycomp = 0, speed = 1, img = display.newImage("img/detailed_cloud.png")}

function new(x, y, degrees)--x and y are the location of the center, degrees is the 
    local drillobj = { img = display.newImage("img/detailed_cloud.png"), speed = 3, x = x, y = y, xvcomp = math.cos(degrees), yvcomp = math.sin(degrees), speed = 1}
    drillobj.img.x = x
    drillobj.img.y = y
    drillobj.img.xScale = 1
    drillobj.img.yScale = 1
    
    setmetatable(drill, { __index = defDrill } )
    
    --Update Function...
    function drillobj:update(event)
        cloudobj.img.y = cloudobj.img.y + cloudobj.speed
    end
    
    function drillobj:update()
        
        drillobj.x += drillobj.xvcomp*drillobj.speed
        drillobj.y += drillobj.yvcomp*drillobj.speed
        drillobj.img.x += drillobj.xvcomp*drillobj.speed
        drillobj.img.y += drillobj.yvcomp*drillobj.speed
    
    end
    
    
    
    return drillobj
    
end

