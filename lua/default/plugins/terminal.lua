return {{
    'akinsho/toggleterm.nvim',
    opts = {
        direction = 'horizontal',
        shade_terminals = true,
        start_in_insert = true
    },
    init = function()
        local wk = require('which-key')

        wk.add({
            { "<leader>tt", "<cmd>ToggleTerm<cr>",  desc = "toggle terminal" },
        })
    end
}}
