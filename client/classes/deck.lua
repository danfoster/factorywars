local Class = require("hump.class")
local Card = require("classes.card")

local Deck = Class {
}
function Deck:init(cards)
    self.cards = cards
end

return Deck