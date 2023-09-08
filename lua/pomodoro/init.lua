local config = require('pomodoro.config')
local util = require('pomodoro.util')

local session_duration_in_secs = config.options.session_duration * 60

local Pomodoro = {
    timer = nil,
    time_remaining = session_duration_in_secs,
}

local function open_popup_win()
    local buf = vim.api.nvim_create_buf(false, true)
    local lines = {
        '                     ',
        '      POMODORO       ',
        '                     ',
        '  Session Completed  ',
        '                     ',
    }
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local width = 21
    local height = 5
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

local tick_callback = function()
    if Pomodoro.time_remaining <= 0 then
        vim.schedule(open_popup_win)
        Pomodoro.time_remaining = 0
        Pomodoro.stop_timer()
        return
    end

    Pomodoro.time_remaining = Pomodoro.time_remaining - 1
end

Pomodoro.setup = function(options)
    config.setup(options)

    vim.api.nvim_create_user_command('PomodoroStart', Pomodoro.start_timer, { nargs = 0 })
    vim.api.nvim_create_user_command('PomodoroStop', Pomodoro.stop_timer, { nargs = 0 })
    vim.api.nvim_create_user_command('PomodoroPause', Pomodoro.pause_timer, { nargs = 0 })

    vim.keymap.set('n', '<leader>ts', '<Cmd>PomodoroStart<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>te', '<Cmd>PomodoroStop<CR>', { noremap = true, silent = true })
    vim.keymap.set('n', '<leader>tp', '<Cmd>PomodoroPause<CR>', { noremap = true, silent = true })
end

Pomodoro.start_timer = function()
    if Pomodoro.timer ~= nil then
        return
    end

    Pomodoro.timer = vim.loop.new_timer()
    Pomodoro.timer.start(Pomodoro.timer, 0, 1000, tick_callback)

    local curr_time = os.time()
    util.write_to_log_file(curr_time .. "," .. "start")
end

Pomodoro.pause_timer = function()
    if Pomodoro.timer == nil then
        return
    end

    Pomodoro.clean_up()
    local curr_time = os.time()
    util.write_to_log_file(curr_time .. "," .. "pause")
end

Pomodoro.stop_timer = function()
    if Pomodoro.timer == nil then
        return
    end

    Pomodoro.clean_up()
    local curr_time = os.time()
    util.write_to_log_file(curr_time .. "," .. "stop")
end

Pomodoro.clean_up = function()
    if Pomodoro.timer then
        Pomodoro.timer.stop(Pomodoro.timer)
        Pomodoro.timer = nil
    end
end

Pomodoro.get_remaining_time = function()
    local t = util.format_time(Pomodoro.time_remaining)

    if config.options.icons then
        return config.options.signs.clock .. t
    else
        return t
    end
end

return Pomodoro
