local Class = require("hump.class")
local Camera = require("hump.camera")
local Robot = require("classes.robot")
local Card = require("classes.card")
local Deck = require("classes.deck")
local Networking = require("classes.networking")
local Level = require("classes.level")
local Client = require("classes.client")

local Game = Class {
}

function Game:init(host, port)
    self.cam = Camera()
    self.level = Level()
    self.updatingView = false
    self.oldMouseX = 0
    self.oldMouseY = 0 
    
    
    -- test code
    local port = port or 1234
    local host = host or "localhost"
    self.networking = Networking()
    self.networking:connect(host, port)
    local data = self.networking:receive() 
    if data then
        local cards = {}
        for k,v in pairs(data['value']) do
            local card = Card(v['id'],v['priority'],v['program'])
            cards[card.id] = card
        end
        self.deck = Deck(cards)
    end
    self.networking:send({ command= ClientCommands.MyNameIs , value= "my local client" })
    self.robot = Robot(2, 2, 1,nil,self.level.level.tileWidth, self.level.level.tileHeight)
    self.networking:setTimeout(0.001)
    self.client = Client(self.deck)
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
        self:_handleNetworkCommand(data['command'],data['value'])
    end

    -- Update Camera
    if self.updatingView then
        self.cam.x = self.cam.x - (love.mouse.getX() - self.oldMouseX)/self.cam.scale 
        self.cam.y = self.cam.y - (love.mouse.getY() - self.oldMouseY)/self.cam.scale
        self.oldMouseX = love.mouse.getX()
        self.oldMouseY = love.mouse.getY()
    end
end

function Game:_handleNetworkCommand(command,value)
    if command == ServerCommands.DealProgramCards then
        self.client:receiveHand(value)
    else
        print("WARNING: Received unknown server command: " .. data['command'])
    end

end

function Game:quit()
    self.networking:close()
end

return Game

