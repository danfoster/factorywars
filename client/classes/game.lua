local Class = require("hump.class")
local Camera = require("hump.camera")
local Robot = require("classes.robot")
local Card = require("classes.card")
local Deck = require("classes.deck")
local Networking = require("classes.networking")
local Level = require("classes.level")
local Client = require("classes.client")
local Hud = require("classes.hud")
local Player = require("classes.player")

local Game = Class {
}

function Game:init(host, port, nickname)
    self.cam = Camera()
    self.level = Level()
    self.updatingView = false
    self.oldMouseX = 0
    self.oldMouseY = 0 
    
    -- test code
    local port = port or 1234
    if host == '' then
        host = "localhost"
    end

    if nickname == "" then nickname = false end

    print('Connecting to ' .. host .. ' on port ' .. port)
    self.networking = Networking()
    self.networking:connect(host, port)

    self.client = Client(self.networking, self.deck)
    local names = {"TP2k", "WildFire", "2kah", "Ragzouken", "IRConan", "Jith"}
    local player = Player(self.client, nickname or names[math.random(1, 6)])
    
    local data = self.networking:receive() 
    if data then
        local cards = {}
        for k,v in pairs(data['value']) do
            local card = Card(v['id'],v['priority'],v['program'])
            cards[card.id] = card
        end
        self.deck = Deck(cards)
        self.client.deck = self.deck
    end
    self.networking:send({ command= ClientCommands.MyNameIs , value= nickname })
    self.networking:setTimeout(0.001)

    self.client:addPlayer(player)
    self.hud = Hud(player)

    local robot = Robot(2, 2, 1, nil, self.level.level.tileWidth, self.level.level.tileHeight)
    player.robot = robot

    self.robots = {[robot] = true}
    self.actor = nil
    self.actionQueue = {}
    
    -- animation test code
    local robot2 = Robot(3, 2, 0, nil, self.level.level.tileWidth, self.level.level.tileHeight)

    self.robots[robot2] = true



    self:enqueueActions(robot,  "graceStartF",
                                "continueF",
                                "graceStopF",
                                "turnAround")
    self:enqueueActions(robot2, "graceStartF",
                                "graceStopF")
    self:enqueueActions(robot,  "graceStartF",
                                "graceStopF")
end

function Game:draw()
    self.cam:attach()
    local camWorldWidth = love.graphics.getWidth() / self.cam.scale
    local camWorldHeight = love.graphics.getHeight() / self.cam.scale
    local camWorldX = self.cam.x - (camWorldWidth / 2)
    local camWorldY = self.cam.y - (camWorldHeight / 2)
    self.level.level:setDrawRange(camWorldX, camWorldY, camWorldWidth, camWorldHeight)

    self.level:draw()
    
    for robot in pairs(self.robots) do
        robot:draw()
    end
    
    self.cam:detach()

    self.hud:draw()
end

function Game:update(dt)
    if dt > 0.1 then dt = 0.1 end

    for robot in pairs(self.robots) do
        robot:update(dt)
    end

    self:executeActions()

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

function Game:_handleNetworkCommand(command, value)
    if command == ServerCommands.DealProgramCards then
        local player = self.client.players[1]
        local cards = value
        
        self.client:receiveHand(player, cards)
    elseif command == ServerCommands.ServerMessage then
        self.client:serverMessage(value)
    elseif command == ServerCommands.RobotTurnRight then
        self:enqueueActions(value.clientId, "turnRight")
    elseif command == ServerCommands.RobotTurnLeft then
        self:enqueueActions(value.clientId, "turnLeft")
    elseif command == ServerCommands.RobotTurnAround then
        self:enqueueActions(value.clientId, "turnAround")
    elseif command == ServerCommands.RobotGracefulStartForward then
        self:enqueueActions(value.clientId, "graceStartF")
    elseif command == ServerCommands.RobotGracefulStartBackward then
        self:enqueueActions(value.clientId, "graceStartB")
    elseif command == ServerCommands.RobotGracefulStopForward then
        self:enqueueActions(value.clientId, "graceStopF")
    elseif command == ServerCommands.RobotGracefulStopBackward then
        self:enqueueActions(value.clientId, "graceStopB")
    elseif command == ServerCommands.RobotContinueForward then
        self:enqueueActions(value.clientId, "continueF")
    elseif command == ServerCommands.RobotContinueBackward then
        self:enqueueActions(value.clientId, "continueB")
    else
        print("WARNING: Received unknown server command: " .. tostring(command))
    end
end

function Game:quit()
    self.networking:close()
end

function Game:enqueueActions(robot, ...)
    for i, action in ipairs(arg) do
        table.insert(self.actionQueue, {robot, action})
    end
end

function Game:executeActions()
    if (not self.actor or self.actor.animation.type == "wait") and #self.actionQueue > 0 then
        local robot, order = unpack(table.remove(self.actionQueue, 1))

        self.actor = robot
        self.actor:order(order)
    end
end

return Game

