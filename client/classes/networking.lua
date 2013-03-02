local Class = require("hump.class")
local socket=require ("socket")
local tcp = assert(socket.tcp())
require("json.json")

local Networking = Class {
}

function Networking:init()
    
end

function Networking:connect(host, port)
    tcp:connect(host, port);
end

function Networking:close()
    tcp:close()
end

function Networking:send(data)
    tcp:send(data)
end

function Networking:receive()
    local s, status, partial = tcp:receive()
    return json.decode(s)
end

return Networking