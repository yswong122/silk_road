Deck = Object:extend()

function Deck:new()
    -- setting up deck
    -- referenced from programming-idioms
    -- https://programming-idioms.org/idiom/10/shuffle-a-list/1313/lua
    local DECKSIZE = 34
    -- hardcoded cardlist
    local numOfCards = {
        1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6,
        7, 7, 8, 8, 9, 9, 10, 10, 11, 11, 12, 12,
        13, 14, 15, 16, 17, 18, 
        19, 19, 19, 19,
        20, 21, 22, 23, 24, 25, 26, 27,
        28, 28, 29, 30, 31
    }
    self.deck = {}
    for i, v in ipairs(numOfCards) do
	    local pos = love.math.random(1, #self.deck+1)
	    table.insert(self.deck, pos, v)
    end
    self.x = 680
    self.y = 300
    self.width = 72
    self.height = 100
    self.disposal = {}
end


function Deck:mousepressed(count, player)
    -- draw num of cards
    for i=1,count do
        if #self.deck > 0 and #player.hand + 1 <= player.HANDSIZE then
            table.insert(player.hand,table.remove(self.deck))
        else
            -- End game TODO
        end
    end
end

function Deck:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    local deckIamge = love.graphics.newImage("icon/deck.png")
    love.graphics.draw(deckIamge, self.x, self.y, 0, 0.9, 0.833)
    love.graphics.print("Card Left: " .. #self.deck, self.x - 30, self.y + self.height + 20)
    -- card disposal
    if self.disposal[#self.disposal] ~= Nil then
        local disposalImage = love.graphics.newImage(cardImage[self.disposal[#self.disposal]])
        love.graphics.draw(disposalImage, self.x, self.y - self.height - 20, 0, 0.4, 0.4)
    else
        love.graphics.rectangle("line", self.x, self.y - self.height - 20, self.width, self.height)
        font = love.graphics.newFont("joystix monospace.ttf", 10)
        love.graphics.setFont(font)
        love.graphics.print("disposal", self.x, self.y - self.height - 20)
        font = love.graphics.newFont("joystix monospace.ttf", 14)
    love.graphics.setFont(font)
    end
end

function Deck:transferToCardDispose(cardnum)
    table.insert(deck.disposal, cardnum)
end
