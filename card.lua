local Class = require("hump.class")

local Card = Class {
}

function Card:init(priority, dist, rotate, image)
    self.priority = priority
    self.dist = dist
    self.rotate = rotate or 0
    self.icon = image or love.graphics.newImage('data/tiles/raw/card.png')
end