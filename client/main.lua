local Class = require("hump.class")
local Menu = require("classes.menu")

local Gamestate = require("hump.gamestate")

MenuState = require("states.menustate")
PlayState = require("states.playstate")
LobbyState = require("states.lobbystate")

function love.load()
    fontTitle = love.graphics.newFont("data/fonts/Spac3 halftone.ttf", 55)
    fontMenu = love.graphics.newFont("data/fonts/Typo Moiser free promo.ttf", 32)
    fontDicks = love.graphics.newFont("data/fonts/Cocksure.ttf", 45)

    MenuState.menu = Menu()

    Gamestate.registerEvents()
    Gamestate.switch(MenuState)
end

