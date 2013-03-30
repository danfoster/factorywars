local Class = require("hump.class")

local Networking = require("classes.networking")

local Client = Class {}

function Client:init(networking, deck)
    self.networking = networking
    self.hand = {}
    self.deck = deck

    self.players = {}
end

function Client:addPlayer(player)
    table.insert(self.players, player)
end

function Client:receiveHand(player, cards)
    player:clearHand()

    for i, id in pairs(cards) do
        local card = self.deck:get(id)
        player:addCard(card)
    end

end

function Client:setRegister(player, id, card)
    local message = {
        command = Networking.ClientCommands.SetRegister,
        value = {
            register = id - 1,
            programCardId = card.id,
        },
    }

    self.networking:send(message)
end

function Client:clearRegister(player, id)
    local message = {
        command = Networking.ClientCommands.ClearRegister,
        value = {
            register = id - 1,
        },
    }

    self.networking:send(message)
end

function Client:serverMessage(message)
    print('Server: ' .. message)
end

return Client
