module(..., package.seeall)



function new(buttonizzil, ax, ay, width, height, text)--x and y are the location of the center, degrees is the 
    local buttonobj = { x = ax, y = ay, width = width, height = height, text = text}
    drillobj.rect = display.newRect(ax, ay, display.contentWidth, display.contentHeight)
    drillobj.img.name = "drill"
    drillobj.rect.x = ax
    drillobj.rect.y = ay
    drillobj.img.xScale = 1
    drillobj.img.yScale = 1
    
    --Update Function...
    function drillobj:click(buttonizzil, event)
        
        
    
    end
    
    
    
    return drillobj
    
end