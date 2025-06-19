return {{
    "folke/snacks.nvim",
    dependencies = {
        "folke/trouble.nvim",
    },
    priority = 1000,
    lazy = false,
    config = function()
        local wk = require 'which-key'
        local s = require 'snacks'

        s.setup {

            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            --    bigfile = { enabled = true },
            --    dashboard = { enabled = true },
--            explorer = { enabled = true },
            --    indent = { enabled = true },
            input = { enabled = true },
--            win = { enabled = true },
--            layout = { enabled = true },
            scratch = {
                enabled = true,
                win_by_ft = {
                    sh = {
                        keys = {
                            ["send"] = {
                                "<cr>",
                                function(self)
                                    local t = require('toggleterm')
                                    local cmd = vim.api.nvim_get_current_line()
                                    vim.notify("running\n" .. cmd)
                                    t.exec(cmd, 1, nil, nil, nil, nil, true, false)
                                end,
                                desc = "Sent to terminal",
                                mode = { "n" },
                            },
                        },
                    },
                },
            },
            picker = {
                enabled = true,
                layout = {
                    fullscreen = true
                },
                actions = require("trouble.sources.snacks").actions,
                win = {
                    input = {
                        keys = {
                            ["<c-t>"] = {
                                "trouble_open",
                                mode = { "n", "i" },
                            },
                        },
                    },
                },

            },
            toggle = { enabled = true },
--            terminal = { enabled = true },
            -- notifier = { enabled = true },
            --    quickfile = { enabled = true },
            --    scope = { enabled = true },
            --    scroll = { enabled = true },
            statuscolumn = {
                left = { "mark", "sign" },
                right = { "fold", "git" },
                enabled =false
            },
            --    words = { enabled = true },
        }

        wk.add {
            { "<leader>tb", function()
                s.scratch.open{
                    ft = function() return 'sh' end
                }
            end,  desc = "scratch buffer" },

            { "<leader>s",  group = "Pickers" },
            { "<leader>sd", s.picker.lsp_definitions,               desc = "lsp_definitions" },
            { "<leader>st", s.picker.lsp_type_definitions,          desc = "lsp_definitions" },
            { "<leader>sD", s.picker.diagnostics,                   desc = "diagnostics" },
            { "<leader>si", s.picker.lsp_implementations,           desc = "lsp_implementations" },
            { "<leader>ss", s.picker.lsp_workspace_symbols,         desc = "lsp_workspace_symbols" },
            { "<leader>sr", s.picker.lsp_references,                desc = "lsp_references" },
            { "<leader>sh", s.picker.recent,                        desc = "oldfiles" },
            { "<leader>se", s.picker.git_files,                     desc = "git files" },
            { "<leader>sf", s.picker.files,                         desc = "files" },
            { "<leader>sg", s.picker.git_grep,                      desc = "git_grep" },
            { "<leader>sG", s.picker.grep,                          desc = "grep" },

        }


    end


}}
