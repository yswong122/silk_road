Player = Object:extend()

function Player:new(name)
    self.HANDSIZE = 7
    self.BAZAARSIZE = 8

    self.name = name
    self.supplies = {
        0, -- 1 : silk
        0, -- 2 = porcelain
        0, -- 3 = tea
        0, -- 4 = honey
        0, -- 5 = cotton
        0, -- 6 = spice
        20 -- 7 = coin
    }

    -- 0 = Nil, 1 = silk, 2 = porcelain, 3 = tea, 4 = honey, 5 = cotton, 6 = spice
    self.listOfBazaar = {
        {0, 0, 0, 0}, 
        {0, 0, 0, 0}
    }
    
    self.listOfTool = {0, 0, 0}
    self.toolActivated = {false, false, false}
    self.hand = {28}
    
    self.x = 60 - 130
    self.y = 600
    self.width = 126
    self.height = 175
end

-- play a card
function Player:mousepressed(button, cardnum)
    validActivation = False
    -- 1 = left, 2 = right
    if cardnum > 0 then
        validActivation = cardActivates(self.hand[cardnum], button)
    end
    if validActivation == true then
        actionPoints = actionPoints - 1
        removeCardFromObj(self,cardnum)
    end
end

-- player's own hand (of cards)
function Player:draw()
    if #self.hand > 0 then
        for i=1, #self.hand do
            local myImage = love.graphics.newImage(cardImage[self.hand[i]])
            love.graphics.draw(myImage, self.x + i * self.width, self.y, 0, 0.7, 0.7)
            -- TODO self.x should move every time card add / remove
        end
    end
end
