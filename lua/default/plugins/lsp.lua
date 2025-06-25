return {
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            {
                'williamboman/mason.nvim',
                opts = {},
            },
            'neovim/nvim-lspconfig'
        },
        config = function()
            require("mason-lspconfig").setup {
                automatic_enable = false
            }
        end
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {

            {
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        { path = "luvit-meta/library", words = { "vim%.uv" } },
                    },
                },
            },

            {
                'saghen/blink.cmp'
            }

        },
        config = function()
            local lspconfig = require 'lspconfig'

            local capabilities = require('blink.cmp').get_lsp_capabilities();

            lspconfig.lua_ls.setup {
                on_init = function(client)
                    local path = client.workspace_folders[1].name
                    if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
                        return
                    end

                    client.server_capabilities.diagnosticProvider = nil

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            version = 'LuaJIT'
                        },
                        workspace = {
                            checkThirdParty = false,
                            workspace = {
                                library = {
                                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                    [vim.fn.stdpath("config")] = true,
                                },
                            },
                        }
                    })
                end,
                settings = {
                    Lua = {}
                }
            }

            lspconfig.ts_ls.setup({
                capabilities = capabilities,
                init_options = {
                    preferences = {
                        includeInlayParameterNameHints = 'all',
                        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = false,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = true,
                        includeInlayEnumMemberValueHints = true,
                        importModuleSpecifierPreference = 'non-relative',
                    },
                },
            })

            lspconfig.bashls.setup {
                capabilities = capabilities,
            }
            lspconfig.docker_compose_language_service.setup {
                capabilities = capabilities,
            }
            lspconfig.dockerls.setup {
                capabilities = capabilities,
            }
            lspconfig.yamlls.setup {
                capabilities = capabilities,
            }
            lspconfig.wgsl_analyzer.setup{
                capabilities = capabilities,
            }
            lspconfig.lemminx.setup {
                capabilities = capabilities,
            }
            lspconfig.taplo.setup {
                capabilities = capabilities,
            }

            vim.lsp.inlay_hint.enable(true)
        end,
    }
}
