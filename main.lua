-- credit: Font used in game: Ray Larabie's Joystix
-- State switcher Author: Daniel Duris, (CC-BY) 2014
-- classic Copyright (c) 2014, rxi
--Image by https://pixabay.com/users/a_different_perspective-2135817/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=4500910">A_Different_Perspective</a> from <a href="https://pixabay.com/?utm_source=link-attribution&amp;utm_medium=referral&amp;utm_campaign=image&amp;utm_content=4500910"
io.stdout:setvbuf('no')
state=require("stateswitcher")
turn=tonumber(passvar[1]) or 1


function love.load()
    Object = require "classic"
    require "bazaar"
    require "tool"
    require "deck"
    require "player"
    require "changePlayer"
    require "errorChecking"
    require "selector"

    require "cardEffect"
    -- require "menu" uncomment to enable menu
    
    -- import objects
    player1 = Player(1)
    bazaar1 = Bazaar(player1)
    tool1 = Tool(player1)
    
    player2 = Player(2)
    bazaar2 = Bazaar(player2)
    tool2 = Tool(player2)
    wareSelector1 = Selector("selector1", "ware", player1)
    wareSelector2 = Selector("selector2", "ware", player2)
    allWareSelector = Selector("allWare", "allWare", player1)
    topCardSelector = Selector("cardSelector", "deck", player1)
    deck = Deck()
    changePlayer = ChangePlayer()
    -- set up initial states
    subTurn = passvar[2] or 1 -- check player 1 or 2
    currentPlayer = subTurn
    actionPoints = 5

    -- font
    font = love.graphics.newFont("joystix monospace.ttf", 14)
    love.graphics.setFont(font)
    suppliesName = {"Si", "P", "T", "H", "C", "Sp","coin"}
    
    -- draw 5 for each player
    for i=1,5 do
        deck:mousepressed(1, player1)
        deck:mousepressed(1, player2)
    end
    -- timer for warnings
    timer = 0

    -- freeze other mousepressed
    mousepressedFreeze = false

    backgroundImage = love.graphics.newImage("background/main.png")
    backgroundWidth = backgroundImage:getWidth()
    backgroundHeight = backgroundImage:getHeight()
    
end

function love.update(dt)
    -- TODO animation
    -- one thing timer wont reset outside this function except recalling -- warning of all should combined as one? here is an template
    if warning == true then 
        timer = timer + dt
        if timer > 1 then
            warning = false
            timer = 0
        end
    end
    mouseX, mouseY = love.mouse.getPosition()
    hoverCardNum = mouseHover(mouseX, mouseY)
    if hoverCardNum ~= Nil and hoverCardNum ~= 0 then
        hoverCardShow = true
    else
        hoverCardShow = false
    end
end


function love.draw()
    for i=1,2 do
        love.graphics.draw(backgroundImage, (i - 1) * backgroundWidth * 1.1, 0, 0, 1.1)
    end
    --love.graphics.setColor(0.2,0.2,0.2)
    --love.graphics.rectangle("fill", 0, 0, 220, 768)
    --love.graphics.rectangle("fill", 1024 - 220, 0, 220, 768)
    --love.graphics.setColor(1, 1, 1)
    -- showing Userdatas
    love.graphics.print("turn: "..  turn, 10, 20)
    love.graphics.print("Player: " .. currentPlayer, 10, 40)
    love.graphics.print("Your opponent have:\n ".. player2.supplies[7] .. " coins", 10, 120)
    love.graphics.print("Your opponent have:\n " .. #player2.hand .. " cards", 10, 170)
    love.graphics.print("You have:\n " .. player1.supplies[7] .. " coins", 10, 300)
    love.graphics.print("You have:\n " .. #player1.hand .. " cards", 10, 350)
    love.graphics.print("Action Points: " .. actionPoints, 10, 400)
    
    -- drawing interface
    bazaar1:draw()
    bazaar2:draw()
    tool1:draw()
    tool2:draw()
    deck:draw()
    player1:draw()
    changePlayer:draw()
    if wareSelector1.show == true then
        wareSelector1:draw()
    elseif wareSelector2.show == true then
        wareSelector2:draw()
    elseif allWareSelector.show == true then
        allWareSelector:draw()
    elseif topCardSelector.show == true then
        topCardSelector:draw()
    end

    if cardSelect == true and activeToolNum ~= 5 then
        love.graphics.print("please select a card", 200, 550)
    elseif cardSelect == true and activeToolNum == 5 then
        love.graphics.print("please select one of the draw card", 200, 550)
    else end

    if hoverCardShow == true then
        local r, g, b = rgbConvertor(100, 100, 100)
        love.graphics.setColor(r, g, b)
        love.graphics.rectangle("fill", 820, 200, 180, 250)
        love.graphics.setColor(1, 1, 1)
        local myImage = love.graphics.newImage(cardImage[hoverCardNum])
        love.graphics.draw(myImage, 820, 200)
    end

    if warning == true then
        love.graphics.print(errorMessage[errorStatus], 400, 550)
    end
end

function love.mousepressed(x, y, button)
    -- check if clicked deck -- > draw
    if checkPressed(deck, x, y) and actionPoints == 5 and button == 1 and mousepressedFreeze == false then
        deck:mousepressed(2, player1)
        actionPoints = actionPoints - 1
    end
    -- check if clicked cards
    local index = math.floor((x - player1.x) / player1.width)
    if checkPressed(player1,x - index * player1.width, y) and actionPoints > 0 and mousepressedFreeze == false then -- -width because i start with 1 in player draw
        if index <= # player1.hand then
            player1:mousepressed(button, index) -- remember to put : not .
        end
    elseif checkPressed(player1,x - index * player1.width, y)  and cardSelect == true then
        -- seed drill and alchemy
        if index <= # player1.hand and activeToolNum ~= 5 then
            removeCardFromObj(player1,index)
            -- wheelbarrow
            if cardCount > 0 then
                selectCard(cardCount - 1, player1)
            end
            if activeToolNum == 4 then
                cardSelect = false
                allWareSelector.show = true
            elseif activeToolNum == 8 then
                cardSelect = false
            end
        -- compass
        elseif index <= # player1.hand and activeToolNum == 5 then
            local giftedIndex = 0
            if index == #player1.hand then
                giftedIndex = index - 1
            elseif index == #player1.hand - 1 then
                giftedIndex = index + 1
            else 
                giftedIndex = index - 1
            end
            cardSelect = false
            local gift = table.remove(player1.hand, giftedIndex)
            giftCard(player2, gift)
        end
    end

    -- check if end turn
    if checkPressed(changePlayer, x, y) and mousepressedFreeze == false then
        require "waitingRoom"
        changePlayer:mousepressed()
    end

    -- topCardSelector
    local topCard = math.floor((x - topCardSelector.x) / topCardSelector.width)
    if checkPressed(topCardSelector, x - topCard * topCardSelector.width, y) and topCardSelector.show == true then
        local count = #topCardSelector.item
        if topCard <= count and topCard > 0 then
            topCardSelector:mousepressed(topCard)
        end
    end

    local allWareIndex = math.floor((x - allWareSelector.x) / allWareSelector.width)
    if checkPressed(allWareSelector, x - allWareIndex * allWareSelector.width, y) and allWareSelector.show == true then
        local count = #allWareSelector.item
        if allWareIndex <= count and allWareIndex > 0 then
            allWareSelector:mousepressed(allWareIndex)
        end
    end

    local wareIndex2 = math.floor((x - wareSelector2.x) / wareSelector2.width)
    if checkPressed(wareSelector2, x - wareIndex2 * wareSelector2.width, y) and wareSelector2.show == true then
        local count = #wareSelector2.item
        if wareIndex2 <= count and wareIndex2 > 0 then
            wareSelector2:mousepressed(wareIndex2)
        end
    end

    -- wareSelector1
    local wareIndex1 = math.floor((x - wareSelector1.x) / wareSelector1.width)
    if checkPressed(wareSelector1, x - wareIndex1 * wareSelector1.width, y) and wareSelector1.show == true then
        local count = #wareSelector1.item
        if wareIndex1 <= count and wareIndex1 > 0 then
            wareSelector1:mousepressed(wareIndex1)
        end
    end

    -- check if activates tool card
    local toolIndex = math.floor((x - tool1.x) / tool1.width)
    if checkPressed(tool1, x - toolIndex * tool1.width, y) and actionPoints > 0 and mousepressedFreeze == false then
        local count = 0
        for i=1, #player1.listOfTool do
            if player1.listOfTool[i] ~= 0 then
                count = count + 1
            end
        end
        if toolIndex <= count and toolIndex > 0 then
            tool1:activate(toolIndex)
        end
    end
end


-- 0 = Nil, 1 = silk, 2 = porcelain, 3 = tea, 4 = honey, 5 = cotton, 6 = spice
function getSuppliesName(suppliesIndex)
    if suppliesIndex == 0 then return "" end
    return suppliesName[suppliesIndex]
end

suppliesImage = {
    "/icon/silk.png",
    "/icon/porcelain.png",
    "/icon/tea.png",
    "/icon/honey.png",
    "/icon/cotton.png",
    "/icon/spice.png"
}


function mouseHover(x, y)
    -- hovering the hand
    local index = math.floor((x - player1.x) / player1.width)
    if (x > player1.x + player1.width and x < player1.x + player1.width * (player1.HANDSIZE + 1))
    and (y > player1.y and y < player1.y + player1.height) then
        if index <= #player1.hand then
            local hoverCardNum = player1.hand[index]
            return hoverCardNum
        end
    end
    -- hovering the tools
    local toolIndex = math.floor((x - tool1.x) / tool1.width)
    if (x > tool1.x + tool1.width and x < tool1.x + tool1.width * 4)
    and (y > tool1.y and y < tool1.y + tool1.height) then
        if tool1.listOfTool[toolIndex] ~= Nil then
            local hoverCardNum = tool1.listOfTool[toolIndex]
            return hoverCardNum
        end
    end
end

