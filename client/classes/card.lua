local Class = require("hump.class")

local Card = Class {
}

-- negative strafe for left, positive for right
function Card:init(priority, forward, strafe, rotate, image)
    self.priority = priority
    self.forward = forward or 0
    self.strafe = strafe or 0
    self.rotate = rotate or 0
    self.icon = image or love.graphics.newImage('data/objects/card.png')
end

return Card