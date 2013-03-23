local Class = require("hump.class")
local socket=require ("socket")
local tcp = assert(socket.tcp())
require("json.json")

local Gamestate = require("hump.gamestate")

ServerCommands = {
    ServerMessage = 0,
    ChatMessage = 1,
    ProgramDeck = 10,
    DealProgramCards = 11,
    FinalPlayerChoosingProgramCards = 12,
    DealOptionCard = 13,
    PlayerSetRegister = 14,
    PlayerClearRegister = 15,
    PlayerClearRegisters = 16,
    PlayerCommitRegisters = 17,
    DamageRobot = 20
}

ClientCommands = {
    MyNameIs = 0,
    SetRegister = 10,
    ClearRegister = 11,
    ClearRegisters = 12,
    CommitRegisters = 13,
    PlayOptionCard = 20,
    PowerDownNextTurn = 30
}

local Networking = Class {
    ServerCommands = ServerCommands,
    ClientCommands = ClientCommands,
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
        Gamestate.switch(MenuState)
    end
end

function Networking:close()
    tcp:close()
    print('disconnected from server')
end

function Networking:send(data)
    print(json.encode(data))

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
