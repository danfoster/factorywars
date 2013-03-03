local Class = require("hump.class")
local Camera = require("hump.camera")
local Robot = require("classes.robot")
local Card = require("classes.card")
local Deck = require("classes.deck")
local Networking = require("classes.networking")
local Level = require("classes.level")

local Game = Class {
}

function Game:init()
    self.cam = Camera()
    self.level = Level()
    self.updatingView = false
    self.oldMouseX = 0
    self.oldMouseY = 0 
    
    
    -- test code
    local host, port = "localhost", 1234
    self.networking = Networking()
    self.networking:connect(host, port)
    local data = self.networking:receive() 
    if data then
        self.cards = {}
        for k,v in pairs(data['value']) do
            table.insert(self.cards, Card(v['priority'], v['program']))
        end
        self.deck = Deck(self.cards)
    end
    self.networking:send({ command= ClientCommands.MyNameIs , value= "my local client" })
    self.robot = Robot(2, 2, 1,nil,self.level.level.tileWidth, self.level.level.tileHeight)
    self.networking:setTimeout(0.001)
end

function Game:executeCard(card, robot)
    if card.forward ~= 0 then
        local absolute = math.abs(card.forward)
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

function Game:draw()
    self.cam:attach()
    local camWorldWidth = love.graphics.getWidth() / self.cam.scale
    local camWorldHeight = love.graphics.getHeight() / self.cam.scale
    local camWorldX = self.cam.x - (camWorldWidth / 2)
    local camWorldY = self.cam.y - (camWorldHeight / 2)
    self.level.level:setDrawRange(camWorldX, camWorldY, camWorldWidth, camWorldHeight)

    self.level:draw()
    self.robot:draw()
    
    self.cam:detach()

end

function Game:update()
    -- Receive Network Commands
    local data = self.networking:receive() 
    if data then
        if data['command'] == ServerCommands.DealProgramCards then
            for k,v in pairs(data['value']) do
                print(k,v)
            end
        else
            print("WARNING: Received unknown server command: " .. data['command'])
        end
    end

    -- Update Camera
    if self.updatingView then
        self.cam.x = self.cam.x - (love.mouse.getX() - self.oldMouseX)/self.cam.scale 
        self.cam.y = self.cam.y - (love.mouse.getY() - self.oldMouseY)/self.cam.scale
        self.oldMouseX = love.mouse.getX()
        self.oldMouseY = love.mouse.getY()
    end
end

function Game:quit()
    self.networking:close()
end

return Game

