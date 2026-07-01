return {
    "williamboman/mason-lspconfig.nvim",
    opts = {
	ensure_installed = {
	    "lua_ls",
	    "pyright",
	    "rust_analyzer",
	    "clangd",
	    "jdtls",
	}
    },
    dependencies = {
	{
	    "williamboman/mason.nvim",
	    opts = {
		ui = {
		    icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗"
		    }
		}
	    }
	},
	"neovim/nvim-lspconfig"
    }
}
