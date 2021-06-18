state=require("stateswitcher")

function love.draw()
    love.graphics.print("Now is turn " ..turn, 100, 50)
    if subTurn % 2 == 0 then
        love.graphics.print("waiting player 2",100, 100)
        love.graphics.print("Please click to proceed.", 100, 200)
    elseif turn >= 5 and subTurn % 2 == 1 then
        love.graphics.print("All round ends! the winner is ...",100, 100)
        love.graphics.print("Please click to proceed." , 100, 200)
    elseif turn <= 5 then
        love.graphics.print("waiting player 1",100, 100)
        love.graphics.print("Next it's turn " .. turn + 1 , 100, 150)
        love.graphics.print("Please click to proceed.", 100, 200)
    end
end

function love.mousepressed()
    currentPlayer =  2 - subTurn % 2
    -- Change Player 1 to 2 or Change Player2 to 1
    if actionPoints >= 2 then player1.supplies[7] = player1.supplies[7] + 3 end
    player1.name, player2.name = player2.name, player1.name
    player1.supplies, player2.supplies = player2.supplies, player1.supplies
    player1.listOfBazaar, player2.listOfBazaar = player2.listOfBazaar, player1.listOfBazaar
    bazaar1.listOfBazaar, bazaar2.listOfBazaar = bazaar2.listOfBazaar,bazaar1.listOfBazaar
    wareSelector1.listOfBazaar, wareSelector2.listOfBazaar = wareSelector2.listOfBazaar, wareSelector1.listOfBazaar
    player1.listOfTool, player2.listOfTool = player2.listOfTool, player1.listOfTool
    tool1.listOfTool, tool2.listOfTool = tool2.listOfTool, tool1.listOfTool
    player1.hand, player2.hand = player2.hand, player1.hand
    player1.toolActivated = {false, false, false}
    tool1.toolActivated = {false, false, false}
    wareSelector1.item, wareSelector2.item = wareSelector2.item, wareSelector1.item
    actionPoints = 5
    
    -- switching the scenes
    if subTurn % 2 == 0 then
        state.switch("main;".. turn.. ";" .. currentPlayer)
    elseif turn < 5 then
        turn = turn + 1
        state.switch("main;".. turn .. ";" .. currentPlayer)
    else
        local player1_score = player1.supplies[7]
        local player2_score = player2.supplies[7]
        local winner = Nil
        if player1_score > player2_score then
            winner = "player1"
        elseif player2_score > player1_score then
            winner = "player2"
        else
            winner = "tie"
        end
        state.switch("endScreen;" .. winner)
    end
end