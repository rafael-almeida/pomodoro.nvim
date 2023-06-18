local ZERO_SECONDS = 0
local ONE_SECOND = 1000
local TWENTY_FIVE_MINUTES = 25 * 60 -- in seconds

local timer
local seconds_remaining

local tick_callback = function()
    seconds_remaining = seconds_remaining - 1
    if seconds_remaining == 0 then
        timer.stop(timer)
    end
end

local reset = function()
    seconds_remaining = TWENTY_FIVE_MINUTES
end

local start = function()
    if not seconds_remaining then
        reset()
    end

    timer = vim.loop.new_timer()
    timer.start(timer, ZERO_SECONDS, ONE_SECOND, tick_callback)
end

local format_time = function(seconds)
    local min = math.floor(seconds / 60)
    local sec = math.floor(seconds % 60)
    return string.format("%02d:%02d", min, sec)
end

local get_remaining_time = function()
    return ' ' .. format_time(seconds_remaining)
end

local M = {}

M.start = start
M.get_remaining_time = get_remaining_time

return M
