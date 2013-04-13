local Class = require("hump.class")

PlayerStates = {
    pickingCards = 1,
    commitedCards = 2,
    executingRegisters = 3,
    endTurn = 4
}

local Player = Class {
    PlayerStates = PlayerStates
}

function Player:init(client, name)
    self.client = client
    self.name = name

    self.hand = {}
    self.robot = nil
    self.state = PlayerStates.pickingCards
end

function Player:addCard(card)
    for i=1,9 do
        if not self.hand[i] then 
            self.hand[i] = card
            break
        end
    end
end

function Player:removeCard(card)
    for i=1,9 do
        if self.hand[i] == card then 
            table.remove(self.hand,i)
            break
        end
    end
end

function Player:setRegister(id, card)
    self:removeRegisterCard(card)
    self:removeCard(card)

    local replaced = self.robot:setRegister(id, card)

    if replaced then
        self:addCard(replaced)
    end

    self.client:setRegister(id, card)

    return replaced
end

function Player:clearRegister(id)
    local cleared = self.robot:setRegister(id, nil)

    if cleared then
        self:addCard(cleared)
    end

    self.client:clearRegister(id)

    return cleared
end

function Player:removeRegisterCard(card)
    for i=1,self.robot.numRegisters do
        if self.robot.registers[i] == card then 
            self:clearRegister(i)
            break
        end
    end
end

function Player:getRegisterPosition(card)
    for i=1,self.robot.numRegisters do
        if self.robot.registers[i] == card then 
            return i
        end
    end
    return nil
end

function Player:commitRegisters()
    self.state = PlayerStates.commitedCards
    self:clearHand()
    self.client:commitRegisters()
end

function Player:clearHand()
    self.hand = {}
end

return Player
