local Class = require("hump.class")
local Robot = require("classes.robot")
local Player = require("classes.player")

local RemotePlayer = Class {
    PlayerStates = Player.PlayerStates
}

function RemotePlayer:init(id, robot)
    --self.name = name
    self.id = id

    self.hand = {}
    self.robot = robot
    self.state = PlayerStates.pickingCards
end

function RemotePlayer:addCard(card)
    for i=1,9 do
        if not self.hand[i] then 
            self.hand[i] = card
            break
        end
    end
end

function RemotePlayer:removeCard(card)
    for i=1,9 do
        if self.hand[i] == card then 
            table.remove(self.hand,i)
            break
        end
    end
end

function RemotePlayer:removeRegisterCard(card)
    for i=1,self.robot.numRegisters do
        if self.robot.registers[i] == card then 
            self:clearRegister(i)
            break
        end
    end
end

function RemotePlayer:getRegisterPosition(card)
    for i=1,self.robot.numRegisters do
        if self.robot.registers[i] == card then 
            return i
        end
    end
    return nil
end

function RemotePlayer:clearHand()
    self.hand = {}
end

return RemotePlayer
