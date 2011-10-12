module(..., package.seeall)



function new(droneizzle, anx, any, anspeed)
    local droneobj = { speed = anspeed, health = 1}
    droneobj.img = display.newImage("img/drone.png")
    droneobj.img.name = "drone"
    droneobj.img.x = anx
    droneobj.img.y = any
    
    
    physics.addBody(droneobj.img)
    
    
    function droneobj:update(droneizzle, event, tx, ty)
        local vx = droneobj.speed * (tx-ax)/math.sqrt((tx-ax)^2+(ty-ay)^2)
        local vy = droneobj.speed * (ty-ay)/math.sqrt((tx-ax)^2+(ty-ay)^2)
        droneobj.img:setLinearVelocity(vx, vy)
        
    end
end