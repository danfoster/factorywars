local Gamestate = require("hump.gamestate")

local PlayState = {}

function PlayState:init()
end


function PlayState:enter()
end

function PlayState:draw()
    self.game:draw()
end

function PlayState:update(dt)
    self.game:update(dt)
end


function PlayState:mousepressed(x,y,button)
    if button == 'r' then
        self.game.updatingView = true
        self.game.oldMouseX = x
        self.game.oldMouseY = y
    elseif button == 'wd' then
        self.game.cam.scale = math.max(self.game.cam.scale / 1.2, 0.1)
    elseif button == 'wu' then
        self.game.cam.scale = math.min(self.game.cam.scale * 1.1, 5)
    end
end

function PlayState:mousereleased(x,y,button)
    if button == 'r' then
        self.game.updatingView = false
    end
end

function PlayState:keypressed(key)
    
end


function PlayState:leave()
    self.game:quit()
end

function PlayState:quit()
    self.game:quit()
end

return PlayState
