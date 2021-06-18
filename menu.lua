-- TODO
state=require("stateswitcher")

function love.draw()
    love.graphics.print("menu",100, 100)
end

function love.mousepressed()
    state.switch("main;")
end