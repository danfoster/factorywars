local Gamestate = require("hump.gamestate")
local Game = require("classes.game")

local LobbyState = {}

function LobbyState:init()
    
    local lblTitle = loveframes.Create("text")
    lblTitle:SetFont(fontTitle)
    lblTitle:SetText({{255, 255, 255, 255}, "Factory Wars"})
    lblTitle:CenterX()
    lblTitle:SetY(10, false)
    lblTitle:SetState("lobby")

    local lblServer = loveframes.Create("text")
    lblServer:SetFont(fontDicks)
    lblServer:SetText({{255, 255, 255, 255}, "Server IP"})
    lblServer:CenterX()
    lblServer:SetY(love.graphics.getHeight() * 1/4, true)
    lblServer:SetState("lobby")
    
    self.txtServer = loveframes.Create("textinput")
    self.txtServer:CenterX()
    self.txtServer:SetY(love.graphics.getHeight() * 1/3, true)
    self.txtServer:SetFocus(true)
    self.txtServer:SetState("lobby")
    
    local lblNick = loveframes.Create("text")
    lblNick:SetFont(fontDicks)
    lblNick:SetText({{255, 255, 255, 255}, "Nickname"})
    lblNick:CenterX()
    lblNick:SetY(love.graphics.getHeight() * 1/2, true)
    lblNick:SetState("lobby")
    
    self.txtNick = loveframes.Create("textinput")
    self.txtNick:CenterX()
    self.txtNick:SetY(love.graphics.getHeight()  * 6/10, true)
    self.txtNick:SetState("lobby")
    
end

function LobbyState:draw()
end

function LobbyState:enter()
    loveframes.SetState("lobby")
end

function LobbyState:leave()
end

function LobbyState:keypressed(key, unicode)
    if key == "return" then
        if self.txtServer:GetFocus() then
            self.txtNick:SetFocus(true)
        else
            Gamestate.switch(PlayState)
            PlayState.game = Game(self.txtServer:GetText(), nil, self.txtNick:GetText())
        end
    end
end

return LobbyState
