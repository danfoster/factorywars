local Class = require("hump.class")
local Menu = require("classes.menu")

local Gamestate = require("hump.gamestate")
require("LoveFrames")

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

function love.update(dt)
	loveframes.update(dt)

end
				
function love.draw()
	loveframes.draw()

end

function love.mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)

end

function love.mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)

end

function love.keypressed(key, unicode)
	loveframes.keypressed(key, unicode)

end

function love.keyreleased(key)
	loveframes.keyreleased(key)

end
