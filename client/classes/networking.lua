local Class = require("hump.class")
local host, port = "192.168.1.8", 1234
local socket=require ("socket")
local tcp = assert(socket.tcp())

local Networking = Class {
}

function Networking:init()
    tcp:connect(host, port);

    while true do
        local s, status, partial = tcp:receive()
        print(s)
        if status == "closed" then break end
    end

    tcp:close()
end

return Networking