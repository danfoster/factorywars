local Class = require("hump.class")
local Camera = require("hump.camera")
local ATL = require("AdvTiledLoader") 
local Robot = require("classes.robot")
local Card = require("classes.card")

local Game = Class {
}

function Game:init()
    self.cam = Camera()
    ATL.Loader.path = 'data/boards/'
    self.level = ATL.Loader.load("test2.tmx") 
    self:addEdges()
    self.updatingView = false
    self.oldMouseX = 0
    self.oldMouseY = 0 
    
    
    -- test code
    self.robot = Robot(self.level, 2, 2, 1)
    self.fCard = Card(1, 1)
end

function Game:addEdges()
    -- TODO: Added edges
end

function Game:turn()
    -- distribute cards
    -- arrange cards
    -- announce intent to power down or continue running next turn
    -- execute registers (card movements, board movements, interactions)
    -- end of turn effects
end

function Game:executeCard(card, robot)
    if card.forward ~= 0 then
        local absolute = abs(card.forward)
        for i = 1, absolute do
            x, y = robot:move(card.forward / absolute)
            -- TODO: function for checking collisions
            robot.x = x
            robot.y = y
        end
    end
    -- TODO: strafing
    if card.rotate ~= 0 then
        -- could do this in 90 degree increments if we want
        o = robot:rotate(card.rotate)
        robot.orient = o
    end
end

return Game

