return {
    {
        'mrcjkb/rustaceanvim',
        dependencies = {
            'folke/which-key.nvim',
            'mfussenegger/nvim-dap',
        },
        version = '^6',
        lazy = false,
        config = function()
            vim.g.rustaceanvim = {
                tools = {
                    float_win_config = {
                        auto_focus = true
                    },
                    test_executor = 'background'
                },
                server = {
                    on_attach = function(_, _)
                        local wk = require 'which-key'
                        local commands = require 'rustaceanvim.commands'

                        wk.add {
                            { "<leader>r",  group = "Rust" },
                            { "<leader>ra", function() vim.cmd.RustLsp("codeAction") end,       desc = "codeAction",     mode = { "n" } },
                            { "<leader>rl", function() vim.cmd.RustLsp("joinLines") end,        desc = "joinLines",      mode = { "n", "v" } },
                            { "<leader>rm", function() vim.cmd.RustLsp("expandMacro") end,      desc = "expandMacro" },
                            { "<leader>ri", function() vim.cmd.RustLsp("moveItem", "up") end,   desc = "moveItem up" },
                            { "<leader>rj", function() vim.cmd.RustLsp("moveItem", "down") end, desc = "moveItem down" },
                            { "<leader>re", function() vim.cmd.RustLsp("explainError") end,     desc = "explainError" },
                            { "<leader>rt", function() vim.cmd.RustLsp("testables") end,        desc = "testables" },
                            { "<leader>rr", vim.lsp.buf.rename,                                 desc = "refactor rename" },
                            { "<leader>rf", vim.lsp.buf.format,                                 desc = "format code",    mode = { "n", "v" } },
                            { "<leader>rb", "<cmd>Cargo build --release<cr>",                   desc = "cargo build" },
                            { "<leader>dd", function() vim.cmd.RustLsp("debug") end,            desc = "debuggables" },
                        }
                    end,
                    default_settings = {
                        ['rust-analyzer'] = {
                            assist = {
                                importEnforceGranularity = true,
                                importPrefix = 'crate',
                            },

                            diagnostics = {
                                enable = true,
                            },

                            imports = {
                                granularity = {
                                    group = "module",
                                },
                                prefix = "self",
                            },

                            cargo = {
                                allFeatures = true,
                                buildScripts = {
                                    enable = true,
                                }
                            },

                            inlayHints = {
                                lifetimeElisionHints = {
                                    enable = true,
                                    useParameterNames = true,
                                },
                                maxLength = 1000
                            },

                            procMacro = {
                                enable = true
                            },

                            checkOnSave = {
                                enable = true,
                                command = 'clippy',
                            },
                        }
                    },
                }
            }
        end
    }
}
