module(..., package.seeall)

--defDrill = {x = 0, y = 0, xvcomp = 1, xycomp = 0, speed = 1, img = display.newImage("img/detailed_cloud.png")}

<<<<<<< HEAD

function new(drizzil, ax, ay, degrees, onCollision)--x and y are the location of the center, degrees is the 

    local drillobj = { img = display.newImage("img/drill_proxy.png"), speed = 3, x = ax, y = ay, xvcomp = math.cos(math.rad(degrees)), yvcomp = math.sin(math.rad(degrees)), speed = 1}
=======
function new(drizzil, ax, ay, tx, ty, onCollision)--x and y are the location of the center, degrees is the 
    local drillobj = { img = display.newImage("img/drill_proxy.png"), x = ax, y = ay}
    drillobj.speed = 200
>>>>>>> 0b3789ed56bf36874bd18110fb42efbc329b517e
    drillobj.img.name = "drill"
    drillobj.img.x = ax
    drillobj.img.y = ay
    drillobj.img.xScale = 1
    drillobj.img.yScale = 1
    
    --Update Function...
    function drillobj:update(drizzil, event)
        
        if drillobj.img.x < 0 or drillobj.img.x > display.contentWidth or 
            drillobj.img.y < 0 or drillobj.img.y > display.contentHeight then
            drillobj.img:removeSelf()
            return false
        end
        
        return true
    
    end
    
    physics.addBody(drillobj.img)
    --TODO: Adjust based on angle, etc.
    --local theta = math.atan((ty-ay)/(tx-ax))
    local vx = drillobj.speed * (tx-ax)/math.sqrt((tx-ax)^2+(ty-ay)^2)
    local vy = drillobj.speed * (ty-ay)/math.sqrt((tx-ax)^2+(ty-ay)^2)
    drillobj.img:setLinearVelocity(vx, vy)
    local theta = math.asin((ty-ay)/math.sqrt((tx-ax)^2+(ty-ay)^2))
    if tx-ax < 0 then
        theta = -theta
    end
    drillobj.img:rotate(math.deg(theta))
    print("rotated to "..(math.deg(theta)))
    drillobj.img.collision = onCollision
    drillobj.img:addEventListener("collision", drillobj.img)
    
    return drillobj
    
end

