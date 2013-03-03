local Class = require("hump.class")

local Client = Class {
}

function Client:init(deck)
    self.hand = {}
    self.deck = deck
end

function Client:receiveHand(cards)
    self.hand = {}
    for k,v in pairs(cards) do
        local card = self.deck:get(v)
        table.insert(self.hand,card)
        print(k,card.program,card.priority)
    end
end

function Client:serverMessage(message)
    print('Server: ' .. message)
end

return  Client
