local Class = require("hump.class")

local Hud = Class {
}

function Hud:init(client)
    self.client = client
    self.cardWidth=64
    self.cardHeight=64
    self.fontCard = love.graphics.newFont("data/fonts/Cocksure.ttf", 40)
    self.fontCardSmall = love.graphics.newFont("data/fonts/Cocksure.ttf", 20)
end

function Hud:draw()
    self:_drawHand()
end

function Hud:_drawHand()
    i=0
    for k,v in pairs(self.client.hand) do
        self:_drawCard(10+(self.cardWidth+10)*i,love.graphics.getHeight()-self.cardHeight-10,v)
        i = i +1
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

return Hud
