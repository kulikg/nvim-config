return {
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
