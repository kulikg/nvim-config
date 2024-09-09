local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require 'vimsetup'

require 'lazy' .setup {
    {
        'EdenEast/nightfox.nvim',
        config = function()
            require 'nightfox' .setup {
                options = {
                    transparent = true,
                    styles = {
                        comments = 'italic',
                    }
                }
            }
            vim.cmd [[ colorscheme terafox ]]
            vim.cmd [[ hi LspInlayHint gui=italic ]]
        end
    },

    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
    },

    {
        "folke/trouble.nvim",
        opts = {
            win = {
                position = 'top'
            }
        },
        cmd = "Trouble"
    },

    {
        'nvim-tree/nvim-tree.lua',
        opts = {
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
    },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.4',
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
            local open_with_trouble = require "trouble.sources.telescope" .open
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
                {"<leader>s", group = "Telescope"},
                {"<leader>sf", "<cmd>Telescope git_grep<cr>", desc = "git_grep" },
                {"<leader>se", t.git_files, desc = "git_files" },
                {"<leader>sd", t.lsp_definitions, desc = "lsp_definitions" },
                {"<leader>sD", t.diagnostics, desc = "diagnostics" },
                {"<leader>si", t.lsp_implementations, desc = "lsp_implementations" },
                {"<leader>ss", t.lsp_workspace_symbols, desc = "lsp_workspace_symbols" },
                {"<leader>sr", t.lsp_references, desc = "lsp_references" },
                {"<leader>s(", t.lsp_outgoing_calls, desc = "lsp_outgoing_calls" },
                {"<leader>s)", t.lsp_incoming_calls, desc = "lsp_incoming_calls" },
                {"<leader>sj", t.jumplist, desc = "jumplist" },

                {"<leader>t", group = "Toggle tools" },
                {"<leader>td", "<cmd>Trouble diagnostics<cr>", desc = "toggle diagnostics" }
            }

        end
    },

    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = true,
    },

    {
        'neovim/nvim-lspconfig',
        dependencies = {
            {
                'williamboman/mason-lspconfig.nvim',
                dependencies = {
                    {
                        'williamboman/mason.nvim',
                        config = function()
                            require 'mason' .setup()
                        end
                    },
                    'neovim/nvim-lspconfig'
                },
                config = true,
            },

            {
                'folke/neodev.nvim',
                opts = {
                    override = function(_, library)
                        library.enabled = true
                        library.plugins = true
                        library.types = true
                    end,
                }
            }

        },
        config = function()
            local lspconfig = require 'lspconfig'
            require 'cmp_nvim_lsp'
            lspconfig.lua_ls.setup{}
            lspconfig.volar.setup {
                filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
                init_options = {
                    vue = {
                        hybridMode = false
                    }
                }
            }
            lspconfig.docker_compose_language_service.setup{}
            lspconfig.dockerls.setup{}
            lspconfig.yamlls.setup{}
            vim.lsp.inlay_hint.enable(true)

        end,
    },

    {
        'mrcjkb/rustaceanvim',
        dependencies = {
            'folke/which-key.nvim',
            'mfussenegger/nvim-dap'
        },
        version = '^4',
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

                        wk.add {
                            { "<leader>r", group = "Rust" },
                            { "<leader>ra", function() vim.cmd.RustLsp("codeAction") end, desc = "codeAction" },
                            { "<leader>rl", function() vim.cmd.RustLsp("joinLines") end, desc = "joinLines" },
                            { "<leader>rm", function() vim.cmd.RustLsp("expandMacro") end, desc = "expandMacro" },
                            { "<leader>ri", function() vim.cmd.RustLsp("moveItem up") end, desc = "moveItem up" },
                            { "<leader>rj", function() vim.cmd.RustLsp("moveItem down") end, desc = "moveItem down" },
                            { "<leader>re", function() vim.cmd.RustLsp("explainError") end, desc = "explainError" },
                            { "<leader>rt", function() vim.cmd.RustLsp("testables") end, desc = "testables" },
                            { "<leader>rr", vim.lsp.buf.rename, desc = "refactor rename" },
                            { "<leader>rf", vim.lsp.buf.format, desc = "format code" },
                            { "<leader>dd", function() vim.cmd.RustLsp("debuggables") end, desc = "debuggables" },
                        }

                    end,
                    default_settings = {
                        ['rust-analyzer'] = {
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
                                buildScripts = {
                                    enable = true,
                                }
                            },
                            procMacro = {
                                enable = true
                            },
                            checkOnSave = {
                                command = 'clippy',
                            },
                        }
                    },
                }
            }
        end
    },

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
                build = "make install_jsregexp"
            },
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'saadparwaiz1/cmp_luasnip'
        },
        config = function()
            local cmp = require 'cmp'
            cmp.setup({
--            opts = {
                snippet = {
                    expand = function(args)
                        require 'luasnip' .lsp_expand(args.body)
                    end
                },
                mapping = {
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    -- Add tab support
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true,
                    })
                },
                -- Installed sources:
                sources = {
                    {
                        name ='html-css',
                        option = {
                            enable_on = {
                                'vue', 'html'
                            },
                            file_extensions = {
                                'html', 'vue'
                            },
                            style_sheets = {
                                --"https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css",
                            }
                        },
                    },
                    { name = 'path' },
                    {
                        name = 'nvim_lsp',
                        keyword_length = 1,
                        entry_filter = function(entry, _)
                            return require 'cmp.types' .lsp.CompletionItemKind[entry:get_kind()] ~= 'Snippet'
                        end,
                    },      -- from language server
                    { name = 'nvim_lsp_signature_help'},
                    { name = 'nvim_lua', keyword_length = 1 },
                    { name = 'buffer', keyword_length = 1 },
                    { name = 'luasnip', option = { show_autosnippets = true, use_show_condition = false } }
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    expandable_indicator = true,
                    fields = {'menu', 'abbr', 'kind'},
                    format = function(entry, item)
                        if entry.source.name == "html-css" then
                            item.menu = entry.completion_item.menu
                            return item
                        end
                        local menu_icon ={
                            nvim_lsp = 'λ',
                            luasnip = '',
                            buffer = '',
                            path = '',
                        }
                        item.menu = menu_icon[entry.source.name]
                        return item
                    end,
                },
            })

        end
    },

    {
        'stevearc/dressing.nvim',
        opts = {
                select = {
                    builtin = {
                        max_width = { 180, 0.9 }
                    }
                }
            }
    },

    {
        'mfussenegger/nvim-dap',
        dependencies = {
            {
                'theHamsta/nvim-dap-virtual-text',
                config = function()
                    require('nvim-dap-virtual-text').setup{
                        all_references = true,
                        virt_text_pos = 'eol'
                    }
                end
            }
        },
        config = function()
            local wk = require('which-key')
            local dap = require('dap')

            local logger = function()
                local row = vim.api.nvim_win_get_cursor(0)[1]
                local curline = ">>> " .. vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]
                dap.toggle_breakpoint(nil, nil, vim.fn.input('Log message: ', curline))
            end

            wk.add({
                { "<leader>d", group = "Debug" },
                { "<leader>db", dap.toggle_breakpoint, desc = "toggle_breakpoint" },
                { "<leader>dB", function() dap.toggle_breakpoint(nil, vm.fn.input('Hit count: ', 2)) end, desc = "toggle_breakpoint with hit count" },
                { "<leader>dn", dap.step_into, desc = "step_into" },
                { "<leader>do", dap.step_into, desc = "step_out" },
                { "<leader>dN", dap.step_over, desc = "step_over" },
                { "<leader>dc", dap.run_to_cursor, desc = "run_to_cursor" },
                { "<leader>dC", dap.continue, desc = "continue" },
                { "<leader>dr", dap.restart, desc = "restart" },
                { "<leader>dl", logger, desc = "log line" },
                { "<leader>dX", dap.clear_breakpoints, desc = "clear_breakpoints" },
                { "<leader>dq", dap.close, desc = "close" },
            })

        end
    },

    {
        'rcarriga/nvim-dap-ui',
        dependencies = {
            'mfussenegger/nvim-dap',
            'nvim-neotest/nvim-nio'
        },
        config = function()
            local dapui = require 'dapui'
            dapui.setup()
            local wk = require 'which-key'

            wk.add {
                { "<leader>dR", function() dapui.float_element('repl', {enter = true}) end, desc = "show repl" },
                { "<leader>dW", function() dapui.float_element('watches', {enter = true}) end, desc = "show watches" },
                { "<leader>dL", function() dapui.float_element('breakpoints', {enter = true}) end, desc = "show breakpoints" },
                { "<leader>dE", function() dapui.eval(vim.fn.input('Eval: ', vim.fn.getreg('0')), {enter = true}) end, desc = "eval expression" },
                { "<leader>dt", dapui.toggle, desc = "dapui toggle" }
            }

        end
    },

   {
        'nvim-treesitter/nvim-treesitter',
        opts = {
            ensure_installed = {'rust', 'lua'},

            sync_install = false,

            ignore_install = {},
            modules = {},
            auto_install = true,

            highlight = {
                enable = true
            }

        }
    },

    {
        'RRethy/vim-illuminate',
        config = function()
            require('illuminate').configure({
                providers = {
                    'lsp',
                    'treesitter',
                    'regex',
                },
                delay = 200,
                filetype_overrides = {},
                filetypes_denylist = {
                    'dirbuf',
                    'dirvish',
                    'fugitive',
                },
                filetypes_allowlist = {},
                modes_denylist = {},
                modes_allowlist = {},
                providers_regex_syntax_denylist = {},
                providers_regex_syntax_allowlist = {},
                under_cursor = true,
                large_file_cutoff = nil,
                large_file_overrides = nil,
                min_count_to_highlight = 1,
                should_enable = function(_) return true end,
                case_insensitive_regex = false,
            })

        end
    },

    {
        'tanvirtin/vgit.nvim',

        dependencies = {
            'nvim-lua/plenary.nvim',
        },

        config = function()
            local vgit = require 'vgit'
            vgit.setup{
                settings = {
                    live_blame = {
                        enabled = false
                    }
                }
            }
            local wk = require('which-key')

            wk.add({
                { "<leader>g", group = "vgit" },
                { "<leader>gd", vgit.project_diff_preview, desc = "project_diff_preview" },
                { "<leader>gl", vgit.project_logs_preview, desc = "project_logs_preview" },
                { "<leader>gc", vgit.project_hunks_qf, desc = "project_hunks_qf" },
                { "<leader>gk", vgit.hunk_up, desc = "hunk_up" },
                { "<leader>gj", vgit.hunk_down, desc = "hunk_down" },
            })

       end
    },

    {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        config = true,
    },

    {
        'akinsho/toggleterm.nvim',
        config = function()
            require('toggleterm').setup{
                direction = 'float',
                shade_terminal = true
            }
            local wk = require('which-key')

            wk.add({
--                { "<leader>t", group = "Toggle tools" },
                { "<leader>tt", "<cmd>ToggleTerm<cr>", desc = "toggle terminal" },
                { "<leader>ts", "<cmd>ToggleTermSendCurrentLine<cr>", desc = "exec line in terminal" }
            })

            end
    },

    {
        "Jezda1337/nvim-html-css",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim"
        },
        config = true,
    }

}


local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({name = 'DiagnosticSignError', text = '☠'})
sign({name = 'DiagnosticSignWarn', text = ''})
sign({name = 'DiagnosticSignHint', text = ''})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = true,
        header = '',
        prefix = '',
    },
})


--vim.o.background = 'dark'

require 'keybindings'

