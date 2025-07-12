return {{
    'echasnovski/mini.nvim', version = '*',
    config = function ()
        local wk = require 'which-key'

        local jump = require 'mini.jump'
        local notify = require 'mini.notify'
        local trailspace = require 'mini.trailspace'
        local splitjoin = require 'mini.splitjoin'
        local cursorword = require 'mini.cursorword'
        local sessions = require 'mini.sessions'
        local snacks_win = require 'snacks.win'

        jump.setup {
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
        }

        notify.setup {
            content = {
                format = nil,
                sort = nil,
            },

            lsp_progress = {
                enable = false,
            },

            window = {
                config = {},
                max_width_share = 0.382,
                winblend = 25,
            },
        }

        vim.notify = notify.make_notify()

        trailspace.setup{
            only_in_normal_buffers = true,
        }

        splitjoin.setup {
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
        }

        cursorword.setup {
            delay = 500
        }

        sessions.setup {
            file = '',
            hooks = {
                pre = {
                    read = function ()
                        vim.cmd([[%bd]])
                    end
                }
            }
        }

        local function save_session()
            local folder = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            vim.ui.input({
                primpt = "Name: ",
                default = folder
            }, function(confirmed)
                sessions.write(confirmed)
            end)
        end

        local function delete_session()
           local options = vim.iter(sessions.detected):map(function (k) return k end):totable()
            vim.ui.select(options, {
                prompt = "Delete session"
            }, function (confirmed)
                sessions.delete(confirmed)
            end)
        end

        local function load_session()
            local options = vim.iter(sessions.detected):map(function (k) return k end):totable()
            vim.ui.select(options, {
                prompt = "Load session"
            }, function (confirmed)
                sessions.read(confirmed)
            end)
        end

        wk.add {
            { "<leader>m", group = "Mini" },
            { "<leader>mt", trailspace.trim,  desc = "trailspace trim" },
            { "<leader>ms", splitjoin.toggle,  desc = "splitjoin" },
            { "<leader>ts", save_session,  desc = "save session" },
            { "<leader>tl", load_session,  desc = "load session" },
            { "<leader>tr", delete_session,  desc = "delete session" },
            { "<leader>mN", function()

                local dedup = {}

                local history = vim.iter(notify.get_all()):map(function(row, _)
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

            end,  desc = "notification history" }
        }
    end
}}
