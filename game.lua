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
    self.cam.scale = 1.0
    
end

function Game:enter()
end

function Game:draw()
    self.cam:attach()
    self.level:autoDrawRange( self.cam.x, self.cam.y, 1, 0)
    self.level:draw()
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

function Game:mousepressed(x,y,button)
    if button == 'r' then
        self.updatingView = true
        self.oldMouseX = x
        self.oldMouseY = y
    elseif button == 'wd' then
        self.cam.scale = self.cam.scale - 0.1
    elseif button == 'wu' then
        self.cam.scale = self.cam.scale + 0.1
    end
end

function Game:mousereleased(x,y,button)
    if button == 'r' then
        self.updatingView = false
    end
end

return Game


