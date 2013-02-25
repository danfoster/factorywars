local Class = require("hump.class")
local Camera = require("hump.camera")
local ATL = require("AdvTiledLoader") 
local Robot = require("robot")

local Game = Class {
}

function Game:init()
    self.cam = Camera()
    ATL.Loader.path = 'data/boards/'
    self.level = ATL.Loader.load("test2.tmx")
    self.updatingView = false
    self.oldMouseX = 0
    self.oldMouseY = 0 
    self.robots = {Robot(self.level, 2, 2, 1), Robot(self.level, 5, 5, 2)}
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
    
    -- robots
    for i = 1, # self.robots do
        self.robots[i]:draw()
    end
    
    
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
    local x = self.robots[1].x
    local y = self.robots[1].y
    local o = self.robots[1].orient
    if key == "w" then
        x,y = self.robots[1]:move(1)
    elseif key == "a" then
        x,y = self.robots[1]:move(0, -1)
    elseif key == "s" then
        o = self.robots[1]:rotate(2)
    elseif key == "d" then
        x,y = self.robots[1]:move(0, 1)
    elseif key == "q" then
        o = self.robots[1]:rotate(-1)
    elseif key == "e" then
        o = self.robots[1]:rotate(1)    
    elseif key == "rctrl" then
        debug.debug()
    end
    self.robots[1].x = x
    self.robots[1].y = y
    self.robots[1].orient = o
end

return Game


