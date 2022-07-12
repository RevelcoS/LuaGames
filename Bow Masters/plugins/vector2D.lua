local M = {}

function M.new(x, y)
    local vector = {x, y}

    function vector:angleTo(v)
        local a = self[1] * v[1] + self[2] * v[2]
        local b = (((self[1] ^ 2) + (self[2] ^ 2)) ^ 0.5) * (((v[1] ^ 2) + (v[2] ^ 2)) ^ 0.5)
        local angle = math.deg(math.acos(a / b))
        return angle
    end

    return vector
end

return M