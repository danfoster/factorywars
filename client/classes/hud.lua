local Class = require("hump.class")

local Hud = Class {}

function Hud:init(player)
    self.player = player
    self.cardWidth=64
    self.cardHeight=64
    self.registerBorderWidth=5
    self.fontCard = love.graphics.newFont("data/fonts/Cocksure.ttf", 40)
    self.fontCardSmall = love.graphics.newFont("data/fonts/Cocksure.ttf", 20)
    self.registerBorderImage = love.graphics.newImage("data/hud/card_border.png")
    self.heldCardX = 0
    self.heldCardY = 0
    self.heldCard = nil
end

function Hud:draw()
    self:_drawHand()
    self:_drawRegisters()
    self:_drawHeld()
end

function Hud:_drawHeld()
    if self.heldCard then
        self:_drawCard(love.mouse.getX()-self.heldCardX,love.mouse.getY()-self.heldCardY,self.heldCard)
    end
end

function Hud:_drawHand()
    i=0
    for k,v in ipairs(self.player.hand) do
        if v and v ~= self.heldCard then
            self:_drawCard(5+(self.cardWidth+5)*i,love.graphics.getHeight()-self.cardHeight-10-self.cardHeight-(self.registerBorderWidth*2),v)
        end
        i = i +1
    end
end

function Hud:_drawRegisters()
    for i=0,self.player.robot.numRegisters-1 do
        v = self.player.robot.registers[i+1]
        self:_drawRegister(5+(self.cardWidth+5+(self.registerBorderWidth*2))*i,love.graphics.getHeight()-self.cardHeight-5-(self.registerBorderWidth*2),v)
        i = i +1
    end
end

function Hud:_drawRegister(x,y,card)
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle("fill",x+self.registerBorderWidth,y+self.registerBorderWidth,self.cardWidth,self.cardHeight)
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(self.registerBorderImage,x,y)
    if card then
        self:_drawCard(x+self.registerBorderWidth,y+self.registerBorderWidth,card)
    end
end

function Hud:_drawCard(x,y,card)
    
    love.graphics.setColor(0,0,255,255)
    love.graphics.rectangle("fill",x,y,self.cardWidth,self.cardHeight)
    love.graphics.setColor(255,0,0,255)
    love.graphics.rectangle("line",x,y,self.cardWidth,self.cardHeight)
    love.graphics.setFont(self.fontCard)
    love.graphics.printf(card.program, x, y, self.cardWidth,'center')
    love.graphics.setFont(self.fontCardSmall)
    love.graphics.printf(card.priority, x, y+(self.cardHeight*0.6), self.cardWidth,'center')
end

function Hud:mousePressed(x,y)
    -- Is the mouse position in the vertical position for the hand deck?
    if y >= love.graphics.getHeight()-self.cardHeight-10-self.cardHeight-(self.registerBorderWidth*2) and y <= love.graphics.getHeight()-self.cardHeight-10-self.registerBorderWidth then
        px = (x%(self.cardWidth+5)) - 5
        if px > 0 and px < self.cardWidth then
            card = math.floor(x/(self.cardWidth+5)) + 1
            if self.player.hand[card] then
                self.heldCard = self.player.hand[card]
                self.heldCardY = y - (love.graphics.getHeight()-self.cardHeight-10-self.cardHeight-(self.registerBorderWidth*2) )
                self.heldCardX = px
                -- self.player:setRegister(0,self.player.hand[card])
            end
        end
    -- Is the mouse position in the vertical position for the registers?
    elseif y >= love.graphics.getHeight()-self.cardHeight-5-(self.registerBorderWidth*2) and y <= love.graphics.getHeight()-5-self.registerBorderWidth then
        px = (x%(self.cardWidth+5+(self.registerBorderWidth*2))) - 5
        if px > 0 and px < self.cardWidth+(self.registerBorderWidth*2) then
            card = math.floor(x/(self.cardWidth+5+(self.registerBorderWidth*2))) + 1
            if self.player.robot.registers[card] then
                self.heldCard = self.player.robot.registers[card]
                self.heldCardY = y - (love.graphics.getHeight()-self.cardHeight-5-(self.registerBorderWidth*2) )
                self.heldCardX = px
            end
        end
    end
end

function Hud:mouseReleased(x,y)
    if self.heldCard then
        if y >= love.graphics.getHeight()-self.cardHeight-5-(self.registerBorderWidth*2) and y <= love.graphics.getHeight()-5-self.registerBorderWidth then
            px = (x%(self.cardWidth+5+(self.registerBorderWidth*2))) - 5
            if px > 0 and px < self.cardWidth+(self.registerBorderWidth*2) then
                card = math.floor(x/(self.cardWidth+5+(self.registerBorderWidth*2))) + 1
                if card >0 and card < 6 then
                    self.player:setRegister(card,self.heldCard)
                end
            end
        end
        self.heldCard = nil
    end
end

return Hud
