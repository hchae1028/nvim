require("vim._core.ui2").enable({})

require('config.option')
require('config.keybinds')
require('config.lazy')

vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'c', 'rust', 'java', 'cpp', 'lua', 'python', },
	callback = function()
		vim.treesitter.start()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
})
