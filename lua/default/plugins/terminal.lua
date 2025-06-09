return {{
    'akinsho/toggleterm.nvim',
    config = function()
        require('toggleterm').setup {
            direction = 'float',
            shade_terminal = true
        }
        local wk = require('which-key')

        wk.add({
            { "<leader>tt", "<cmd>ToggleTerm<cr>",                desc = "toggle terminal" },
            { "<leader>ts", "<cmd>ToggleTermSendCurrentLine<cr>", desc = "exec line in terminal" }
        })
    end
}}
