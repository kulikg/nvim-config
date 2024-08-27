vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.updatetime = 300
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.swapfile = false
vim.opt.scrolloff = 4
vim.g.mapleader = ","

--vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}

vim.api.nvim_create_autocmd('CursorHold', {
    pattern = { '*' },
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end
})

vim.opt.signcolumn='number'

--vim.cmd([[
--    set signcolumn=number
--]])
