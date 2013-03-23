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
end

function Hud:draw()
    self:_drawHand()
    self:_drawRegisters()
end

function Hud:_drawHand()
    i=0
    for k,v in ipairs(self.player.hand) do
        if v then
            self:_drawCard(5+(self.cardWidth+5)*i,love.graphics.getHeight()-self.cardHeight-10-self.cardHeight-(self.registerBorderWidth*2),v)
        end
        i = i +1
    end
end

function Hud:_drawRegisters()
    i=0
    for k,v in ipairs(self.player.registers) do
        self:_drawRegister(5+(self.cardWidth+5+(self.registerBorderWidth*2))*i,love.graphics.getHeight()-self.cardHeight-5-(self.registerBorderWidth*2),v)
        i = i +1
    end
end

function Hud:_drawRegister(x,y,card)
    love.graphics.setColor(0,0,0,255)
    love.graphics.rectangle("fill",x+self.registerBorderWidth,y+self.registerBorderWidth,self.cardWidth,self.cardHeight)
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(self.registerBorderImage,x,y)
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

function Hud:mousePressed(x,y,button)
    if y >= love.graphics.getHeight()-self.cardHeight-10-self.cardHeight-(self.registerBorderWidth*2) and y <= love.graphics.getHeight()-self.cardHeight-10-self.registerBorderWidth then
        p = (x%(self.cardWidth+5)) - 5
        if p > 0 and p < self.cardWidth then
            card = math.floor(x/(self.cardWidth+5)) + 1
            if card <= #self.player.hand then
                print(card)
            end
        end
    end
end

return Hud
