state=require("stateswitcher")
winner=passvar[1]


function love.draw()
    for i=1,2 do
        love.graphics.draw(backgroundImage, (i - 1) * backgroundWidth * 1.1, 0, 0, 1.1)
    end
    if passvar[1] == "player1" then
        love.graphics.print("player 1 wins!", 500, 350)
    elseif passvar[1] == "player2" then
        love.graphics.print("player 2 wins", 500, 350)
    else
        love.graphics.print("Tie!", 500, 350)
    end
end
