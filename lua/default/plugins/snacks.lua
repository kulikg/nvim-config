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

            bigfile = { enabled = true },
            input = { enabled = true },
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
        }

        local function grep_word()
            s.picker.grep {
                search = vim.fn.expand("<cword>")
            }
        end

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
            { "<leader>sp", s.picker.pickers,                       desc = "pickers" },
            { "<leader>sl", s.picker.lines,                         desc = "lines" },
            { "<leader>sw", grep_word,                              desc = "grep_word" },

        }


    end


}}
