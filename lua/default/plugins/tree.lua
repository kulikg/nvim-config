return {{
    'nvim-tree/nvim-tree.lua',
    opts = {
        sync_root_with_cwd = true,
        diagnostics = {
            enable = true
        },
        view = {
            width = 60,
            float = {
                enable = true,
                open_win_config = {
                    width = 80,
                    height = 50,
                },
            },
        },
        actions = {
            open_file = {
                window_picker = {
                    enable = false
                }
            }
        },
        filters = {
            dotfiles = true
        },
        renderer = {
            group_empty = true
        },
        on_attach = function(bufnr)
            local api = require 'nvim-tree.api'
            api.config.mappings.default_on_attach(bufnr)
            vim.keymap.set(
                'n', '<Tab>', api.tree.toggle,
                {
                    noremap = false,
                    silent = true,
                    buffer = bufnr
                }
            )
        end
    }
}}
