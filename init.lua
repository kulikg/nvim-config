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

require('lazy').setup({
    'nvim-lua/plenary.nvim',

    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
        }
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
                    { noremap = false, silent = true, buffer = bufnr }
                  )
              end
          }

      end
  },

  {
      'nvim-telescope/telescope.nvim',
      tag = '0.1.4',
      requires = {
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
          telescope = require('telescope')
          telescope.setup {
              pickers = {
                  git_files = {
                      previewer = false
                  },
                  git_grep = {
                      use_git_root = true
                  }
              }
          }

          telescope.load_extension('git_grep')
          telescope.load_extension('fzf')

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
      requires = {
          {
              'folke/neodev.nvim',
              config = function()
                  require("neodev").setup({
                      override = function(root_dir, library)
                          library.enabled = true
                          library.plugins = true
                      end,
                  })
              end
          },
      },
      config = function()
          require 'lsp-zero'

          lspconfig = require('lspconfig')
          cmp_nvim_lsp = require('cmp_nvim_lsp')

          lspconfig.lua_ls.setup({
              settings = {
                  Lua = {
                      workspace = {
                          checkThirdParty = false,
                      },
                  }
              }
          })
          lspconfig.rust_analyzer.setup({
              capabilities = cmp_nvim_lsp.default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
              ),
          })

          --vim.g.lsp_zero_extend_cmp = 0
          --vim.g.lsp_zero_extend_lspconfig = 0

      end
  },


  {
      'williamboman/mason.nvim',
      config = function()
          require('mason').setup()
      end
  },

  {
      'williamboman/mason-lspconfig.nvim',
      dependencies = {
          {
              'VonHeikemen/lsp-zero.nvim',
              branch = 'v3.x',
              requires = {
                  {'neovim/nvim-lspconfig'},             -- Required
                  {'williamboman/mason.nvim'},
                  {'williamboman/mason-lspconfig.nvim'}, -- Optional

                  {'hrsh7th/nvim-cmp'},
                  {'hrsh7th/cmp-nvim-lsp'},
                  {'L3MON4D3/LuaSnip'},
              },
              config = function()
                  lsp_zero = require('lsp-zero')
                  lsp_zero.on_attach(function(client, bufnr)
                      lsp_zero.default_keymaps({buffer = bufnr})
                  end)
              end
          },
          'neovim/nvim-lspconfig',
          'williamboman/mason.nvim'
      },
      config = function()
          require('mason-lspconfig').setup({
              ensure_installed = {},
              handlers = {
                  lsp_zero.default_setup,
              },
          })

      end
  },

  {
      'simrat39/rust-tools.nvim',
      config = function()
          require('rust-tools').setup({
              tools = {
                  hover_actions = {
                  }
              },
              server = {
                  on_attach = function(_, bufnr)
                      vim.keymap.set('n', '<C-space>', rt.hover_actions.hover_actions, { buffer = bufnr })
                      vim.keymap.set('n', '<Leader>a', rt.code_action_group.code_action_group, { buffer = bufnr })
                  end,
              },
          })

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
                  { name = 'path' },                              -- file paths
                  {
                      name = 'nvim_lsp',
                      keyword_length = 1,
                      entry_filter = function(entry, ctx)
                          return require('cmp.types').lsp.CompletionItemKind[entry:get_kind()] ~= 'Snippet'
                      end,
                  },      -- from language server
                  { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
                  { name = 'nvim_lua', keyword_length = 1 },       -- complete neovim's Lua runtime API such vim.lsp.*
                  { name = 'buffer', keyword_length = 1 },        -- source current buffer
                  --    { name = 'calc'},                               -- source for math calculation
              },
              window = {
                  completion = cmp.config.window.bordered(),
                  documentation = cmp.config.window.bordered(),
              },
              formatting = {
                  fields = {'menu', 'abbr', 'kind'},
                  format = function(entry, item)
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
      'nvim-treesitter/nvim-treesitter',
      required = {
          'tree-sitter/tree-sitter-rust',
      },
      config = function()
          require('nvim-treesitter.configs').setup {
              ensure_installed = { 'lua', 'rust', 'toml' },
              auto_install = true,
              highlight = {
                  enable = true,
                  additional_vim_regex_highlighting=false,
              },
              ident = { enable = true },
              rainbow = {
                  enable = true,
                  extended_mode = true,
                  max_file_lines = nil,
              }
          }

      end
  },

  'puremourning/vimspector',
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
              should_enable = function(bufnr) return true end,
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


  { 'ellisonleao/gruvbox.nvim', priority = 1000 , config = true, opts = {
      transparent_mode = true,
      contrast = 'hard'
  }},

  { 'nvimdev/lspsaga.nvim',
  config = function()
      require('lspsaga').setup({
          lightbulb = {
              enable = false
          }
      })
  end,
  dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons'
  }}

})


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
        source = 'always',
        header = '',
        prefix = '',
    },
})


vim.o.background = 'dark'
vim.cmd([[colorscheme gruvbox]])

require('keybindings')

