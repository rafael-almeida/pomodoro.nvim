local M = {
    log_file_path = vim.fn.stdpath('data') .. '/pomodoro_history'
}

M.open_popup_window = function(lines)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    -- TODO: calculate width and height from lines. 
    -- width = max[x.length for x in lines], height = lines.length
    local width = 18
    local height = 2

    local win_opts = {
        style = 'minimal',
        relative = 'editor',
        width = width,
        height = height,
        row = (vim.o.lines - height) / 2,
        col = (vim.o.columns - width) / 2,
    }

    vim.api.nvim_open_win(buf, true, win_opts)
    vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc>', ':bd!<CR>', { noremap = true, silent = true })
end

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
