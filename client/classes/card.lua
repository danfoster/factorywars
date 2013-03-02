local Class = require("hump.class")

Program = {UTurn = 0,
           RotateRight = 1,
           RotateLeft = 2,
           BackUp = 3,
           Move1 = 4,
           Move2 = 5,
           Move3 = 6}
           
local Card = Class {
}
function Card:init(priority, program, image)
    self.id = priority
    self.priority = priority
    self.program = program
    self.icon = image or love.graphics.newImage('data/objects/card.png')
end

return Card
