local M = {}

function M.randrange(range)
    --Return random float from x to y
    x, y = unpack(range)
    return x + math.random() * (y - x)
end

function M.map(t, f)
    --Apply f to elements in table
    local new = {}
    for k, v in pairs(t) do
        new[k] = f(v)
    end
    return new
end

return M