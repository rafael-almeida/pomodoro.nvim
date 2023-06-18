local DEFAULT_SESSION_DURATION = 25 * 60

local timer
local seconds_remaining

local tick_callback = function()
    seconds_remaining = seconds_remaining - 1
    if seconds_remaining == 0 then
        timer.stop(timer)
    end
end

local start = function()
    timer = vim.loop.new_timer()
    timer.start(timer, 0, 1000, tick_callback)
end

local setup = function()
    vim.api.nvim_create_user_command("PomodoroStart", start, { nargs = 0 })

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
    start = start,
    get_remaining_time = get_remaining_time,
}
