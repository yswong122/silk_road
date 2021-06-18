
local countRemain = count
for i,row in ipairs(player1.listOfBazaar) do
    if countRemain == 0 then break end
    for j, tile in ipairs(row) do
        -- check empty tile
        if tile == 0 and countRemain > 0 then
            player1.listOfBazaar[i][j] = goods
            countRemain = countRemain - 1
        elseif countRemain == 0 then
            break
        end
    end
end