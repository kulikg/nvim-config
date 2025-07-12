return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            {
                'theHamsta/nvim-dap-virtual-text',
            },
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

                vim.ui.input({ prompt = 'Log message: ', default = curline .. '' }, function(chosen_line)
                    dap.toggle_breakpoint(nil, nil, chosen_line)
                end)
            end

            local brakepoint_nums = function()
                vim.ui.input({ prompt = 'Hit count: ', default = '2' }, function(chosen_number)
                    dap.toggle_breakpoint(nil, chosen_number)
                end)
            end

            wk.add({
                { "<leader>d",  group = "Debug" },
                { "<leader>db", dap.toggle_breakpoint, desc = "toggle_breakpoint" },
                { "<leader>dB", brakepoint_nums,       desc = "toggle_breakpoint with hit count" },
                { "<leader>dn", dap.step_into,         desc = "step_into" },
                { "<leader>do", dap.step_into,         desc = "step_out" },
                { "<leader>dN", dap.step_over,         desc = "step_over" },
                { "<leader>dc", dap.run_to_cursor,     desc = "run_to_cursor" },
                { "<leader>dC", dap.continue,          desc = "continue" },
                { "<leader>dr", dap.restart,           desc = "restart" },
                { "<leader>dl", logger,                desc = "log line" },
                { "<leader>dX", dap.clear_breakpoints, desc = "clear_breakpoints" },
                { "<leader>dq", dap.close,             desc = "close" },
            })
        end
    },

    {
        'theHamsta/nvim-dap-virtual-text',
        opts = {
            enabled = true,                        -- enable this plugin (the default)
            enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
            highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
            highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
            show_stop_reason = true,               -- show stop reason when stopped for exceptions
            commented = false,                     -- prefix virtual text with comment string
            only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
            all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
            clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
            --- A callback that determines how a variable is displayed or whether it should be omitted
            --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
            --- @param buf number
            --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
            --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
            --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
            --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
            display_callback = function(variable, buf, stackframe, node, options)
                -- by default, strip out new line characters
                if options.virt_text_pos == 'inline' then
                    return ' = ' .. variable.value:gsub("%s+", " ")
                else
                    return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
                end
            end,
            -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
            virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

            -- experimental features:
            all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
            virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
            virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
            -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
        }
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
                { "<leader>dR", function() dapui.float_element('repl', { enter = true }) end,                              desc = "show repl" },
                { "<leader>dW", function() dapui.float_element('watches', { enter = true }) end,                           desc = "show watches" },
                { "<leader>dL", function() dapui.float_element('breakpoints', { enter = true }) end,                       desc = "show breakpoints" },
                { "<leader>dT", function() dapui.float_element('console', { width = 197, height = 58, enter = true }) end, desc = "show console" },
                { "<leader>de", function() dapui.eval() end,                                                               desc = "eval variable",   mode = { 'n' } },
                { "<leader>dE", function() dapui.eval(vim.ui.input('Eval: ', vim.fn.getline(".")), { enter = true }) end,  desc = "eval expression" },
                { "<leader>de", function() dapui.eval(vim.ui.input('Eval: ', vim.fn.getreg("*")), { enter = true }) end,   desc = "eval expression", mode = { 'v' } },
                { "<leader>dt", dapui.toggle,                                                                              desc = "dapui toggle" }
            }
        end
    }
}
