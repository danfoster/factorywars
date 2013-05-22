local Class = require("hump.class")

local Networking = require("classes.networking")

local Client = Class {}

function Client:init(networking, deck)
    self.networking = networking
    self.hand = {}
    self.deck = deck
    self.player = nil
    self.Id = nil
end

function Client:addPlayer(player)
    self.player = player
end

function Client:receiveHand(player, cards)
    player:clearHand()

    for i, id in pairs(cards) do
        local card = self.deck:get(id)
        player:addCard(card)
    end

end

function Client:startTurn()
    self.player:startTurn()
end

function Client:allRegistersReceived()
    self.player:executingRegisters()
end

function Client:endTurn()
    self.player:endTurn()
end

function Client:readyForNextTurn()
    local message = {
        command = Networking.ClientCommands.ReadyForNextTurn,
        value = {
        },
    }
    
    self.networking:send(message)
end

function Client:setRegister(id, card)
    local message = {
        command = Networking.ClientCommands.SetRegister,
        value = {
            register = id - 1,
            programCardId = card.id,
        },
    }

    self.networking:send(message)
end

function Client:clearRegister(id)
    local message = {
        command = Networking.ClientCommands.ClearRegister,
        value = {
            register = id - 1,
        },
    }

    self.networking:send(message)
end

function Client:commitRegisters()
    local message = {
        command = Networking.ClientCommands.CommitRegisters,
        value = {
        },
    }

    self.networking:send(message)
end

function Client:powerDown()
    local message = {
        command = Networking.ClientCommands.PowerDownNextTurn,
        value = {
        },
    }
    self.networking:send(message)
end

function Client:revertPowerDown()
    local message = {
        command = Networking.ClientCommands.RevertPowerDownNextTurn,
        value = {
        },
    }
    self.networking:send(message)
end


function Client:serverMessage(message)
    print('Server: ' .. message)
end

return Client
