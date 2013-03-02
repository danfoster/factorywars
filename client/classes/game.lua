local Class = require("hump.class")
local Camera = require("hump.camera")
local ATL = require("AdvTiledLoader") 
local Robot = require("classes.robot")
local Card = require("classes.card")
local Networking = require("classes.networking")

local Game = Class {
}

function Game:init()
    self.cam = Camera()
    ATL.Loader.path = 'data/boards/'
    self.level = ATL.Loader.load("test2.tmx") 
    self:addEdges()
    self.updatingView = false
    self.oldMouseX = 0
    self.oldMouseY = 0 
    
    
    -- test code
    self.networking = Networking()
    
    self.robot = Robot(self.level, 2, 2, 1)
    self.fCard = Card(1, 1)
end

function Game:addEdges()
    -- Create new tileLayer for edges
    local edgeLayer = ATL.TileLayer:new(self.level,'edges',100,{})
    self.level.layers[edgeLayer.name] = edgeLayer
    self.level.layerOrder[#self.level.layerOrder + 1] = edgeLayer

    -- Create edge TileSet
    edgeImage = love.graphics.newImage('data/tiles/edges.png')
    local edgeTileSet = ATL.TileSet:new(edgeImage,'data/tiles/','edges',128,128,128,128*9,0,0,0,0,0,0)
    local edgeTiles = edgeTileSet:getTiles()

    -- Add edge Tiles over any pits
    for y=0,self.level.height-1 do
        for x=0,self.level.width-1 do
            if self.level.layers['floor']:get(x,y) == nil then
                -- Determine which type of edge we need
                local blankEdges = 0
                if self.level.layers['floor']:get(x-1,y) == nil then blankEdges = blankEdges + 1 end
                if self.level.layers['floor']:get(x+1,y) == nil then blankEdges = blankEdges + 1 end
                if self.level.layers['floor']:get(x,y-1) == nil then blankEdges = blankEdges + 1 end
                if self.level.layers['floor']:get(x,y+1) == nil then blankEdges = blankEdges + 1 end

                local et = 0
                local r = 0
                if blankEdges == 0 then
                    et = 4
                    -- no rotation needed
                elseif blankEdges == 1 then
                    et = 2
                    -- detmine rotation based on the single blank neighbour
                    if self.level.layers['floor']:get(x+1,y) == nil then r = 0
                    elseif self.level.layers['floor']:get(x,y+1) == nil then r = 5
                    elseif self.level.layers['floor']:get(x-1,y) == nil then r = 6
                    elseif self.level.layers['floor']:get(x,y-1) == nil then r = 3
                    end
                elseif blankEdges == 2 then
                    -- still 2 possible shapes
                    if self.level.layers['floor']:get(x-1,y) == nil
                    and self.level.layers['floor']:get(x+1,y) == nil then
                        et = 3
                        r = 0
                    elseif self.level.layers['floor']:get(x,y-1) == nil
                    and self.level.layers['floor']:get(x,y+1) == nil then
                        et = 3
                        r = 5
                    else
                        et = 1
                        if self.level.layers['floor']:get(x+1,y) == nil
                        and self.level.layers['floor']:get(x,y+1) == nil then
                            r = 0
                        elseif self.level.layers['floor']:get(x,y+1) == nil
                        and self.level.layers['floor']:get(x-1,y) == nil then
                            r = 5
                        elseif self.level.layers['floor']:get(x-1,y) == nil
                        and self.level.layers['floor']:get(x,y-1) == nil then
                            r = 6
                        elseif self.level.layers['floor']:get(x,y-1) == nil
                        and self.level.layers['floor']:get(x+1,y) == nil then
                            r = 3
                        end
                    end
                elseif blankEdges == 3 then
                    et = 0
                    if self.level.layers['floor']:get(x+1,y) ~= nil then r = 5
                    elseif self.level.layers['floor']:get(x,y+1) ~= nil then r = 6
                    elseif self.level.layers['floor']:get(x-1,y) ~= nil then r = 3
                    elseif self.level.layers['floor']:get(x,y-1) ~= nil then r = 0
                    end
                    -- TODO: Need 10th tile with a dot in the opposite corner
                elseif blankEdges == 4 then
                    local blankCorners = 0
                    if self.level.layers['floor']:get(x-1,y-1) == nil then blankCorners = blankCorners + 1 end
                    if self.level.layers['floor']:get(x+1,y-1) == nil then blankCorners = blankCorners + 1 end
                    if self.level.layers['floor']:get(x-1,y+1) == nil then blankCorners = blankCorners + 1 end
                    if self.level.layers['floor']:get(x+1,y+1) == nil then blankCorners = blankCorners + 1 end

                    if blankCorners == 0 then
                        et = 8
                        -- no rotation needed
                    elseif blankCorners == 1 then
                        et = 7
                        -- TODO: rotation
                    elseif blankCorners == 2 then
                        et = 6
                        -- TODO: rotation
                    elseif blankCorners == 3 then
                        et = 5
                        -- TODO: rotation
                    end
                end

                self.level.layers['edges']:tileRotate(x,y,r)
                self.level.layers['edges']:set(x,y,edgeTiles[et])
            end
        end
    end

end

function Game:turn()
    -- distribute cards
    -- arrange cards
    -- announce intent to power down or continue running next turn
    -- execute registers (card movements, board movements, interactions)
    -- end of turn effects
end

function Game:executeCard(card, robot)
    if card.forward ~= 0 then
        local absolute = math.abs(card.forward)
        for i = 1, absolute do
            x, y = robot:move(card.forward / absolute)
            -- TODO: function for checking collisions
            robot.x = x
            robot.y = y
        end
    end
    -- TODO: strafing
    if card.rotate ~= 0 then
        -- could do this in 90 degree increments if we want
        o = robot:rotate(card.rotate)
        robot.orient = o
    end
end

return Game

