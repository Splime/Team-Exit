module(..., package.seeall)

--defDrill = {x = 0, y = 0, xvcomp = 1, xycomp = 0, speed = 1, img = display.newImage("img/detailed_cloud.png")}


function new(thor, ax, ay, tx, ty)--x and y are the location of the center, tx and ty are the target's location
    local bolt = { img = display.newImage("img/lightning.png"), x = ax, y = ay}
    bolt.speed = 250
    bolt.img.name = "lightning"
    bolt.img.x = ax
    bolt.img.y = ay
    bolt.img.xScale = 1
    bolt.img.yScale = 1
    
    --Update Function...
    function bolt:update(thor, event)
        
        if bolt.img.x < 0 or bolt.img.x > display.contentWidth or 
            bolt.img.y < 0 or bolt.img.y > display.contentHeight then
            bolt.img:removeSelf()
            return false
        end
        
        return true
    
    end
    
    physics.addBody(bolt.img)
    --TODO: Adjust based on angle, etc.
    --local theta = math.atan((ty-ay)/(tx-ax))
    local vx = bolt.speed * (tx-ax)/math.sqrt((tx-ax)^2+(ty-ay)^2)
    local vy = bolt.speed * (ty-ay)/math.sqrt((tx-ax)^2+(ty-ay)^2)
    bolt.img:setLinearVelocity(vx, vy)
    local theta = math.asin((ty-ay)/math.sqrt((tx-ax)^2+(ty-ay)^2))
    if tx-ax < 0 then
        theta = -theta
    end
    bolt.img:rotate(math.deg(theta))
    --print("rotated to "..(math.deg(theta)))
    
    return bolt
    
end
