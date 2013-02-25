local Class = require("hump.class")

local Robot = Class {
}

local direction = {right = 1, up = 2, left = 3, down = 4}

function Robot:init(level, x, y, orient, image)
    self.level = level
    self.x = x
    self.y = y
    self.orient = orient
    self.icon = image or love.graphics.newImage('data/tiles/raw/robot.png')
end

function Robot:draw()
    local tw = self.level.tileWidth
    local th = self.level.tileHeight
    love.graphics.draw(self.icon, (self.x + 0.5) * tw, (self.y + 0.5) * th, (math.pi * 2 / 4) * (self.orient - 1), 1, 1, tw / 2, th / 2)
end

-- returns the position the robot would be in if the given movement were made
-- strafe is optional, negative strafe for left, positive for right
function Robot:move(distance, strafe)
    strafe = strafe or 0
    
    local x, y
    
    if self.orient == 4 then
        x = self.x + strafe 
        y = self.y - distance  
    elseif self.orient == 3 then
        y = self.y - strafe
        x = self.x - distance
    elseif self.orient == 2 then
        x = self.x - strafe 
        y = self.y + distance 
    elseif self.orient == 1 then
        y = self.y + strafe
        x = self.x + distance
    end
    
    return x, y
end

-- returns the orientation the robot would be in if rotated by the given amount
function Robot:rotate(amount)
    return ((self.orient + amount - 1) % 4) + 1
end

return Robot
