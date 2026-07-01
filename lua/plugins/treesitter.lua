return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
	local ts = require("nvim-treesitter")
	ts.install({
	    'rust',
	    'c',
	    'cpp',
	    'lua',
	    'java',
	    'python',
	})
    end
}
