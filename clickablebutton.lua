module(..., package.seeall)



function new(buttonizzil, ax, ay, width, height, text, function func)--x and y are the location of the center, degrees is the 
    local buttonobj = { x = ax, y = ay, width = width, height = height, text = text}
    buttonobj.rect = display.newRect(ax, ay, width, height)
    buttonobj.img.name = "drill"
    buttonobj.rect.x = ax
    buttonobj.rect.y = ay
    buttonobj.img.xScale = 1
    buttonobj.img.yScale = 1
    
    --Update Function...
    function buttonobj:click(buttonizzil, event)
        --if event.x < 
        
        return false
    end
    
    
    
    return buttonobj
    
end