local Class = require("hump.class")

local Robot = Class {
}

local direction = {right = 0, up = 1, left = 2, down = 3}

local vectors = {
    [0] = { 1,  0},
    [1] = { 0,  1},
    [2] = {-1,  0},
    [3] = { 0, -1},
}

function Robot:init(x, y, orientation, image, tileWidth, tileHeight)
    self.x, self.y = x, y
    self.orientation = orientation

    self.icon = image or love.graphics.newImage('data/objects/01_robot.png')

    self.tileWidth = tileWidth
    self.tileHeight = tileHeight

    self.damage = 0
    self.lives = 3
    self.powerDown = false

    -- see animation notes.txt in assets
    self.animation = {
        type = "gracefulStartForward",
        time = 0,
    }
end

function Robot:update(dt)
    self:animate(dt)
end

function Robot:animate(dt)
    self.animation.time = math.min(self.animation.time + dt, 1)

    if self.animation.time == 1 then
        self.actions[self.animation.type](self)
    end
end

function Robot:draw()
    self.animations[self.animation.type](self, self.animation.time)
end

Robot.animations = {}
Robot.actions = {}

function Robot.actions:wait()
end

function Robot.animations:wait(time)
    local x, y = self.x, self.y
    love.graphics.draw(self.icon, (x + 0.5) * self.tileWidth, (y + 0.5) * self.tileHeight, (math.pi * 2 / 4) * self.orientation, 1, 1, self.tileWidth / 2, self.tileHeight / 2)
end

function Robot.actions:turnLeft()
    self.orientation = (self.orientation - 1) % 4
end

function Robot.animations:turnLeft(time)
    local x, y = self.x, self.y
    local orientation = self.orientation - time

    love.graphics.draw(self.icon, (x + 0.5) * self.tileWidth, (y + 0.5) * self.tileHeight, (math.pi * 2 / 4) * orientation, 1, 1, self.tileWidth / 2, self.tileHeight / 2)
end

function Robot.actions:turnRight()
    self.orientation = (self.orientation + 1) % 4
end

function Robot.animations:turnRight(time)
    local x, y = self.x, self.y
    local orientation = self.orientation + time

    love.graphics.draw(self.icon, (x + 0.5) * self.tileWidth, (y + 0.5) * self.tileHeight, (math.pi * 2 / 4) * orientation, 1, 1, self.tileWidth / 2, self.tileHeight / 2)
end

function Robot.actions:turnAround()
    self.orientation = (self.orientation + 2) % 4
end

function Robot.animations:turnAround(time)
    local x, y = self.x, self.y
    local orientation = self.orientation + 2 * time

    love.graphics.draw(self.icon, (x + 0.5) * self.tileWidth, (y + 0.5) * self.tileHeight, (math.pi * 2 / 4) * orientation, 1, 1, self.tileWidth / 2, self.tileHeight / 2)
end

function Robot.actions:gracefulStartForward()
    self.animation = {type = "gracefulStopForward", time = 0}
end

function Robot.animations:gracefulStartForward(time)
    local dx, dy = unpack(vectors[self.orientation])
    local x, y = self.x + dx / 2 * time, self.y + dy / 2 * time

    love.graphics.draw(self.icon, (x + 0.5) * self.tileWidth, (y + 0.5) * self.tileHeight, (math.pi * 2 / 4) * self.orientation, 1, 1, self.tileWidth / 2, self.tileHeight / 2)
end

function Robot.actions:gracefulStartBackwards()
end

function Robot.animations:gracefulStartBackwards(time)
    local dx, dy = unpack(vectors[self.orientation])
    local x, y = self.x - dx / 2 * time, self.y - dy / 2 * time

    love.graphics.draw(self.icon, (x + 0.5) * self.tileWidth, (y + 0.5) * self.tileHeight, (math.pi * 2 / 4) * self.orientation, 1, 1, self.tileWidth / 2, self.tileHeight / 2)
end

function Robot.actions:gracefulStopForward()
    local dx, dy = unpack(vectors[self.orientation])

    self.x, self.y = self.x + dx, self.y + dy
end

function Robot.animations:gracefulStopForward(time)
    local dx, dy = unpack(vectors[self.orientation])
    local x, y = self.x + dx / 2 * (time + 1), self.y + dy / 2 * (time + 1)

    love.graphics.draw(self.icon, (x + 0.5) * self.tileWidth, (y + 0.5) * self.tileHeight, (math.pi * 2 / 4) * self.orientation, 1, 1, self.tileWidth / 2, self.tileHeight / 2)
end

function Robot.actions:gracefulStopBackwards()
    local dx, dy = vectors[self.orientation]

    self.x, self.y = self.x - dx, self.y - dy
end

function Robot.animations:gracefulStopBackwards(time)
    local dx, dy = unpack(vectors[self.orientation])
    local x, y = self.x - dx / 2 * (time + 1), self.y - dy / 2 * (time + 1)

    love.graphics.draw(self.icon, (x + 0.5) * self.tileWidth, (y + 0.5) * self.tileHeight, (math.pi * 2 / 4) * self.orientation, 1, 1, self.tileWidth / 2, self.tileHeight / 2)
end

return Robot
