local Class = require("hump.class")
local Button = require("classes.button")
local Led = require("classes.led")
local Player = require("classes.player")

local Hud = Class {}

function Hud:init(player)
    self.player = player
    self.cardWidth=64
    self.cardHeight=64
    self.registerBorderWidth=5
    self.fontCard = love.graphics.newFont("data/fonts/pixelart.ttf", 40)
    self.fontCardSmall = love.graphics.newFont("data/fonts/pixelart.ttf", 16)
    self.fontButton = love.graphics.newFont("data/fonts/pixelart.ttf", 11)
    self.hudBLImage = love.graphics.newImage("data/hud/hud_bl.png")
    self.cardImage = love.graphics.newImage("data/hud/card.png")
    self.forwardImage = love.graphics.newImage("data/hud/arrow_forward.png")
    self.backImage = love.graphics.newImage("data/hud/arrow_back.png")
    self.leftImage = love.graphics.newImage("data/hud/arrow_left.png")
    self.rightImage = love.graphics.newImage("data/hud/arrow_right.png")
    self.uTurnImage = love.graphics.newImage("data/hud/arrow_uturn.png")

    self.commitButton = Button("data/hud/button.png","data/hud/button_pressed.png",self.fontButton,427,love.graphics.getHeight()-86,10,"Commit")
    self.powerDownButton = Button("data/hud/button.png","data/hud/button_pressed.png",self.fontButton,427,love.graphics.getHeight()-52,6,"Power Down")

    self.leds = {}
    for i=1,5 do
        self.leds[i]= Led((i*84)-42,love.graphics.getHeight()-95)
    end

    self.heldCardX = 0
    self.heldCardY = 0
    self.heldCard = nil
    self.canCommit = false
end

function Hud:draw()
    self:_drawHUD()
    self:_drawHand()
    self:_drawRegisters()
    self:_drawHeld()
end

function Hud:update()
    if self.player.state == Player.PlayerStates.pickingCards then
        if self:_countRegisters() == 5  then
            self.canCommit = true
            self.commitButton:setColor(255,255,255,255)
        elseif self:_countRegisters() < 5  then
            self.canCommit = false
            self.commitButton:setColor(100,100,100,255)
        end
        self.powerDownButton:setColor(255,255,255,255)
    else
            self.commitButton:setColor(100,255,100,255)
            self.powerDownButton:setColor(100,100,100,255)
    end
end


function Hud:_drawHUD()
    love.graphics.draw(self.hudBLImage,0,love.graphics.getHeight()-112)
    self.commitButton:draw()
    self.powerDownButton:draw()
end

function Hud:_drawHeld()
    if self.heldCard then
        self:_drawCard(love.mouse.getX()-self.heldCardX,love.mouse.getY()-self.heldCardY,self.heldCard,false)
    end
end

function Hud:_drawHand()
    i=0
    for k,v in ipairs(self.player.hand) do
        if v and v ~= self.heldCard then
            l = false
            self:_drawCard(5+(self.cardWidth+5)*i,love.graphics.getHeight()-115-self.cardHeight,v,false)
        end
        i = i +1
    end
end

function Hud:_drawRegisters()
    for i=0,self.player.robot.numRegisters-1 do
        v = self.player.robot.registers[i+1]
        if v and v ~= self.heldCard then
            self:_drawRegister(14+(self.cardWidth+20)*i,love.graphics.getHeight()-self.cardHeight-22,v)
        end
        i = i +1
    end
    for k,v in pairs(self.leds) do
        v:draw()
    end
end

function Hud:_countRegisters()
    c = 0
    for i =1,self.player.robot.numRegisters do
        if self.player.robot.registers[i] ~= nil then
            c = c +1
        end
    end
    return c
end

function Hud:_drawRegister(x,y,card)
    love.graphics.setColor(255,255,255,255)
    if card then
        -- test for locked cards:
        locked = false
        if x<150 then
            locked = true
        end

        self:_drawCard(x,y,card,locked)
    end
end

function Hud:_drawCard(x,y,card,locked)
    if locked then
        val = 150
    else 
        val = 255
    end
    love.graphics.setColor(val,val,val,255)
    love.graphics.draw(self.cardImage,x,y) 
    love.graphics.setColor(0,0,0,255)
    love.graphics.setFont(self.fontCardSmall)
    love.graphics.printf(card.priority, x, y+7, self.cardWidth,'center')
    love.graphics.setColor(val,val,val,255)
    if card.program == Program['UTurn'] then
        love.graphics.draw(self.uTurnImage,x+2,y+22) 
    elseif card.program == Program['RotateRight'] then
        love.graphics.draw(self.rightImage,x+10,y+22) 
    elseif card.program == Program['RotateLeft'] then
        love.graphics.draw(self.leftImage,x+10,y+22) 
    elseif card.program == Program['BackUp'] then
        love.graphics.draw(self.backImage,x+14,y+22) 
    elseif card.program == Program['Move1'] then
        love.graphics.draw(self.forwardImage,x+14,y+22) 
        love.graphics.printf("1", x, y+43, self.cardWidth,'center')
    elseif card.program == Program['Move2'] then
        love.graphics.draw(self.forwardImage,x+14,y+22) 
        love.graphics.printf("2", x, y+43, self.cardWidth,'center')
    elseif card.program == Program['Move3'] then
        love.graphics.draw(self.forwardImage,x+14,y+22) 
        love.graphics.printf("3", x, y+43, self.cardWidth,'center')
    end
end

function Hud:mousePressed(x,y)
    if self.player.state == Player.PlayerStates.pickingCards then
        -- Is the mouse position in the vertical position for the hand deck?
        if y >= love.graphics.getHeight()-self.cardHeight-115 and y <= love.graphics.getHeight()-115 then
            px = (x%(self.cardWidth+5)) - 5
            if px > 0 and px < self.cardWidth then
                card = math.floor(x/(self.cardWidth+5)) + 1
                if self.player.hand[card] then
                    self.heldCard = self.player.hand[card]
                    self.heldCardY = y - (love.graphics.getHeight()-self.cardHeight-115 )
                    self.heldCardX = px
                end
            end
        -- Is the mouse position in the vertical position for the registers?
        elseif y >= love.graphics.getHeight()-self.cardHeight-22 and y <= love.graphics.getHeight()-22 then
            px = (x%(self.cardWidth+20)) - 14
            if px > 0 and px < self.cardWidth then
                card = math.floor((x-14)/(self.cardWidth+20)) + 1
                if self.player.robot.registers[card] then
                    self.heldCard = self.player.robot.registers[card]
                    self.heldCardY = y - (love.graphics.getHeight()-self.cardHeight-22 )
                    self.heldCardX = px
                end
            end

            if not self.heldCard then
                if self.player.state == Player.PlayerStates.pickingCards then
                    if self.canCommit then
                        self.commitButton:checkClick(x,y)
                    end
                    self.powerDownButton:checkClick(x,y)
                end
            end
        end
    end
end

function Hud:mouseReleased(x,y)
    if self.player.state == Player.PlayerStates.pickingCards then
        if self.heldCard then
            -- Is the mouse position in the vertical position for the registers?
            if y >= love.graphics.getHeight()-self.cardHeight-5-(self.registerBorderWidth*2) and y <= love.graphics.getHeight()-5-self.registerBorderWidth then
                px = (x%(self.cardWidth+5+(self.registerBorderWidth*2))) - 5
                if px > 0 and px < self.cardWidth+(self.registerBorderWidth*2) then
                    card = math.floor(x/(self.cardWidth+5+(self.registerBorderWidth*2))) + 1
                    if card >0 and card < 6 then
                        self.player:setRegister(card,self.heldCard)
                        self.leds[card]:setColor(205,199,9,255)
                    end
                end
            else
                pos = self.player:getRegisterPosition(self.heldCard)
                self.player:removeRegisterCard(self.heldCard)
                if pos then
                    self.leds[pos]:setColor(25,25,25,255)
                end
            end

            self.heldCard = nil
        else
            if self.canCommit then
                if self.commitButton:checkRelease(x,y) then
                    self.player:commitRegisters()
                end
            end
            self.powerDownButton:checkRelease(x,y)
        end
    end
end

return Hud
