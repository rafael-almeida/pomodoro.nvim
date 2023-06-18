local DEFAULT_SESSION_DURATION = 25 * 60

local timer
local seconds_remaining
local is_paused = false

local stop_timer = function()
    if timer == nil then
        return
    end

    timer.stop(timer)
    timer = nil
    seconds_remaining = DEFAULT_SESSION_DURATION
end

local pause_timer = function()
    if timer == nil or is_paused then
        return
    end

    timer.stop(timer)
    timer = nil
end

local tick_callback = function()
    seconds_remaining = seconds_remaining - 1
    if seconds_remaining == 0 then
        stop_timer()
    end
end

local resume_timer = function()
    if timer == nil or not is_paused then
        return
    end

    timer = vim.loop.new_timer()
    timer.start(timer, 0, 1000, tick_callback)
end

local start_timer = function()
    timer = vim.loop.new_timer()
    timer.start(timer, 0, 1000, tick_callback)
end

local setup = function()
    vim.api.nvim_create_user_command("PomodoroStart", start_timer, { nargs = 0 })
    vim.api.nvim_create_user_command("PomodoroStop", stop_timer, { nargs = 0 })
    vim.api.nvim_create_user_command("PomodoroPause", pause_timer, { nargs = 0 })
    vim.api.nvim_create_user_command("PomodoroResume", resume_timer, { nargs = 0 })

    seconds_remaining = DEFAULT_SESSION_DURATION
end

local format_time = function(seconds)
    local min = math.floor(seconds / 60)
    local sec = math.floor(seconds % 60)
    return string.format("%02d:%02d", min, sec)
end

local get_remaining_time = function()
    return ' ' .. format_time(seconds_remaining)
end

return {
    setup = setup,
    start = start_timer,
    stop = stop_timer,
    pause = pause_timer,
    resume = resume_timer,
    get_remaining_time = get_remaining_time,
}
