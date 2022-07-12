-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local cell = require("cell")

display.setDefault("background", 1, 1, 1, 1)

-- Variables
local sceneGroup = display.newGroup()
local cellTable = {}
local cellWidth = 106
local cellHeight = 106
local turnsAmount = 0
local turn = "X"
local gameFinished = false
local winner = nil

local function displayText()
    local text
    if winner == nil then
        text = "Draw!"
    else
        text = winner .. " wins!"
    end

    local winnerText = display.newText(sceneGroup,
        text, display.contentCenterX, 20, native.systemFont, 86)

    if winner == "O" then
        winnerText:setFillColor(0, 0, 255)
    elseif winner == "X" then
        winnerText:setFillColor(255, 0, 0)
    elseif winner == nil then
        winnerText:setFillColor(0, 0, 0)
    end
end

local function isGameFinished()
    local signs = {"X", "O"}
    for i = 1, #signs do
        if (
                cellTable[1].state == signs[i] and
                cellTable[2].state == signs[i] and
                cellTable[3].state == signs[i]
            ) or
            (
                cellTable[4].state == signs[i] and
                cellTable[5].state == signs[i] and
                cellTable[6].state == signs[i]
            ) or
            (
                cellTable[7].state == signs[i] and
                cellTable[8].state == signs[i] and
                cellTable[9].state == signs[i]
            ) or
            (
                cellTable[1].state == signs[i] and
                cellTable[4].state == signs[i] and
                cellTable[7].state == signs[i]
            ) or
            (
                cellTable[2].state == signs[i] and
                cellTable[5].state == signs[i] and
                cellTable[8].state == signs[i]
            ) or
            (
                cellTable[3].state == signs[i] and
                cellTable[6].state == signs[i] and
                cellTable[9].state == signs[i]
            ) or
            (
                cellTable[1].state == signs[i] and
                cellTable[5].state == signs[i] and
                cellTable[9].state == signs[i]
            ) or
            (
                cellTable[3].state == signs[i] and
                cellTable[5].state == signs[i] and
                cellTable[7].state == signs[i]
            )
        then
            winner = signs[i]
            gameFinished = true
            return true
        end
    end

    if turnsAmount == 9 then
        gameFinished = true
        return true
    end

    return false
end

local function changeTurn()
    if turn == "X" then
        turn = "O"
    elseif turn == "O" then
        turn = "X"
    end
end

local function onTap(event)
    if not gameFinished then
        for i = 1, #cellTable do
            local cell = cellTable[i]
            if cell.active == true then
                cell:changeState(turn)
                changeTurn()
                turnsAmount = turnsAmount + 1
                if isGameFinished() then
                    displayText()
                end
            end
        end
    end
end

Runtime:addEventListener("tap", onTap)

-- Filling screen with cells
local function fillCellTable()
    for i = 0, 2 do
        for j = 0, 2 do
            local x = display.contentCenterX - cellWidth * (j - 1)
            local y = display.contentCenterY - cellHeight * (i - 1)
            local cell = Cell:create(sceneGroup, x, y)
            table.insert(cellTable, cell)
        end
    end
end

fillCellTable()