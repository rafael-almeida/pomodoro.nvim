# pomodoro.nvim

## Installation

```lua
use({
    "rafael-almeida/pomodoro.nvim",
    config = function()
        require("pomodoro").setup()
    end
})
```

## Usage

### Configuring lualine

```lua
local pomodoro = require("pomodoro")

require("lualine").setup {
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "diff", "diagnostics" },
        lualine_c = { pomodoro.get_remaining_time }, -- show pomodoro timer
        lualine_x = { "filename" },
        lualine_y = { "progress" },
        lualine_z = { "location" }
    },
}
```
