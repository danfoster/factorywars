local Class = require("hump.class")
local Camera = require("hump.camera")
local Robot = require("classes.robot")
local Card = require("classes.card")
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
    local host, port = "127.0.0.1", 1234
    self.networking = Networking()
    self.networking:connect(host, port)
    local data = self.networking:receive()
    self.deck = {}
    for k,v in pairs(data['value']) do
        table.insert(self.deck, Card(v['priority'], v['program']))
    end
    -- for k,v in pairs(self.deck) do
        -- for ke,ve in pairs(v) do
            -- print(ke, ve)
        -- end
    -- end
    self.networking:send('{ "command": 0, "value": "my local client" }')
    self.networking:close()
    
    self.robot = Robot(2, 2, 1,nil,self.level.level.tileWidth, self.level.level.tileHeight)
    self.fCard = Card(1, 1)
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
return Game

