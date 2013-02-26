local Class = require("hump.class")

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


return Menu
