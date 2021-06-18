Bazaar = Object:extend()

function Bazaar:new(player) -- player should be put here
    self.width = 75
    self.height = self.width
    local width, height, flags = love.window.getMode()
    self.x = (width / 2) - (self.width * 3) - 50 -- -1 self.width for getting top left swift
    self.margin = 20
    self.y = 200 * (2 - player.name)  + self.margin -- 200: player 1
    self.listOfBazaar = player.listOfBazaar
end


function Bazaar:contractCardActivate(isBuy, count, goods)
    if isBuy == true then
        return bazaarManipulation("gain", count, goods, player1)
    else
        return bazaarManipulation("loss", count, goods, player1)
    end
end

function Bazaar:draw()
    local bazaarImage = love.graphics.newImage("background/bazaar.png")
    love.graphics.draw(bazaarImage, self.x + self.width, self.y + self.height)
    for i,row in ipairs(self.listOfBazaar) do
        for j, tile in ipairs(row) do
            if suppliesImage[tile] ~= Nil then
                local myImage = love.graphics.newImage(suppliesImage[tile])
                love.graphics.draw(myImage, self.x + j * self.width + 18, self.y + i * self.height + 18, 0, 0.7, 0.7)
            end
        end
    end
end

function bazaarManipulation(type, amount, goods, player)
    if type == "gain" then
        checkforTile = 0
        resultTile = goods
    elseif type == "loss" then
        checkforTile = goods
        resultTile = 0
    end

    local countRemain = amount
    for i,row in ipairs(player.listOfBazaar) do
        if countRemain == 0 then break end
        for j, tile in ipairs(row) do
            -- check empty tile
            if tile == checkforTile and countRemain > 0 then
                player.listOfBazaar[i][j] = resultTile
                countRemain = countRemain - 1
            elseif countRemain == 0 then
                break
            end
        end
    end
    return true
end