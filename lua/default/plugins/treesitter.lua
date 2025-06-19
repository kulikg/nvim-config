return {{
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup {
            ensure_installed = {'rust', 'lua', 'java', 'javascript', 'html', 'wgsl', 'wgsl_bevy', 'typescript', 'yaml', 'toml'},

            sync_install = true,

            ignore_install = {},
            modules = {},
            auto_install = true,

            highlight = {
                enable = true
            },

            indent = {
                enable = true,
                disable = { 'java' }
            },

        }
    end
}}
