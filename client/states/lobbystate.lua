local Gamestate = require("hump.gamestate")
local Game = require("classes.game")

function LobbyState:init()
    self.msg = ""
end

function LobbyState:draw()
    love.graphics.setFont(fontTitle)
    love.graphics.setColor(255,255,255,255)
    love.graphics.printf("Factory Wars",0, 10, love.graphics.getWidth(),'center')

    love.graphics.setFont(fontDicks)
    love.graphics.printf("Enter server IP", 0, 100, love.graphics.getWidth(), 'center')
    love.graphics.printf(self.msg, 0, 160, love.graphics.getWidth(), 'center')
    
    --love.graphics.printf("Enter your nickname"
end

function LobbyState:enter()
end

function LobbyState:leave()
end

function LobbyState:keypressed(key, unicode)
    if unicode >= 32 and unicode <= 126 then
        self.msg = self.msg .. string.char(unicode)
    elseif key == "backspace" then
        self.msg = self.msg:sub(1, #self.msg - 1)
    elseif key == "return" then
        GameState.game = Game(self.msg)
        Gamestate.switch(GameState)
    end
end
