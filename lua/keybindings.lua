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
nmap('<leader>t', ':ToggleTerm<cr>')
nmap("<backspace>", "<c-o>")
nmap('<leader>e', '<cmd>Telescope git_files<cr>')
nmap('<leader>f', '<cmd>Telescope live_grep<cr>')

nmap('<Tab>', '<cmd>NvimTreeFindFileToggle<cr>')
nmap('<leader>t', '<cmd>ToggleTerm<cr>')
nmap('<leader>m', '<cmd>TSJToggle<cr>')
nmap('T', ':TroubleToggle<cr>')


vim.cmd [[ tnoremap <Esc> <C-\><C-n> ]]

vim.cmd([[
let g:vimspector_sidebar_width = 85
let g:vimspector_bottombar_height = 15
let g:vimspector_terminal_maxwidth = 70
]])


vim.cmd([[
nmap <leader>v <cmd>call vimspector#Launch()<cr>
nmap <F5> <cmd>call vimspector#StepOver()<cr>
nmap <F8> <cmd>call vimspector#Reset()<cr>
nmap <F11> <cmd>call vimspector#StepOver()<cr>")
nmap <F12> <cmd>call vimspector#StepOut()<cr>")
nmap <F10> <cmd>call vimspector#StepInto()<cr>")
]])

nmap("<leader>b", ":call vimspector#ToggleBreakpoint()<cr>")
nmap("Dw", ":call vimspector#AddWatch()<cr>")
nmap("De", ":call vimspector#Evaluate()<cr>")

vim.cmd([[ nmap <Leader>? <Plug>VimspectorBalloonEval ]])


