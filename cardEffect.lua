-- storing all card effects
-- 0 = Nil, 1 = silk, 2 = porcelain, 3 = tea, 4 = honey, 5 = cotton, 6 = spice 7 = coin
-- (count, goods, paid, revenue)
contractCardEffectList = {
    -- 3 of a kind
    {{3, 1, 3, 10}},
    {{3, 2, 3, 10}},
    {{3, 3, 3, 10}},
    {{3, 4, 3, 10}},
    {{3, 5, 3, 10}},
    {{3, 6, 3, 10}},
    -- 2 + 1
    {{2, 1, 4, 11},{1, 5, 4, 11}},
    {{2, 2, 4, 11},{1, 4, 4, 11}},
    {{2, 3, 4, 11},{1, 4, 4, 11}},
    {{2, 6, 4, 11},{1, 1, 4, 11}},
    {{2, 5, 4, 11},{1, 2, 4, 11}},
    {{2, 6, 4, 11},{1, 3, 4, 11}},
    -- 3 dif
    {{1, 1, 6, 15},{1, 2, 6, 15},{1, 4, 6, 15}},                     
    {{1, 2, 6, 15},{1, 3, 6, 15},{1, 4, 6, 15}},
    {{1, 3, 6, 15},{1, 5, 6, 15},{1, 6, 6, 15}},
    {{1, 4, 6, 15},{1, 6, 6, 15},{1, 1, 6, 15}},
    {{1, 5, 6, 15},{1, 2, 6, 15},{1, 3, 6, 15}},
    {{1, 6, 6, 15},{1, 1, 6, 15},{1, 5, 6, 15}},
    -- 6 dif (why)
    {{1, 1, 10, 24},{1, 2, 10, 24},{1, 3, 10, 24},{1, 4, 10, 24},{1, 5, 10, 24},{1, 6, 10, 24}}
}

-- list of card name TODO: image
contractCardName = {
    "3 si",
    "3 p",
    "3 t",
    "3 h",
    "3 c",
    "3 sp",
    "2 si 1 c",
    "2 p 1 sp",
    "2 t 1 h",
    "2 sp 1 s",
    "2 c 1 p",
    "2 h 1 t",
    "1 si 1 p 1 h",
    "1 p 1 t 1 h",
    "1 t 1 c 1 sp",
    "1 h 1 sp 1 si",
    "1 c 1 p 1 t",
    "1 sp 1 si 1 c",
    "6 dif"
}


-- Card Activation on hand
function cardActivates(index, button)
    local validActivation = false
    local type = checkCardType(index)
    if type == "contractCard" then
        local cardInfo, size = retrieveCardInfo(index, contractCardEffectList)
        local currentStorage = checkCurrentStorage(player1)
        local isBuy = checkIfBuy(button)
        local listOfCost, listOfGoods = retrieveCost(isBuy, cardInfo)
        local enoughSpace = false
        if isBuy == true then
            enoughSpace = checkIfEnoughSpace(currentStorage, size, player1)
        elseif isBuy == false then
            enoughSpace = true
        else 
            return errorHappened(1)
        end
        local enoughCost = false
        enoughCost = checkIfEnoughCost(listOfCost, listOfGoods)
        validActivation = enoughCost and enoughSpace
        if validActivation == true then
            initialCost(listOfCost, listOfGoods)
            activateContractEffects(isBuy,cardInfo)
            deck:transferToCardDispose(index)
        end
    elseif type == "toolCard" then
        if checkToolSpace() == false then
            player1.listOfTool[1] = index
        else
            for i=1, #player1.listOfTool do
                if player1.listOfTool[i] == 0 then
                    player1.listOfTool[i] = index
                    break
                end
            end
        end
        validActivation = true
    elseif type == "eventCard" then
        validActivation = retrieveEventCardActions(index)
        if validActivation == true then
            deck:transferToCardDispose(index)
        end
    elseif type == Nil then return errorHappened(2) 
    end
    return validActivation
end

-- tool cards
function toolCardsActivates(toolNum)
    local toolNum = toolNum - 19
    local toolInfo = toolsCardEffectList[toolNum]
    local funcs = toolInfo[1]
    local arguments = toolInfo[2]
    local validActivation = false
    for i=1,#funcs do
        validActivation = retrieveToolActions(funcs[i], arguments[i],toolNum)
        if validActivation == false then
            break
        end
    end
    return validActivation
end

function retrieveToolActions(func, arguments, toolNum)
    activeToolNum = toolNum
    local count = 0
    for a in pairs(arguments) do count = count + 1 end
    if count == 1 then    
        validActivation = func(arguments[1])
    elseif count == 2 then
        validActivation = func(arguments[1], arguments[2])
    elseif count == 3 then
        validActivation = func(arguments[1], arguments[2], arguments[3])
    end
    return validActivation
end

-- retrieve info of card and size
function retrieveCardInfo(index, table)
    local size = 0
    local cardInfo = table[index]
    if #cardInfo == 1 then
        size = 3
    else
        for j,effect in ipairs(cardInfo) do
            size = size + effect[1]
        end
    end
    return cardInfo, size
end

function retrieveEventCardActions(index)
    mousepressedFreeze = true
    local eventNum = index - 27
    activeEventNum = eventNum
    if eventNum == 1 then
        validActivation = selectWare(1, player1)
    elseif eventNum == 2 then
        if #deck.deck > 4 then
            topCardSelector:seeTopCard(4)
            topCardSelector.show = true
            validActivation = true
        end
    elseif eventNum == 3 then
        validActivation = selectWare(1,player1)
    elseif eventNum == 4 then
        validActivation = selectFromAllWare(player1)
    else 
        return errorHappened(3)
    end
    mousepressedFreeze = false
    return validActivation
end

function retrieveCost(isBuy, cardInfo)
    local listOfCost = {}
    local listOfGoods = {}
    if isBuy == true then
        table.insert(listOfCost, cardInfo[1][3])
        table.insert(listOfGoods, 7)
    else
        for i=1,#cardInfo do
            costAmount = cardInfo[i][1]
            costGoods = cardInfo[i][2]
            table.insert(listOfCost, costAmount)
            table.insert(listOfGoods, costGoods)
        end
    end
    return listOfCost,listOfGoods
end



-- Card Effects
-- paying costs for playing a card
function initialCost(listOfCost, listOfGoods)
    for i=1,#listOfCost do
        if listOfGoods[i] > 0 and listOfGoods[i] < 8 then
            suppliesManipulation(-listOfCost[i], listOfGoods[i], player1)
        else
            return errorHappened(4)
        end
    end
end

-- activates
function activateContractEffects(isBuy, cardInfo)
    if isBuy == true then
        for i, effect in ipairs(cardInfo) do
            local count = effect[1]
            local goods = effect[2]
            suppliesManipulation(count, goods, player1)
            bazaar1:contractCardActivate(isBuy, count, goods)
        end
    else
        suppliesManipulation(cardInfo[1][4], 7, player1)
        for i, effect in ipairs(cardInfo) do
            local count = effect[1]
            local goods = effect[2]
            bazaar1:contractCardActivate(isBuy, count, goods)
        end
    end
end


-- changing supplies
function suppliesManipulation (amount, goods, player)
    player = strObjParser(player)
    if player == player1 then
        if amount > 0 then
            wareSelector1:update("add",goods)
        elseif amount < 0 and player.supplies[goods] == -amount then
            wareSelector1:update("remove",goods)
        end
    elseif player == player2 then
        if amount > 0 then
            wareSelector2:update("add",goods)
        elseif amount < 0 and player.supplies[goods] == -amount then
            wareSelector2:update("remove",goods)
        end
    end

    if goods == 0 then
        return print("goods is not in range")
    elseif player.supplies[goods] < -amount then
        return errorHappened(6)
    else
        player.supplies[goods] = player.supplies[goods] + amount
        return true
    end
end

-- if player remove certain card num, if deck remove certain top cards
function removeCardFromObj(obj,cardNumOrCount)
    -- if player
    if obj == player1 or obj == player2 then
        local cardRemoved = table.remove(obj.hand,cardNumOrCount)
        if cardSelect == true then
            table.insert(deck.disposal, cardRemoved)
        end
        return cardRemoved
    else -- if deck
        for i=1,cardNumOrCount do
            deck:transferToCardDispose(table.remove(obj.deck, 1))
        end
    end
end

function drawCard(count, player)
    player = strObjParser(player)
    if #deck.deck >= count then
        deck:mousepressed(count,player)
        return true
    else
        return errorHappened(7)
    end
end

function selectWare(count, player)
    local player = strObjParser(player)
    local enoughWare = checkWare(count,player)
    if enoughWare == false then
        return false
    elseif player == player1 then
        mousepressedFreeze = true
        wareSelector1.show = true
    end
    return true
end

function selectCard(count,player)
    if count ~= 0 then
        local player = strObjParser(player)
        if #player.hand < count then
            return errorHappened(8)
        end
        mousepressedFreeze = true
        cardSelect = true
        cardCount = count
    else
        mousepressedFreeze = false
        cardSelect = false
    end
    return true
end

function giftCard(player,giftedIndex)
    table.insert(player.hand, giftedIndex)
    mousepressedFreeze = false
    return true
end

function selectFromAllWare(player)
    allWareSelector.show = true
    return true
end

--Artwork Related
function getCardName(index) -- TODO change to get artwork
    if index == Nil then
        return Nil
    elseif index >= 1 and index < 20 then
        return contractCardName[index]
    elseif index >= 20 and index < 28 then
        local toolNum = index - 19
        return toolsCardName[toolNum]
    elseif index >= 28 and index < 33 then
        local eventNum = index - 27
        return eventCardName[eventNum]
    elseif index == 0 then
        return ""
    else return Nil
    end
end


-- Tool effect list
-- {{effect function1, effect function2},{{arg1.1, arg.2},{arg2.1, arg2.2}}
toolsCardEffectList = {
    {
        {checkIfEnoughCost,suppliesManipulation,drawCard},
        {{{2},{7}},{-2, 7, "player1"},{1,"player1"}}
    },
    {
        {selectWare},
        {{1,"player1"}}
    },
    {
        {checkWare, selectWare},
        {{1, "player2"}, {1, "player1"}}
    },
    {
        {selectCard},
        {{1, "player1"}}
    },
    {
        {drawCard, drawCard, selectCard},
        {{1,"player1"}, {1,"player1"}, {1,"player1"}}
    },
    {
        {drawCard, drawCard, selectCard},
        {{1,"player1"}, {1,"player1"}, {2, "player1"}}
    },
    {
        {suppliesManipulation, selectFromAllWare},
        {{-2, 7, "player1"}, {"player1"}}
    },
    {
        {selectCard, suppliesManipulation},
        {{1,"player1"}, {4, 7, "player1"}}
    }
}

toolsCardName = {"Salvage","Movable Type","Jian","Seed Drill","Compass","WheelBarrow","Dye Vat","Alchemy furnace"
}

eventCardName = {"subsistence", "seismometer", "Government Contract", "tax relief"}

cardImage = {
    "/card/1.png",
    "/card/2.png",
    "/card/3.png",
    "/card/4.png",
    "/card/5.png",
    "/card/6.png",
    "/card/7.png",
    "/card/8.png",
    "/card/9.png",
    "/card/10.png",
    "/card/11.png",
    "/card/12.png",
    "/card/13.png",
    "/card/14.png",
    "/card/15.png",
    "/card/16.png",
    "/card/17.png",
    "/card/18.png",
    "/card/19.png",
    "/card/20.png",
    "/card/21.png",
    "/card/22.png",
    "/card/23.png",
    "/card/24.png",
    "/card/25.png",
    "/card/26.png",
    "/card/27.png",
    "/card/28.png",
    "/card/29.png",
    "/card/30.png",
    "/card/31.png"
}



-- for toolCardEffectList
function strObjParser(input)
    if input == "player1" then
        return player1
    elseif input == "player2" then
        return player2
    else 
        return input
    end
end
