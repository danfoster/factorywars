local Class = require("hump.class")
local Vector = require("hump.vector")
local easing = require("easing.easing")

local Robot = Class {
}

local direction = {right = 0, up = 1, left = 2, down = 3}

local vectors = {
    [0] = Vector( 1,  0),
    [1] = Vector( 0,  1),
    [2] = Vector(-1,  0),
    [3] = Vector( 0, -1),
}

Robot.animations = {
    wait       = {1, "", function(t, o) return 0, 0, 0 end},

    turnRight  = {1, "", function(t, o) return 0, 0,  1 * t end},
    turnLeft   = {1, "", function(t, o) return 0, 0, -1 * t end},
    turnAround = {1, "", function(t, o) return 0, 0, -2 * t end},

    graceStartF = {0.5, "", function(t, o) local x, y = ( vectors[o] / 2 * easing.inQuad(t, 0, 1, 1)):unpack() return x, y, 0 end},
    graceStartB = {0.5, "", function(t, o) local x, y = (-vectors[o] / 2 * easing.inQuad(t, 0, 1, 1)):unpack() return x, y, 0 end},

    graceStopF = {0.5, "", function(t, o) local x, y = ( vectors[o] / 2 * easing.outQuad(t, 0, 1, 1)):unpack() return x, y, 0 end},
    graceStopB = {0.5, "", function(t, o) local x, y = (-vectors[o] / 2 * easing.outQuad(t, 0, 1, 1)):unpack() return x, y, 0 end},

    continueF = {0.5, "", function(t, o) local x, y = ( vectors[o] * t):unpack() return x, y, 0 end},
    continueB = {0.5, "", function(t, o) local x, y = (-vectors[o] * t):unpack() return x, y, 0 end},
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
        type = "graceStartF",
        time = 0,
    }
end

function Robot:update(dt)
    self:animate(dt)
end

function Robot:animate(dt)
    local duration, image, easing = unpack(self.animations[self.animation.type])

    self.animation.time = math.min(self.animation.time + dt, duration)

    if self.animation.time == duration then
        local dx, dy, do_ = easing(1, self.orientation)

        self.x, self.y = self.x + dx, self.y + dy 
        self.orientation = self.orientation + do_

        self.animation.time = 0

        if self.animation.type == "graceStartF" then
            self.animation.type = "continueF"
        elseif self.animation.type == "continueF" then
            self.animation.type = "graceStopF"
        else
            self.animation.type = "wait"
        end
    end
end

function Robot:draw()
    local duration, image, easing = unpack(self.animations[self.animation.type])
    local dx, dy, do_ = easing(self.animation.time / duration, self.orientation)

    local x, y = self.x + dx, self.y + dy
    local orientation = self.orientation + do_

    love.graphics.draw(self.icon, 
                       (x + 0.5) * self.tileWidth, (y + 0.5) * self.tileHeight,
                       orientation * (math.pi * 2 / 4), 
                       1, 1, 
                       self.tileWidth / 2, self.tileHeight / 2)
end

return Robot
