-- emp filler

module(..., package.seeall)

function new(boom, zx, zy)
    local bomb = { img = display.newImage("img/player_sub.png")}
    balloon.img.x = zx
    balloon.img.y = zy
    balloon.img.xScale = 0.5
    balloon.img.yScale = 0.5
end