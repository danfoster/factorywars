local Class = require("hump.class")

local Client = Class {}

function Client:init(deck)
    self.deck = deck

    self.players = {}
end

function Client:addPlayer(player)
    table.insert(self.players, player)
end

function Client:receiveHand(player, cards)
    player.hand = {}

    for i, id in pairs(cards) do
        local card = self.deck:get(id)
        
        table.insert(player.hand, card)

        print(i, card.program, card.priority)
    end
end

function Client:serverMessage(message)
    print('Server: ' .. message)
end

return  Client
