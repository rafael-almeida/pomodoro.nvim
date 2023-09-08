local config = require('pomodoro.config')
local util = require('pomodoro.util')

local session_duration_in_secs
local popup_window_content = {
    '     POMODORO     ',
    ' Session Complete ',
}

local Pomodoro = {
    timer = nil,
    time_remaining = session_duration_in_secs,
}

local tick_callback = function()
    if Pomodoro.time_remaining > 0 then
        Pomodoro.time_remaining = Pomodoro.time_remaining - 1
    else
        Pomodoro.time_remaining = 0
        Pomodoro.stop_timer()

        if config.options.timeout_window then
            vim.schedule(function()
                util.open_popup_window(popup_window_content)
            end)
        end
    end
end

Pomodoro.setup = function()
    config.setup()

    session_duration_in_secs = config.options.session_duration * 60

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
