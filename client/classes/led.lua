local Class = require("hump.class")

local Led = Class {}

function Led:init(x, y)
    self.image = love.graphics.newImage("data/hud/led.png")
    self.x = x
    self.y = y

    self.color = {25,25,25,255}
end

function Led:draw()
    love.graphics.setColor(self.color)
    love.graphics.draw(self.image,self.x,self.y)
end

function Led:setColor(r,g,b,a)
    self.color = {r,g,b,a}
end

return Led


