local Class = require("hump.class")

local Player = Class {}

function Player:init(client, name)
    self.client = client
    self.name = name

    self.hand = {}
    self.robot = nil
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

    self.client:setRegister(player, id, card)

    return replaced
end

function Player:clearRegister(id)
    local cleared = self.robot:setRegister(id, nil)

    if cleared then
        self:addCard(cleared)
    end

    self.client:clearRegister(player, id)

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



function Player:clearHand()
    self.hand = {}
end

return Player
