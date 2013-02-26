local Class = require("hump.class")
local Camera = require("hump.camera")
local ATL = require("AdvTiledLoader") 
local Robot = require("robot")
local Card = require("card")

local Game = Class {
}

function Game:init()
    self.cam = Camera()
    ATL.Loader.path = 'data/boards/'
    self.level = ATL.Loader.load("test2.tmx") 
    self.updatingView = false
    self.oldMouseX = 0
    self.oldMouseY = 0 
    
    -- test code
    self.robot = Robot(self.level, 2, 2, 1)
    self.fCard = Card(1, 1)
end

function Game:enter()
end

function Game:draw()
    self.cam:attach()
    camWorldWidth = love.graphics.getWidth() / self.cam.scale
    camWorldHeight = love.graphics.getHeight() / self.cam.scale
    camWorldX = self.cam.x - (camWorldWidth / 2)
    camWorldY = self.cam.y - (camWorldHeight / 2)
    self.level:setDrawRange(camWorldX, camWorldY, camWorldWidth, camWorldHeight)

    self.level:draw()
    
    self.robot:draw()
    
    self.cam:detach()
end

function Game:update(dt)
    if self.updatingView then
        self.cam.x = self.cam.x - (love.mouse.getX() - self.oldMouseX)/self.cam.scale 
        self.cam.y = self.cam.y - (love.mouse.getY() - self.oldMouseY)/self.cam.scale
        self.oldMouseX = love.mouse.getX()
        self.oldMouseY = love.mouse.getY()
    end
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
        local absolute = math.abs(card.forward)
        for i = 1, absolute do
            local x,y = robot:move(card.forward / absolute)
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

function Game:mousepressed(x,y,button)
    if button == 'r' then
        self.updatingView = true
        self.oldMouseX = x
        self.oldMouseY = y
    elseif button == 'wd' then
        self.cam.scale = math.max(self.cam.scale / 1.2, 0.1)
    elseif button == 'wu' then
        self.cam.scale = math.min(self.cam.scale * 1.1, 5)
    end
end

function Game:mousereleased(x,y,button)
    if button == 'r' then
        self.updatingView = false
    end
end

function Game:keypressed(key)
    local x = self.robot.x
    local y = self.robot.y
    local o = self.robot.orient
    if key == "w" then
        x,y = self.robot:move(1)
    elseif key == "a" then
        x,y = self.robot:move(0, -1)
    elseif key == "s" then
        o = self.robot:rotate(2)
    elseif key == "d" then
        x,y = self.robot:move(0, 1)
    elseif key == "q" then
        o = self.robot:rotate(-1)
    elseif key == "e" then
        o = self.robot:rotate(1)
    elseif key == "i" then
        self:executeCard(self.fCard, self.robot)
        x = self.robot.x
        y = self.robot.y
    end
    self.robot.x = x
    self.robot.y = y
    self.robot.orient = o
end

return Game


