local M = {
    log_file_path = vim.fn.stdpath('data') .. '/pomodoro_history'
}

M.format_time = function(seconds)
    local min = math.floor(seconds / 60)
    local sec = math.floor(seconds % 60)
    return string.format("%02d:%02d", min, sec)
end

M.write_to_log_file = function(message)
    local file = io.open(M.log_file_path, 'a')

    if not file then
        vim.api.nvim_err_writeln("unable to write to pomodoro_history file")
        return false
    end

    file:write(message .. '\n')
    file:close()
    return true
end


M.read_from_log_file = function()
    local lines = {}

    local file = io.open(M.log_file_path, 'r')

    if not file then
        vim.api.nvim_err_writeln("unable to read from pomodoro_history file")
        return nil
    end

    for line in file:lines() do
        table.insert(lines, line)
    end

    file:close()
    return lines
end


M.get_latest_log = function()
    local lines = M.read_from_log_file()

    if lines and #lines > 0 then
        return lines[#lines]
    else
        return nil
    end
end

return M
