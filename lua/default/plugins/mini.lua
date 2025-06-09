return {
    {
        'echasnovski/mini.jump', version = '*',

        opts = {
            mappings = {
                forward = 'f',
                backward = 'F',
                forward_till = 't',
                backward_till = 'T',
                repeat_jump = ';',
            },

            delay = {
                highlight = 250,
                idle_stop = 10000000,
            },

            silent = false,
        },


    },
    {
        'echasnovski/mini.notify', version = '*',

        opts = {
            content = {
                format = nil,
                sort = nil,
            },

            lsp_progress = {
                enable = true,
                level = 'INFO',
                duration_last = 1000,
            },

            window = {
                config = {},
                max_width_share = 0.382,
                winblend = 25,
            },
        },

        init = function()
            local m = require 'mini.notify'
            vim.notify = m.make_notify()
        end
    },
    {
        'echasnovski/mini.trailspace', version = '*',

        opts = {
            only_in_normal_buffers = true,
        },

        init = function()
            local m = require 'mini.trailspace'
            local wk = require 'which-key'
            wk.add {
                { "<leader>m", group = "Mini" },
                { "<leader>mt", m.trim,  desc = "trailspace trim" },
            }
        end

    },
    {
        'echasnovski/mini.splitjoin',
        version = '*',
        opts = {
            mappings = {
                toggle = '',
                split = '',
                join = '',
            },
            detect = {
                brackets = nil,
                separator = ',',
                exclude_regions = nil,
            },
            split = {
                hooks_pre = {},
                hooks_post = {},
            },
            join = {
                hooks_pre = {},
                hooks_post = {},
            },
        },

        init = function ()
            local wk = require 'which-key'
            local m = require 'mini.splitjoin'
            wk.add {
                { "<leader>ms", m.toggle,  desc = "splitjoin" },
            }
        end
    },
}
