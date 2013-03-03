local Class = require("hump.class")
local Menu = require("classes.menu")
local Gamestate = require("hump.gamestate")

MenuState = {}
GameState = {}
LobbyState = {}

require("states.menustate")
require("states.gamestate")
require("states.lobbystate")

function love.load()
    fontTitle = love.graphics.newFont("data/fonts/Spac3 halftone.ttf", 55)
    fontMenu = love.graphics.newFont("data/fonts/Typo Moiser free promo.ttf", 32)
    fontDicks = love.graphics.newFont("data/fonts/cocksure.ttf", 45)

    MenuState.menu = Menu()

    Gamestate.registerEvents()
    Gamestate.switch(MenuState)
end

