local Gamestate = require("hump.gamestate")

local MenuState = {}

function MenuState:init()
end

function MenuState:draw()
    love.graphics.setFont(fontTitle)
    love.graphics.setColor(255,255,255,255)
    love.graphics.printf("Factory Wars",0, 10, love.graphics.getWidth(),'center')

    love.graphics.setFont(fontMenu)
    
    for menuref,menutext in ipairs(self.menu.menuItems) do
        if menuref == self.menu.currentMenuItem then
            love.graphics.setColor(255,0,0,255)
        else
            love.graphics.setColor(255,255,255,255)
        end
        love.graphics.printf(menutext, 0, 100+(menuref*35), love.graphics.getWidth(),'center')
    end 
end

function MenuState:enter()
    loveframes.SetState("menu")
end

function MenuState:leave()
end

function MenuState:keypressed(key)
    if key == "down" then
        self.menu.currentMenuItem = self.menu.currentMenuItem + 1
        if self.menu.currentMenuItem > #self.menu.menuItems then
            self.menu.currentMenuItem = #self.menu.menuItems
        end
    elseif key == "up" then
        self.menu.currentMenuItem = self.menu.currentMenuItem - 1
        if self.menu.currentMenuItem < 1 then
            self.menu.currentMenuItem = 1
        end
    elseif key == "return" then
        if self.menu.currentMenuItem == 1 then -- quit
            Gamestate.switch(LobbyState)
        elseif self.menu.currentMenuItem == 3 then -- quit
            love.event.quit()
        end
    end
    
end

return MenuState
