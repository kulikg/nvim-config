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


vim.cmd [[ tnoremap <Esc> <C-\><C-n> ]]

vim.cmd([[
let g:vimspector_sidebar_width = 85
let g:vimspector_bottombar_height = 15
let g:vimspector_terminal_maxwidth = 70
]])

