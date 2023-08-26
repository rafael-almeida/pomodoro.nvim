local M = {}

local defaults = {
    session_duration = 0.05,
    icons = true,
    timeout_window = true,
    signs = {
        clock = ' ',
    },
}

M.options = defaults

M.setup = function(options)
    M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
end

return M
