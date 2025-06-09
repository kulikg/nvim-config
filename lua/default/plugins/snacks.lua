return {{
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        --    bigfile = { enabled = true },
        --    dashboard = { enabled = true },
        explorer = { enabled = true },
        --    indent = { enabled = true },
        input = { enabled = true },
        picker = { enabled = true },
        toggle = { enabled = true },
        terminal = { enabled = true },
        -- notifier = { enabled = true },
        --    quickfile = { enabled = true },
        --    scope = { enabled = true },
        --    scroll = { enabled = true },
        statuscolumn = {
            left = { "mark", "sign" },
            right = { "fold", "git" },
            enabled = true
        },
        --    words = { enabled = true },
    },
}}
