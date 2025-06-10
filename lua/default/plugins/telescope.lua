return {{
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
        'nvim-lua/plenary.nvim',
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
        },
        {
            'davvid/telescope-git-grep.nvim',
            branch = 'main'
        },
    },
    config = function()
        local open_with_trouble = require "trouble.sources.telescope".open
        local ts = require 'telescope'
        ts.setup {
            defaults = {
                mappings = {
                    i = { ['<S-Tab>'] = open_with_trouble },
                    n = { ['<S-Tab>'] = open_with_trouble },
                },
            },
            pickers = {
                git_files = {
                    previewer = false
                },
                git_grep = {
                    use_git_root = true
                }
            }
        }

        ts.load_extension('git_grep')
        ts.load_extension('fzf')

        local wk = require 'which-key'
        local t = require 'telescope.builtin'

        wk.add {
--            { "<leader>s",  group = "Telescope" },
--            { "<leader>sf", "<cmd>Telescope git_grep<cr>",   desc = "git_grep" },
--            { "<leader>se", t.git_files,                     desc = "git_files" },
--            { "<leader>sh", t.oldfiles,                      desc = "oldfiles" },
--            { "<leader>sd", t.lsp_definitions,               desc = "lsp_definitions" },
--            { "<leader>st", t.lsp_type_definitions,          desc = "lsp_definitions" },
--            { "<leader>sD", t.diagnostics,                   desc = "diagnostics" },
--            { "<leader>si", t.lsp_implementations,           desc = "lsp_implementations" },
--            { "<leader>ss", t.lsp_dynamic_workspace_symbols, desc = "lsp_workspace_symbols" },
--            { "<leader>sr", t.lsp_references,                desc = "lsp_references" },
--            { "<leader>s(", t.lsp_outgoing_calls,            desc = "lsp_outgoing_calls" },
--            { "<leader>s)", t.lsp_incoming_calls,            desc = "lsp_incoming_calls" },
--            { "<leader>sS", t.lsp_document_symbols,          desc = "lsp_document_symbols" },
--            { "<leader>sj", t.jumplist,                      desc = "jumplist" },

            { "<leader>t",  group = "Toggle tools" },
            { "<leader>td", "<cmd>Trouble diagnostics<cr>",  desc = "toggle diagnostics" }
        }
    end
}}
