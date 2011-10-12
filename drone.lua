module(..., package.seeall)



function new(droneizzle, anx, any, anspeed)
    local droneobj = { speed = anspeed, health = 1}
    droneobj.img = display.newImage("img/drone.png")
    droneobj.img.name = "drone"
    droneobj.img.x = anx
    droneobj.img.y = any
    
    
    
    function droneobj:update(droneizzle, event)
        
    end
end