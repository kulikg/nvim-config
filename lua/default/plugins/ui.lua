return {
    {
        'HiPhish/rainbow-delimiters.nvim'
    },
    {
        "shellRaining/hlchunk.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("hlchunk").setup {
                chunk = {
                    enable = true,
                    chars = {
                        horizontal_line = '─',
                        vertical_line = '│',
                        left_top = '╭',
                        left_bottom = '╰',
                        right_arrow = '╼',

                    }
                },
                line_num = {
                    enable = true
                }
            }
        end
    },
    {
        "folke/trouble.nvim",
        opts = {
            win = {
                position = 'top'
            }
        },
        cmd = "Trouble"
    },
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
    },
    {
        'romgrk/barbar.nvim',
        dependencies = {
            'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
            'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
        },
        init = function()
            vim.g.barbar_auto_setup = false
            local wk = require 'which-key'

            local goto_tab = function()
                vim.ui.input({ prompt = 'Goto tab: ' }, function(tab_number)
                    vim.cmd('BufferGoto ' .. tab_number)
                end)
            end

            wk.add {
                { "<leader>b",  group = "Barbar" },
                { "<leader>bh", '<Cmd>BufferPrevious<CR>',                   desc = "Previous tab" },
                { "<leader>bl", '<Cmd>BufferNext<CR>',                       desc = "Next tab" },
                { "<leader>bj", '<Cmd>BufferPick<CR>',                       desc = "Pick tab" },
                { "<leader>bx", '<Cmd>BufferPickDelete<CR>',                 desc = "Pick tab to close" },
                { "<leader>bs", '<Cmd>BufferOrderByDirectory<CR>',           desc = "Sort tabs" },
                { "<leader>bp", '<Cmd>BufferPin<CR>',                        desc = "Pin tab" },
                { "<leader>bo", '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', desc = "Keep pinned" },
                { "<leader>bg", goto_tab,                                    desc = "Goto tab" },
            }
        end,
        opts = {
            -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
            -- animation = true,
            -- insert_at_start = true,
            -- …etc.
        },
        version = '^1.0.0', -- optional: only update when a new 1.x version is released
    }
}
