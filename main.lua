local Class = require("hump.class")
local Menu = require("menu")
local Gamestate = require("hump.gamestate")

function love.load()
    fontTitle = love.graphics.newFont("data/fonts/Spac3 halftone.ttf", 55)
    fontMenu = love.graphics.newFont("data/fonts/Typo Moiser free promo.ttf", 32)

    mainmenu = Menu()

    Gamestate.registerEvents()
    Gamestate.switch(mainmenu)
end

