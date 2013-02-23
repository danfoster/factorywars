local Class = require("hump.class")
local Camera = require("hump.camera")
local ATL = require("AdvTiledLoader") 

local Game = Class {
}

function Game:init()
    self.cam = Camera()
    ATL.Loader.path = 'data/boards/'
    self.level = ATL.Loader.load("test2.tmx") 
    self.updatingView = false
    self.oldMouseX = 0
    self.oldMouseY = 0
    self.viewX = 0
    self.viewY = 0
end

function Game:enter()
end

function Game:draw()
    love.graphics.translate( self.viewX, self.viewY )
    self.level:autoDrawRange( self.viewX, self.viewY, 1, pad)
    self.level:draw()
end


function Game:update(dt)
    if self.updatingView then
        self.viewX = self.viewX + (love.mouse.getX() - self.oldMouseX) 
        self.viewY = self.viewY + (love.mouse.getY() - self.oldMouseY) 
        self.oldMouseX = love.mouse.getX()
        self.oldMouseY = love.mouse.getY()
    end
end

function Game:mousepressed(x,y,button)
    if button == 'r' then
        self.updatingView = true
        self.oldMouseX = x
        self.oldMouseY = y
    end
end

function Game:mousereleased(x,y,button)
    if button == 'r' then
        self.updatingView = false
    end
end

return Game


