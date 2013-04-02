local Class = require("hump.class")

local Button = Class {}

function Button:init(image, imagePressed, font, x, y, textoffset, text)
    print(imagePressed)
    self.image = love.graphics.newImage(image)
    self.imagePressed = love.graphics.newImage(imagePressed)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.x = x
    self.y = y
    self.textoffset = textoffset
    self.text = text
    self.font = font

    self.pressed = false
end

function Button:draw()
    if self.pressed then
        love.graphics.draw(self.imagePressed,self.x,self.y)
        os=2
    else
        love.graphics.draw(self.image,self.x,self.y)
        os=0
    end
    love.graphics.setColor(255,255,255,255)
    love.graphics.setFont(self.font)
    love.graphics.printf(self.text, self.x+os, self.y+self.textoffset+os, 63,'center')

end

function Button:checkClick(x,y)
    if x >= self.x and x <= self.x+self.width and y >= self.y and y <= self.y+self.height and not self.pressed then
        self.pressed = true
        return true
    end
    return false
end

function Button:checkRelease(x,y)
    if self.pressed then
        self.pressed = false
        if x >= self.x and x <= self.x+self.width and y >= self.y and y <= self.y+self.height then
            return true
        end
    end
    return false
end

return Button
