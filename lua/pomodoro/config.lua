local M = {}

local defaults = {
    session_duration = 25,
    icons = true,
    timeout_window = true,
    signs = {
        clock = ' ',
    },
}


M.setup = function()
    M.options = defaults
end

return M
