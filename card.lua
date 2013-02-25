local Class = require("hump.class")

local Card = Class {
}

function Card:init(dist, rotate, image)
    self.dist = dist
    self.rotate = rotate or 0
    self.icon = image or love.graphics.newImage('data/tiles/raw/card.png')
end