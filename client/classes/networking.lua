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
                  SetRegister = 10,
                  ClearRegister = 11,
                  ClearRegisters = 12,
                  PlayOptionCard = 20,
                  PowerDownNextTurn = 30}

local Networking = Class {
}

function Networking:init()
end

function Networking:setTimeout(time)
    tcp:settimeout(time)    
end

function Networking:connect(host, port)
    local status,statusString = tcp:connect(host, port);
    if status then
        print('connected to server')
    else
        print('error connecting to server: ' .. statusString)
    end
end

function Networking:close()
    tcp:close()
    print('disconnected from server')
end

function Networking:send(data)
    tcp:send(json.encode(data) .. '\r\n')
    print('sent data to server')
end

function Networking:receive()
    local s, status, partial = tcp:receive()
    if s == nil then
        return s
    end
    return json.decode(s)
end

return Networking
