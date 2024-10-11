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

vim.g.mapleader = ","
vim.g.mkdp_filetypes = { "markdown" }
vim.o.timeout = true
vim.o.timeoutlen = 300
vim.opt.backup = false
vim.opt.expandtab = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.number = true
vim.opt.rtp:prepend(lazypath)
vim.opt.scrolloff = 4
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = 4
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.updatetime = 300
vim.opt.updatetime = 300
vim.opt.writebackup = false
vim.opt.shortmess = vim.opt.shortmess + { c = true}

vim.api.nvim_create_autocmd('CursorHold', {
    pattern = { '*' },
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end
})

vim.opt.signcolumn='number'


require 'lazy' .setup {
    {
        'EdenEast/nightfox.nvim',
        opts = {
            options = {
                transparent = true,
                styles = {
                    comments = 'italic',
                }
            }
        }
    },

    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
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
        "mfussenegger/nvim-jdtls",
        ft = "java",
        config = function()
            local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

            local workspace_folder = '/tmp/nvim/' .. project_name

            local jdtls_home = require('mason-registry')
            .get_package('jdtls')
            :get_install_path()

            local debug_home = require('mason-registry')
            .get_package('java-debug-adapter')
            :get_install_path()

            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
            local bundles = {}
            vim.list_extend(bundles, vim.split(vim.fn.glob(debug_home .. '/extension/server/com.microsoft.java.debug.plugin-*.jar', true), "\n"))
            vim.list_extend(bundles, vim.split(vim.fn.glob("/home/gabor/envsetup/vscode-java-test/server/*.jar", true), "\n"))
            local root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw', 'pom.xml'}, { upward = true })[1])

            vim.g.jdtls = {
                config = {
                    flags = {
                        debounce_text_changes = 80,
                    },
                    capabilities = capabilities,

                    init_options= {
                        bundles = bundles
                    },
                    root_dir = root_dir,
                    settings = {
                        java = {
                            signatureHelp = { enabled = true },
                            contentProvider = { preferred = 'fernflower' },  -- Use fernflower to decompile library code
                            -- Specify any completion options
                            sources = {
                                organizeImports = {
                                    starThreshold = 9999;
                                    staticStarThreshold = 9999;
                                },
                            },
                            -- How code generation should act
                            codeGeneration = {
                                toString = {
                                    template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
                                },
                                hashCodeEquals = {
                                    useJava7Objects = true,
                                },
                                useBlocks = true,
                            },
                            configuration = {
                                runtimes = {
                                    {
                                        name = "JavaSE-17",
                                        path = "/usr/lib/jvm/java-17-openjdk-amd64/",
                                    },
                                    {
                                        name = "JavaSE-1.8",
                                        path = "/usr/lib/jvm/java-1.8.0-openjdk-amd64/",
                                    },
                                }
                            }
                        }
                    },

                    cmd = {
                        "/usr/lib/jvm/java-17-openjdk-amd64/bin/java",
                        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
                        '-Dosgi.bundles.defaultStartLevel=4',
                        '-Declipse.product=org.eclipse.jdt.ls.core.product',
                        '-Dlog.protocol=true',
                        '-Dlog.level=ERROR',
                        '-Xmx4g',
                        '--add-modules=ALL-SYSTEM',
                        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
                        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                        '-javaagent:' .. jdtls_home .. '/lombok.jar',
                        '-jar', vim.fn.glob(jdtls_home .. '/plugins/org.eclipse.equinox.launcher_*.jar'),
                        '-configuration', jdtls_home .. '/config_linux',
                        '-data', workspace_folder,
                    },
                }
            }
            local jdtls = require 'jdtls'
            jdtls.start_or_attach(vim.g.jdtls.config)

            local wk = require 'which-key'
            wk.add {
                { "<leader>j", group = "Java"},
                { "<leader>jt", jdtls.test_nearest_method, desc = "test nearest method" },
                { "<leader>jT", jdtls.test_class, desc = "test class" },
                { "<leader>ja", vim.lsp.buf.code_action, desc = "codeAction",  mode = { "n", "v" } },
                { "<leader>jr", vim.lsp.buf.rename, desc = "refactor rename" },
                { "<leader>jf", vim.lsp.buf.format, desc = "format code",  mode = { "n", "v" } },
                { "<leader>jo", jdtls.organize_imports, desc = "organize imports" },
                { "<leader>je", jdtls.extract_variable, desc = "extract variable" },
                { "<leader>jc", jdtls.extract_constant, desc = "extract constant" },
                { "<leader>jm", jdtls.extract_method, desc = "extract method" },
                { "<leader>js", jdtls.super_implementation, desc = "super implementation" },
                { "<leader>jS", jdtls.jshell, desc = "jshell with classpath" },
                { "<leader>sd", vim.lsp.buf.definition, desc = "lsp_definitions" }
            }

        end
    },

    {
        'nvim-tree/nvim-tree.lua',
        opts = {
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
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && ./install.sh",
        ft = { "markdown" },
    },

    {
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
                {"<leader>sh", t.oldfiles, desc = "oldfiles" },
                {"<leader>sd", t.lsp_definitions, desc = "lsp_definitions" },
                {"<leader>st", t.lsp_type_definitions, desc = "lsp_definitions" },
                {"<leader>sD", t.diagnostics, desc = "diagnostics" },
                {"<leader>si", t.lsp_implementations, desc = "lsp_implementations" },
                {"<leader>ss", t.lsp_dynamic_workspace_symbols, desc = "lsp_workspace_symbols" },
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
                "folke/lazydev.nvim",
                ft = "lua", -- only load on lua files
                opts = {
                    library = {
                        -- See the configuration section for more details
                        -- Load luvit types when the `vim.uv` word is found
                        { path = "luvit-meta/library", words = { "vim%.uv" } },
                    },
                },
            }


        },
        config = function()
            local lspconfig = require 'lspconfig'
            require 'cmp_nvim_lsp'
            lspconfig.lua_ls.setup{
                on_init = function(client)
                    local path = client.workspace_folders[1].name
                    if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
                        return
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT'
                        },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                -- Depending on the usage, you might want to add additional paths here.
                                "${3rd}/luv/library"
                                -- "${3rd}/busted/library",
                            }
                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                            -- library = vim.api.nvim_get_runtime_file("", true)
                        }
                    })
                end,
                settings = {
                    Lua = {}
                }
            }
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
            'mfussenegger/nvim-dap',
        },
        version = '^5',
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
                            { "<leader>ra", function() vim.cmd.RustLsp("codeAction") end, desc = "codeAction",  mode = { "n", "v" } },
                            { "<leader>rl", function() vim.cmd.RustLsp("joinLines") end, desc = "joinLines",  mode = { "n", "v" } },
                            { "<leader>rm", function() vim.cmd.RustLsp("expandMacro") end, desc = "expandMacro" },
                            { "<leader>ri", function() vim.cmd.RustLsp("moveItem up") end, desc = "moveItem up" },
                            { "<leader>rj", function() vim.cmd.RustLsp("moveItem down") end, desc = "moveItem down" },
                            { "<leader>re", function() vim.cmd.RustLsp("explainError") end, desc = "explainError" },
                            { "<leader>rt", function() vim.cmd.RustLsp("testables") end, desc = "testables" },
                            { "<leader>rr", vim.lsp.buf.rename, desc = "refactor rename" },
                            { "<leader>rf", vim.lsp.buf.format, desc = "format code",  mode = { "n", "v" } },
                            { "<leader>dd", function() vim.cmd.RustLsp("debug") end, desc = "debuggables" },
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
                                "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css",
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
                opts = {
                    all_references = true,
                    virt_text_pos = 'eol'
                }
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
                { "<leader>dB", function() dap.toggle_breakpoint(nil, vim.fn.input('Hit count: ', 2)) end, desc = "toggle_breakpoint with hit count" },
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
                { "<leader>dT", function() dapui.float_element('console', {width = 197, height = 58, enter = true}) end, desc = "show console" },
                { "<leader>de", function() dapui.eval() end, desc = "eval variable", mode = { 'n' } },
                { "<leader>dE", function() dapui.eval(vim.ui.input('Eval: ', vim.fn.getline(".")), {enter = true}) end, desc = "eval expression" },
                { "<leader>de", function() dapui.eval(vim.ui.input('Eval: ', vim.fn.getreg("*")), {enter = true} ) end, desc = "eval expression", mode = { 'v' }},
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
                { "<leader>gh", vgit.buffer_hunk_preview, desc = "buffer_hunk_preview" },
                { "<leader>gk", vgit.hunk_up, desc = "hunk_up" },
                { "<leader>gj", vgit.hunk_down, desc = "hunk_down" },
            })

        end
    },

    {
        'j-hui/fidget.nvim',
        tag = 'v1.4.5',
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

vim.diagnostic.config{
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
}


local opts = {
    noremap = false
}

local function nmap(key, action, o)
    vim.keymap.set('n', key, action, o or opts)
end

nmap('<leader>l', '<c-w><c-l>')
nmap('<leader>j', '<c-w><c-j>')
nmap('<leader>k', '<c-w><c-k>')
nmap('<leader>i', '<c-w><c-i>')
nmap('<leader>h', '<c-w><c-h>')
nmap("<backspace>", "<c-o>")
nmap('<Tab>', '<cmd>NvimTreeFindFileToggle<cr>')


vim.cmd([[
tnoremap <Esc> <C-\><C-n>
autocmd BufNewFile,BufRead *.java lua require 'jdtls' .start_or_attach(vim.g.jdtls.config)

colorscheme terafox
hi LspInlayHint gui=italic
]])


