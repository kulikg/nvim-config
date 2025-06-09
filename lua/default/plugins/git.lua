return {{
    'tanvirtin/vgit.nvim',

    dependencies = {
        'nvim-lua/plenary.nvim',
    },

    config = function()
        local vgit = require 'vgit'
        vgit.setup {
            settings = {
                live_blame = {
                    enabled = false
                }
            }
        }
        local wk = require('which-key')

        wk.add({
            { "<leader>g",  group = "vgit" },
            { "<leader>gd", vgit.project_diff_preview, desc = "project_diff_preview" },
            { "<leader>gl", vgit.project_logs_preview, desc = "project_logs_preview" },
            { "<leader>gc", vgit.project_hunks_qf,     desc = "project_hunks_qf" },
            { "<leader>gh", vgit.buffer_hunk_preview,  desc = "buffer_hunk_preview" },
            { "<leader>gk", vgit.hunk_up,              desc = "hunk_up" },
            { "<leader>gj", vgit.hunk_down,            desc = "hunk_down" },
            { "<leader>gr", vgit.buffer_reset,         desc = "buffer reset" },
        })
    end
}}
