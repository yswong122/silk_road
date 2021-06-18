-- TODO
state=require("stateswitcher")

ChangePlayer = Object:extend()

function ChangePlayer:new()
    self.x = 40
    self.y = 480
    self.width = 130
    self.height = 50
end


function ChangePlayer:draw()
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.print("End Turn", self.x, self.y)
end

function ChangePlayer:mousepressed()
    subTurn = subTurn + 1
    state.switch("waitingRoom;" .. subTurn)
end
