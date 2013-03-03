local Class = require("hump.class")

local Client = Class {
}

function Client:init(deck)
    self.hand = nil
    self.deck = deck
end

function Client:receiveHand(cards)
    for k,v in pairs(cards) do
        local card = self.deck:get(v)
        print(k,card.program,card.priority)
    end
end


return  Client
