vim.lsp.log.set_level(vim.log.levels.OFF)

vim.g.rustfmt_autosave = 0
vim.g.rustfmt_fail_silently = 1

vim.g.mapleader = ","
vim.g.mkdp_filetypes = { "markdown" }
vim.g.cargo_shell_command_runner = '!'

vim.o.timeout = true
vim.o.timeoutlen = 300

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = false
vim.opt.smartcase = false
vim.opt.backspace = {"start", "eol", "indent"}

vim.opt.number = true
vim.opt.scrolloff = 4
vim.opt.signcolumn = "yes"

vim.opt.termguicolors = true
vim.splitright = true

vim.opt.clipboard = 'unnamed'

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false

vim.opt.updatetime = 300
vim.opt.shortmess = vim.opt.shortmess + { c = true }

vim.opt.wildmode = "list:longest,longest,full"

if vim.g.neovide then
    vim.opt.linespace = 0
    vim.g.neovide_scale_factor = 1.0
    vim.g.neovide_text_gamma = 0.0
    vim.g.neovide_text_contrast = 0.5
    vim.g.neovide_underline_stroke_scale = 1.0


    vim.g.neovide_transparency = 0.8
    vim.g.neovide_normal_opacity = 1.0
    vim.g.neovide_fullscreen = true
    vim.g.neovide_refresh_rate_idle = 1

    vim.g.neovide_floating_blur_amount_x = 5.0
    vim.g.neovide_floating_blur_amount_y = 5.0

    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 5

    vim.g.neovide_floating_corner_radius = 0.1

    vim.g.neovide_show_border = false

    vim.g.neovide_position_animation_length = 0.15

    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_scroll_animation_length = 0.25
    vim.g.neovide_scroll_animation_far_lines = 1
    vim.g.neovide_cursor_animation_length = 0.02
    vim.g.neovide_cursor_trail_size = 0.8
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_smooth_blink = true

    --vim.o.guifont = "Agave Nerd Font Mono"





    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_input_macos_option_key_is_meta = 'only_left'
end

vim.api.nvim_create_autocmd('CursorHold', {
    pattern = { '*' },
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end
})

vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = { '*' },
--	group = m.augroup('last_loc'),
	callback = function()
		local exclude = { 'gitcommit', 'commit', 'gitrebase' }
		local buf = vim.api.nvim_get_current_buf()
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
			return
		end
		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local lcount = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
			return
		end
	end,
})

