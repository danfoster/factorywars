function GameState:init()
end


function GameState:enter()
end

function GameState:draw()
    self.game:draw()
end

function GameState:update(dt)
    self.game:update()
end


function GameState:mousepressed(x,y,button)
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

function GameState:mousereleased(x,y,button)
    if button == 'r' then
        self.game.updatingView = false
    end
end

function GameState:keypressed(key)
    
end


function GameState:leave()
    self.game:quit()
end

function GameState:quit()
    self.game:quit()
end
