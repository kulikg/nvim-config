local opts = {
    noremap = false
}

local function map(key, action, mode, o)
    vim.keymap.set(mode or 'n', key, action, o or opts)
end

map('<leader>l', '<c-w><c-l>')
map('<leader>j', '<c-w><c-j>')
map('<leader>k', '<c-w><c-k>')
map('<leader>i', '<c-w><c-i>')
map('<leader>h', '<c-w><c-h>')
map('<backspace>', "<c-o>")
map('<cr>', '<c-6>')
map('<Tab>', '<cmd>NvimTreeFindFileToggle<cr>')

map('<Esc>', '<C-\\><C-n>', 't')

return {}
