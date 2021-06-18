Tool = Object:extend()

function Tool:new(player)
    self.width = 70
    self.height = self.width
    local width, height, flags = love.window.getMode()
    self.x = (width / 2) - 225
    self.margin = 10
    self.y = 450 * (2 - player.name) + self.margin  -- (bazaar y+margin) + 3 * bazaar height + tool margin
    self.listOfTool = player.listOfTool
    self.toolActivated = player.toolActivated
end

toolsImage = {
    "/toolIcon/t1.png",
    "/toolIcon/t2.png",
    "/toolIcon/t3.png",
    "/toolIcon/t4.png",
    "/toolIcon/t5.png",
    "/toolIcon/t6.png",
    "/toolIcon/t7.png",
    "/toolIcon/t8.png"
}

function Tool:activate(toolIndex)
    validActivation = False
    if toolIndex > 0 and toolIndex <= #self.listOfTool and self.toolActivated[toolIndex] == false then
        validActivation = toolCardsActivates(self.listOfTool[toolIndex])
        if validActivation == true then
            actionPoints = actionPoints - 1
            self.toolActivated[toolIndex] = true
        end
    end
end

function Tool:draw()
    -- TODO if activated turns grey
    for i=1,#self.listOfTool do
        love.graphics.rectangle("line", self.x + i * self.width, self.y , self.width, self.height)
        if self.listOfTool[i] ~= 0 then
            toolNum = self.listOfTool[i] - 19 
            local toolIcon = love.graphics.newImage(toolsImage[toolNum])
            love.graphics.draw(toolIcon, self.x + i * self.width, self.y, 0, 1, 1)
        end
    end
end

