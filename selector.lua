Selector = Object:extend()

function Selector:new(name, type, player)
    self.name = name
    self.type = type
    self.show = false
    
    local width, height, flags = love.window.getMode()
    
    self.item = {}
    
    self.listOfBazaar = player.listOfBazaar
    self.borderWidth = 400
    self.borderHeight = 140
    self.borderX = width / 2 - self.borderWidth / 2
    self.borderY = 400

    -- item slot
    self.width = 60
    self.height = 60
    self.x = self.borderX - self.width + 20
    self.y = self.borderY + 50

    self.selectCount = 1

    if type == "allWare" then
        self.item = {1, 2, 3, 4, 5, 6}
    end

    if type == "deck" then
        self.borderWidth = 500
        self.borderHeight = 200
        self.width = 100
        self.height = 120
    end
    subsistenceSelected = false
    wareCount = 0
end

function Selector:seeTopCard(count)
    if self.type == "deck" then
        for i=1,count do
            local topCard = deck.deck[i]
            table.insert(self.item, topCard)
        end
    end
end


function Selector:update(type,goods)
    if #self.item > 0 then
        for i,v in ipairs(self.item) do
            if v == goods and type == "remove" and goods ~= 7 then
                table.remove(self.item,i)
                break
            elseif v == goods and type == "add" and goods ~= 7 then
                return
            end
        end
    end
    if type == "add" and goods ~= 7 then
        table.insert(self.item,goods)
    else
        return
    end
end

function Selector:mousepressed(wareIndex)
    self.show = false
    mousepressedFreeze = false
    
    if activeToolNum == 2 then
        suppliesManipulation(self.selectCount, self.item[wareIndex], player1)
        bazaarManipulation("loss", self.selectCount,self.item[wareIndex], player1)
        drawCard(1, "player1")
    elseif activeToolNum == 3 then
        if self.name == "selector1" then
            wareTransferred = self.item[wareIndex]
            suppliesManipulation(-self.selectCount, wareTransferred, player1)
            suppliesManipulation(self.selectCount, wareTransferred, player2)
            bazaarManipulation("loss", self.selectCount, wareTransferred, player1)
            bazaarManipulation("gain", self.selectCount, wareTransferred, player2)
            wareSelector2.show = true
            activeSelector = 2
        elseif self.name == "selector2" then
            wareTransferred = self.item[wareIndex]
            suppliesManipulation(self.selectCount, wareTransferred, player1)
            suppliesManipulation(-self.selectCount, wareTransferred, player2)
            bazaarManipulation("loss", self.selectCount, wareTransferred, player2)
            bazaarManipulation("gain", self.selectCount, wareTransferred, player1)
        end
    elseif activeToolNum == 4 or activeToolNum == 7 then
        suppliesManipulation(self.selectCount, self.item[wareIndex], player1)
        bazaarManipulation("gain", self.selectCount, self.item[wareIndex], player1)
    elseif activeEventNum == 1 and subsistenceSelected == false then
        local tradedWare = self.item[wareIndex]
        wareCount = player1.supplies[tradedWare]
        suppliesManipulation(-wareCount, tradedWare, player1)
        bazaarManipulation("loss", wareCount, tradedWare, player1)
        subsistenceSelected = true
        allWareSelector.show = true
    elseif subsistenceSelected == true then
        local tradedWare = self.item[wareIndex]
        suppliesManipulation(wareCount, tradedWare, player1)
        bazaarManipulation("gain", wareCount, tradedWare, player1)
        wareCount = 0
        subsistenceSelected = false
    elseif activeEventNum == 2 then
        table.insert(player1.hand, self.item[wareIndex])
        table.remove(deck.deck, wareIndex)
        self.item = {}
    elseif activeEventNum == 3 then
        local wareSold = self.item[wareIndex]
        local wareCount = player1.supplies[wareSold]
        suppliesManipulation(-wareCount, wareSold, player1)
        bazaarManipulation("loss", wareCount, wareSold, player1)
        suppliesManipulation(wareCount * 4, 7, player1)
    elseif activeEventNum == 4 then
        local enoughSpace = checkIfEnoughSpace(checkCurrentStorage(player1), 2, player1)
        if enoughSpace == false then
            return errorHappened(5)
        else
            local wareGet = self.item[wareIndex]
            suppliesManipulation(2, wareGet, player1)
            bazaarManipulation("gain", 2, wareGet, player1)
            drawCard(1,player2)
        end
    end
end

function Selector:draw()
    if self.show == true then
        local r, g, b = rgbConvertor(100, 100, 100)
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", self.borderX, self.borderY , self.borderWidth, self.borderHeight)
        love.graphics.setColor(1,1,1)
        if self.type == "ware" then
            love.graphics.print("please choose one ware", self.borderX + self.borderWidth / 5, self.borderY)
        elseif self.type == "deck" then
            
            love.graphics.print("please select 1 card to keep", self.borderX + self.borderWidth / 5, self.borderY)
        else
            love.graphics.print("please choose one ware to receive", self.borderX + self.borderWidth / 5, self.borderY)
        end
        if #self.item > 0 and self.type ~= "deck" then
            for i,v in ipairs(self.item) do
                love.graphics.rectangle("line", self.x + i * self.width, self.y, self.width,self.height)
                if v ~= Nil then
                    local myImage = love.graphics.newImage(suppliesImage[v])
                    love.graphics.draw(myImage, self.x + i * self.width + 9, self.y + 9, 0, 0.7, 0.7)
                end
            end
        elseif #self.item > 0 and self.type == "deck" then
            for i,v in ipairs(self.item) do
                love.graphics.rectangle("line", self.x + i * self.width, self.y, self.width,self.height)
                love.graphics.print(cardImage[v], self.x + i * self.width, self.y)
            end
        end
    end
end
