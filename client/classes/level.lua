local Class = require("hump.class")
local ATL = require("AdvTiledLoader") 

local Level = Class {
}


function Level:init()
    ATL.Loader.path = 'data/boards/'
    self.level = ATL.Loader.load("cross.tmx") 
    self:addEdges()
end

function Level:draw()
    love.graphics.setColor(255,255,255,255)
    self.level:draw()
end

function Level:addEdges()
    -- Create new tileLayer for edges
    local edgeLayer = ATL.TileLayer:new(self.level,'edges',100,{})
    self.level.layers[edgeLayer.name] = edgeLayer
    self.level.layerOrder[#self.level.layerOrder + 1] = edgeLayer
    local edgeCornerLayer = ATL.TileLayer:new(self.level,'edgeCorners',100,{})
    self.level.layers[edgeCornerLayer.name] = edgeCornerLayer
    self.level.layerOrder[#self.level.layerOrder + 1] = edgeCornerLayer

    -- Create edge TileSet
    local edgeImage = love.graphics.newImage('data/tiles/edges.png')
    edgeTileSet = ATL.TileSet:new(edgeImage,'data/tiles/','edges',128,128,128,128*10,0,0,0,0,0,0)
    edgeTiles = edgeTileSet:getTiles()

    self:_addMargin()

    -- Add edge Tiles over any pits
    for y=0,self.level.height-1 do
        for x=0,self.level.width-1 do
            if self.level.layers['floor']:get(x,y) == nil then
                self:_addEdge(x,y)
                self:_addEdgeCorner(x,y)
            end
        end
    end

end

function Level:_addMargin()
    for x=self.level.width-1,0,-1 do
        for y=self.level.height-1,0,-1 do
            self.level.layers['floor']:tileCopy(x,y)
            self.level.layers['floor']:tilePaste(x+1,y+1)
        end
        self.level.layers['floor']:set(x,0,nil)
    end
    for y=self.level.height-1,0,-1 do
        self.level.layers['floor']:set(0,y,nil)
    end
    self.level.width = self.level.width+2
    self.level.height = self.level.height+2
end

function Level:_addEdge(x,y)
    -- Determine which type of edge we need
    local blankEdges = 0
    if self.level.layers['floor']:get(x-1,y) == nil then blankEdges = blankEdges + 1 end
    if self.level.layers['floor']:get(x+1,y) == nil then blankEdges = blankEdges + 1 end
    if self.level.layers['floor']:get(x,y-1) == nil then blankEdges = blankEdges + 1 end
    if self.level.layers['floor']:get(x,y+1) == nil then blankEdges = blankEdges + 1 end

    local et = nil
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

            -- Possible edgeCorner here (one)
        end
    elseif blankEdges == 3 then
        et = 0
        if self.level.layers['floor']:get(x+1,y) ~= nil then r = 5
        elseif self.level.layers['floor']:get(x,y+1) ~= nil then r = 6
        elseif self.level.layers['floor']:get(x-1,y) ~= nil then r = 3
        elseif self.level.layers['floor']:get(x,y-1) ~= nil then r = 0
        end

        -- Possible edgeCorner here (one or 2)
    end

    if et ~= nil then
        self.level.layers['edges']:tileRotate(x,y,r)
        self.level.layers['edges']:set(x,y,edgeTiles[et])
    end
end

function Level:_addEdgeCorner(x,y)
    -- Determine edge corners
    local edgeC = {}
    local edgeCTotal = 0
    if self.level.layers['floor']:get(x-1,y-1) ~= nil
    and self.level.layers['floor']:get(x,y-1) == nil
    and self.level.layers['floor']:get(x-1,y) == nil then
        edgeCTotal = edgeCTotal + 1
        edgeC['tl'] = 1
    end
    if self.level.layers['floor']:get(x+1,y-1) ~= nil
    and self.level.layers['floor']:get(x,y-1) == nil
    and self.level.layers['floor']:get(x+1,y) == nil then
        edgeCTotal = edgeCTotal + 1
        edgeC['tr'] = 1
    end
    if self.level.layers['floor']:get(x-1,y+1) ~= nil
    and self.level.layers['floor']:get(x,y+1) == nil
    and self.level.layers['floor']:get(x-1,y) == nil then
        edgeCTotal = edgeCTotal + 1
        edgeC['bl'] = 1
    end
    if self.level.layers['floor']:get(x+1,y+1) ~= nil
    and self.level.layers['floor']:get(x,y+1) == nil
    and self.level.layers['floor']:get(x+1,y) == nil then
        edgeCTotal = edgeCTotal + 1
        edgeC['br'] = 1
    end

    local et = nil
    local r = 0
    if edgeCTotal == 4 then
        et = 8
        -- no rotation needed
    elseif edgeCTotal == 3 then
        et = 7
        if edgeC['tl'] == nil then r = 5
        elseif edgeC['tr'] == nil then r = 6
        elseif edgeC['br'] == nil then r = 3
        end

    elseif edgeCTotal == 2 then
        if edgeC['tl'] == 1 and edgeC['br'] == 1 then
            et = 9
            r = 5
        elseif edgeC['tr'] == 1 and edgeC['bl'] == 1 then
            et = 9
            r = 0
        else
            et = 6
            -- TODO: rotation
            if edgeC['tl'] == 1 and edgeC['tr'] == 1 then
                r = 0
            elseif edgeC['tr'] == 1 and edgeC['br'] == 1 then
                r = 5
            elseif edgeC['br'] == 1 and edgeC['bl'] == 1 then
                r = 6
            elseif edgeC['bl'] == 1 and edgeC['tl'] == 1 then
                r = 3
            end

        end
    elseif edgeCTotal == 1 then
        et = 5
        if edgeC['tr'] == 1 then r = 5
        elseif edgeC['br'] == 1 then r = 6
        elseif edgeC['bl'] == 1 then r = 3
        end
    end

    if et ~= nil then
        self.level.layers['edgeCorners']:tileRotate(x,y,r)
        self.level.layers['edgeCorners']:set(x,y,edgeTiles[et])
    end
end

return Level
