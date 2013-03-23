local Class = require("hump.class")

local Player = Class {}

function Player:init(client, name)
    self.client = client
    self.name = name

    self.hand = {}
    self.registers = {false,false,false,false,false}
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
            print("***",i)
            self.hand[i] = false
            break
        end
    end
end

function Player:setRegister(id, card)
    self:removeCard(card)

    local replaced = self.robot:setRegister(id, card)

    if replaced then
        Player:addCard(replaced)
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

function Player:clearHand()
    self.hand = {}
end

return Player
