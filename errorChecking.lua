-- all checkings and error handling
-- universal function to check which element did the user click
function checkPressed(object, x, y)
    if (x >= object.x and x <= object.x + object.width) and (y >= object.y and y <= object.y + object.height) then
        return true
    else
        return false
    end
end

-- universal 0 to 255 covert to 0 to 1
function rgbConvertor(r,g,b)
    r, g, b = r / 365, g / 365, b / 365
    return r, g, b
end

-- Check card action constriants
function checkCardType(index)
    if index >= 1 and index < 20 then
        return "contractCard"
    elseif index >= 20 and index < 28 then
        return "toolCard"
    elseif index >= 28 and index < 33 then
        return "eventCard"
    else
        return Nil
    end
end

-- check space
function checkCurrentStorage(player)
    local totalAmountOfGoods = 0
    for i=1,6 do
        totalAmountOfGoods = totalAmountOfGoods + player.supplies[i] 
    end
    return totalAmountOfGoods
end

-- check if buy
function checkIfBuy(button)
    if button == 1 then return true elseif button == 2 then return false else return Nil end
end

-- check enough space for card
function checkIfEnoughSpace(totalAmountOfGoods, size, player)
    if size + totalAmountOfGoods > player.BAZAARSIZE then
        return errorHappened(5)
    else 
        return true
    end
end

-- check if enough cost
function checkIfEnoughCost(listOfCost, listOfGoods)
    for i=1,#listOfGoods do
        if player1.supplies[listOfGoods[i]] < listOfCost[i] then
            return errorHappened(6)
        end
    end
    return true
end

-- check if tool space if full
function checkToolSpace()
    local space = 3
    for i=1, #player1.listOfTool do
        if player1.listOfTool[i] ~= 0 then
            space = space - 1
        end
    end
    return space > 0
end

function checkWare(count, player)
    player = strObjParser(player)
    local counter = 0
    for i=1,#player.supplies - 1 do
        if player.supplies[i] ~= 0 then
            counter = counter + 1
        end
    end
    if counter < count then
        return errorHappened(9)
    else 
        return true
    end
end

function errorHappened(reason)
    warning = true
    errorStatus = reason
    return false
end

errorMessage = {
    "isBuy = Nil", -- 1
    "type = Nil", -- 2
    "eventNum not found", -- 3
    "goods is not in range", -- 4
    "Not enough space", -- 5
    "Not enough supplies", -- 6
    "Not enough card", -- 7
    "Not enough hand card", -- 8
    "Not enough ware", -- 9
    "exceed hand size", -- 10
}