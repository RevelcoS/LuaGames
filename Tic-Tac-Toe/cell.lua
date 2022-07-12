-----------------------------------------------------------------------------------------
--
-- cell.lua
--
-----------------------------------------------------------------------------------------

Cell = {}
Cell.__index = Cell

function Cell:create(scene, x, y)
    local cell = {}
    setmetatable(cell, Cell)

    cell.sceneGroup = scene
    --cell.imagePath = "textures/cell.png"
    cell.x = x
    cell.y = y
    cell.width = 106
    cell.height = 106
    cell.imageRect = display.newImageRect(cell.sceneGroup, "textures/cell.png",
        cell.width, cell.height)
    cell.imageRect.x = x
    cell.imageRect.y = y
    cell.state = nil
    cell.active = false

    cell.imageRect:addEventListener("tap", function() cell.active = true end)

    return cell
end

function Cell:changeState(st)
    self.state = st
    display.remove(self.imageRect)

    if st == "X" then
        self.imageRect = display.newImageRect(self.sceneGroup, "textures/cell_x.png",
            self.width, self.height)
    elseif st == "O" then
        self.imageRect = display.newImageRect(self.sceneGroup, "textures/cell_o.png",
            self.width, self.height)
    end

    self.imageRect.x = self.x
    self.imageRect.y = self.y
    self.active = false

end

return Cell