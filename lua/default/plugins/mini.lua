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
            local wk = require 'which-key'
            local snacks_win = require 'snacks.win'

            wk.add {
                { "<leader>mN", function()

                    local dedup = {}

                    local history = vim.iter(m.get_all()):map(function(row, _)
                        local msg = row.msg:gsub("\n", "\n  ")
                        local line = "* " .. row.level .. " |" .. row.data.source .. "|\n  " .. msg .. "\n"
                        if vim.iter(dedup):all(function(d) return d ~= line end) then
                            dedup[#dedup+1] = line
                            return line
                        end
                    end):filter(function (line) return line ~= nil end):totable()

                    local width = 0
                    local height = 0

                    vim.iter(history):map(function (line) return vim.split(line, "\n") end):flatten(1):each(function (subLine)
                        height = height + 1
                        if #subLine > width then
                            width = #subLine
                        end
                    end)

                    local win = snacks_win.new{
                        fixbuf = true,
                        enter = true,
                        keys = {q = "close"},
                        border = "rounded",
                        width = width + 1,
                        height = height,
                        text = vim.iter(history):join("\n"),
                        bo = {
                            modifiable = false,
                            readonly = true,
                        },
                        wo = {
                            cursorline = false,
                            cursorcolumn = false,
                        },
                    }

                    win:set_title("Notification history", "center")

                end,  desc = "notification history" },
            }
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
