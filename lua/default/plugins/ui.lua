return {
    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
        opts = {}
    },
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
        cmd = "Trouble",

        init = function()
            local wk = require 'which-key'
            wk.add {
                { "<leader>t",  group = "Toggle tools" },
                { "<leader>td", "<cmd>Trouble diagnostics<cr>",  desc = "toggle diagnostics" }
            }
        end,
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

            local function close_non_pwd_buffers()
                local cwd = vim.fn.getcwd()
                local buffers = vim.api.nvim_list_bufs()

                for _, buf in ipairs(buffers) do
                    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
                        local buf_name = vim.api.nvim_buf_get_name(buf)

                        if buf_name ~= "" then
                            local abs_path = vim.fn.fnamemodify(buf_name, ':p')
                            local match = abs_path:match(cwd) or abs_path:match("\\[")
                            local con = abs_path:match(":")

                            if not match and not con then
                                require 'mini.bufremove'.delete(buf, false)
                            end

                        end
                    end
                end
            end

            local zoom_state = true

            local function zoom()
                if zoom_state then
                    vim.cmd[[tab split]]
                    vim.api.nvim_set_option_value('laststatus', 0, {})
                    vim.api.nvim_set_option_value('showtabline', 0, {})
                else
                    vim.cmd[[tabc]]
                    vim.api.nvim_set_option_value('laststatus', 2, {})
                    vim.api.nvim_set_option_value('showtabline', 2, {})
                end
                zoom_state = not zoom_state
            end

            vim.keymap.set('n', '<space>', zoom, { noremap = false })

            wk.add {
                { "<leader>b",  group = "Barbar" },
                { "<leader>bh", '<Cmd>BufferPrevious<CR>',                   desc = "Previous tab" },
                { "<leader>bl", '<Cmd>BufferNext<CR>',                       desc = "Next tab" },
                { "<leader>bj", '<Cmd>BufferPick<CR>',                       desc = "Pick tab" },
                { "<leader>bx", '<Cmd>BufferPickDelete<CR>',                 desc = "Pick tab to close" },
                { "<leader>bs", '<Cmd>BufferOrderByDirectory<CR>',           desc = "Sort tabs" },
                { "<leader>bp", '<Cmd>BufferPin<CR>',                        desc = "Pin tab" },
                { "<leader>bo", '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', desc = "Keep pinned" },
                { "<leader>bk", close_non_pwd_buffers,                       desc = "Keep project" },
                { "<leader>bg", goto_tab,                                    desc = "Goto tab" },
            }
        end,
        opts = {
            focus_on_close = 'previous',
            highlight_alternate = true,
            icons = {
                pinned = {button = '', filename = true},
            },
            insert_at_end = true,

        }
    }
}
