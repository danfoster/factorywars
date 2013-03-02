local Class = require("hump.class")
local socket=require ("socket")
local tcp = assert(socket.tcp())
require("json.json")

ServerCommands = {ProgramDeck = 0,
                  DealProgramCards = 1,
                  FinalPlayerChoosingOptionCards = 2,
                  DealOptionCard = 3,
                  DamageRobot = 4}

ClientCommands = {MyNameIs = 0,
                  ArrangeProgramCard = 1,
                  ClearProgramCardArrangement = 2,
                  PlayOptionCard = 3,
                  PowerDownNextTurn = 4}

local Networking = Class {
}

function Networking:init()
    
end

function Networking:connect(host, port)
    tcp:connect(host, port);
    print('connected to server')
end

function Networking:close()
    tcp:close()
    print('disconnected from server')
end

function Networking:send(data)
    tcp:send(data .. '\r\n')
    print('sent data to server')
end

function Networking:receive()
    local s, status, partial = tcp:receive()
    print('received data from server')
    return json.decode(s)
end

return Networking
