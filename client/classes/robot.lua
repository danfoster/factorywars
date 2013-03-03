local Class = require("hump.class")

local Robot = Class {
}

local direction = {right = 1, up = 2, left = 3, down = 4}

function Robot:init(x, y, orient, image, tileWidth, tileHeight)
    self.tileWidth = tileWidth
    self.tileHeight = tileHeight
    self.x = x
    self.y = y
    self.orient = orient
    self.damage = 0
    self.lives = 3
    self.powerDown = false
    self.icon = image or love.graphics.newImage('data/objects/01_robot.png')
end

function Robot:draw()
    love.graphics.draw(self.icon, (self.x + 0.5) * self.tileWidth, (self.y + 0.5) * self.tileHeight, (math.pi * 2 / 4) * (self.orient - 1), 1, 1, self.tileWidth / 2, self.tileHeight / 2)
end

return Robot
