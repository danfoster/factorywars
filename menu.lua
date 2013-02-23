local Class = require("hump.class")
local Gamestate = require("hump.gamestate")
local Game = require("game")

local Menu = Class
{
    menuItems =
        {'join game',
         'host game',
         'quit'}
}

function Menu:init()
    self.currentMenuItem = 1
end

function Menu:draw()
    love.graphics.setFont(fontTitle)
    love.graphics.setColor(255,255,255,255)
    love.graphics.printf("Factory Wars",0, 10, love.graphics.getWidth(),'center')

    love.graphics.setFont(fontMenu)
    
    for menuref,menutext in ipairs(self.menuItems) do
        if menuref == self.currentMenuItem then
            love.graphics.setColor(255,0,0,255)
        else
            love.graphics.setColor(255,255,255,255)
        end
        love.graphics.printf(menutext, 0, 100+(menuref*35), love.graphics.getWidth(),'center')
    end 
end

function Menu:enter()
end

function Menu:leave()
end

function Menu:keypressed(key)
    if key == "down" then
        self.currentMenuItem = self.currentMenuItem + 1
        if self.currentMenuItem > #self.menuItems then
            self.currentMenuItem = #self.menuItems
        end
    elseif key == "up" then
        self.currentMenuItem = self.currentMenuItem - 1
        if self.currentMenuItem < 1 then
            self.currentMenuItem = 1
        end
    elseif key == "return" then
        if self.currentMenuItem == 1 then -- quit
            game = Game()
            Gamestate.switch(game)
        elseif self.currentMenuItem == 3 then -- quit
            love.event.quit()
        end
    end
    
end


return Menu
