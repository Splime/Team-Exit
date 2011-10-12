module(..., package.seeall)

--defDrill = {x = 0, y = 0, xvcomp = 1, xycomp = 0, speed = 1, img = display.newImage("img/detailed_cloud.png")}


function new(drizzil, ax, ay, tx, ty)--x and y are the location of the center, degrees is the 
    local drillobj = { x = ax, y = ay}
    drillobj.img = sprite.newSprite(drillSet)
    drillobj.img:prepare("drill")
    drillobj.img:play()
    drillobj.speed = 500
    drillobj.img.name = "drill"
    drillobj.img.x = ax
    drillobj.img.y = ay
    
    --Update Function...
    function drillobj:update(drizzil, event)
        
        if outOfBounds(drillobj) then
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
        drillobj.img:rotate(math.deg(theta)-90)
    else
        drillobj.img:rotate(math.deg(theta)+90)
    end
    --print("rotated to "..(math.deg(theta)))
    
    return drillobj
    
end

