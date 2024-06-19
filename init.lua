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

require('vimsetup')

require('lazy').setup{
    'nvim-lua/plenary.nvim',
    'FabijanZulj/blame.nvim',

    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            local wk = require('which-key')
            wk.register({
                ['<leader>'] = {
                    s = {
                        name = "Telescope",
                        g = { "<cmd>Telescope git_grep grep<cr>", "git_grep grep" },
                        l = { "<cmd>Telescope git_grep live_grep<cr>", "git_grep live_grep" },
                        e = { "<cmd>Telescope git_files<cr>", "git_files" },
                        d = { "<cmd>Telescope lsp_definitions<cr>", "lsp definitions" },
                        D = { "<cmd>Telescope diagnostics<cr>", "lsp diagnostics" },
                        i = { "<cmd>Telescope lsp_implementations<cr>", "lsp implementations" },
                        s = { "<cmd>Telescope lsp_workspace_symbols<cr>", "lsp workspace symbols" },
                        r = { "<cmd>Telescope lsp_references<cr>", "lsp references" },
                        ['('] = { "<cmd>Telescope lsp_outgoing_calls<cr>", "lsp outgoing calls" },
                        [')'] = { "<cmd>Telescope lsp_incoming_calls<cr>", "lsp incoming calls" },
                        j = { "<cmd>Telescope jumplist<cr>", "location history" }
                    },
                    t = {
                        name = "Toggleterm",
                        t = { "<cmd>ToggleTerm<cr>", "toggle terminal" },
                        s = { "<cmd>ToggleTermSendCurrentLine<cr>", "exec line in terminal" },
                    },
                }
            })
        end,
    },

    {
        'nvim-tree/nvim-tree.lua',
        config = function()
            require('nvim-tree').setup {
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
                    local api = require('nvim-tree.api')
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

        end
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
            local ts = require('telescope')
            ts.setup {
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

        end
    },

    {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup({})
        end
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
                            require('mason').setup()
                        end
                    },
                    'neovim/nvim-lspconfig'
                },
                config = function()
                    require('mason-lspconfig').setup({})
                end
            },

            {
                'folke/neodev.nvim',
                config = function()
                    require("neodev").setup({
                        override = function(_, library)
                            library.enabled = true
                            library.plugins = true
                            library.types = true
                        end,
                    })
                end
            }

        },
        config = function()
            local lspconfig = require('lspconfig')
            require('cmp_nvim_lsp')
            lspconfig.lua_ls.setup({})
            lspconfig.volar.setup({
                filetypes = {'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json'},
                init_options = {
                    vue = {
                        hybridMode = false
                    }
                }
            })
            lspconfig.docker_compose_language_service.setup({})
            lspconfig.dockerls.setup({})
            lspconfig.yamlls.setup({})
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
                    }
                },
                server = {
                    on_attach = function(_, _)
                        local wk = require('which-key')
                        wk.register({
                            ['<leader>'] = {
                                r = {
                                    name = "Rust",
                                    a = { function() vim.cmd.RustLsp('codeAction') end, "code action" },
                                    j = { function() vim.cmd.RustLsp('joinLines') end, "join lines" },
                                    m = { function() vim.cmd.RustLsp('expandMacro') end, "expand macro" },
                                    i = { function() vim.cmd.RustLsp('moveItem up') end, "move item up" },
                                    k = { function() vim.cmd.RustLsp('moveItem down') end, "move item down" },
                                    e = { function() vim.cmd.RustLsp('explainError') end, "explain error" },
                                    t = { function() vim.cmd.RustLsp('testables') end, "run test" },
                                    r = { vim.lsp.buf.rename, "refactor rename" },
                                    f = { vim.lsp.buf.format, "format code" }
                                },
                                d = {
                                    d = { function() vim.cmd.RustLsp('debug') end, "debug rust" }
                                }
                            }
                        })
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
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
            'hrsh7th/vim-vsnip',
        },
        config = function()
            local cmp = require 'cmp'
            cmp.setup({
                -- Enable LSP snippets
                snippet = {
                    expand = function(args)
                        vim.fn['vsnip#anonymous'](args.body)
                    end,
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
                                "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css",
                            }
                        },
                    },
                    { name = 'path' },
                    {
                        name = 'nvim_lsp',
                        keyword_length = 1,
                        entry_filter = function(entry, _)
                            return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Snippet'
                        end,
                    },      -- from language server
                    { name = 'nvim_lsp_signature_help'},
                    { name = 'nvim_lua', keyword_length = 1 },
                    { name = 'buffer', keyword_length = 1 },
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
                            vsnip = '⋗',
                            buffer = 'Ω',
                            path = '🖫',
                        }
                        item.menu = menu_icon[entry.source.name]
                        return item
                    end,
                },
            })

        end
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

            local breakpoint_with_hitcount = function()
                dap.toggle_breakpoint(nil, vim.fn.input('Hit count: ', 2))
            end

            wk.register({
                ['<leader>'] = {
                    d = {
                        b = { function() dap.toggle_breakpoint() end, "toggle breakpoint" },
                        B = { breakpoint_with_hitcount, "toggle breakpoint with hit count" },
                        n = { function() dap.step_into() end, "step into" },
                        o = { function() dap.step_out() end, "step out" },
                        N = { function() dap.step_over() end, "step over" },
                        c = { function() dap.run_to_cursor() end, "run to cursor" },
                        C = { function() dap.continue() end, "continue" },
                        r = { function() dap.restart() end, "restart" },
                        l = { logger, "log line" },
                        X = { function() dap.clear_breakpoints() end, "clear breakpoints" },
                        q = { function() dap.close() end, "quit" },
                    }
                }
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
            local dapui = require('dapui')
            dapui.setup()
            local wk = require('which-key')
            wk.register({
                ['<leader>'] = {
                    d = {
                        R = { function() dapui.float_element('repl', {enter = true}) end, "show repl" },
                        W = { function() dapui.float_element('watches', {enter = true}) end, "show watches" },
                        L = { function() dapui.float_element('breakpoints', {enter = true}) end, "show breakpoint" },
                        E = { function() dapui.eval(vim.fn.input('Eval: ', vim.fn.getreg('0')), {enter = true}) end, "eval expression" },
                    }
                }
            })
        end
    },

    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = {'rust', 'lua'},

                sync_install = false,

                ignore_install = {},
                modules = {},
                auto_install = true,

                highlight = {
                    enable = true
                }

            })
        end
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
        'NeogitOrg/neogit',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'sindrets/diffview.nvim',
            'ibhagwan/fzf-lua',
        },
        config = function()
            require('neogit').setup({})
        end
    },

    {
        'j-hui/fidget.nvim',
        tag = 'legacy',
        config = function()
            require('fidget').setup()
        end
    },

    {
        'xiyaowong/transparent.nvim',
        config = function()

            --vim.cmd [[ hi @lsp.type.interface guifg=gray ]]
            --vim.cmd [[ hi @lsp.type.class guifg=white ]]
            --vim.cmd [[ hi @lsp.type.namespace guifg=lightgray ]]
            --vim.cmd [[ hi @lsp.type.enum guifg=lightgreen ]]
            vim.cmd [[ hi debugPC guibg=darkblue ]]
            vim.cmd [[ colorscheme slate ]]

            local transparent = require("transparent")
            transparent.setup({
                groups = {
                    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
                    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
                    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
                    'SignColumn', 'CursorLineNr', 'EndOfBuffer',
                },
                extra_groups = {},
                exclude_groups = {}
            })

        end
    },

    {
        'akinsho/toggleterm.nvim',
        config = function()
            require('toggleterm').setup{
                direction = 'float',
                shade_terminal = true
            }
        end
    },

   {
        "Jezda1337/nvim-html-css",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require("html-css").setup{}
        end
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


vim.o.background = 'dark'

require('keybindings')

