return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		require("mason").setup({})
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls", "tsserver", "pyright" },
		})

		local lspconfig = require("lspconfig")

		lspconfig.lua_ls.setup({
			settings = {
				Lua = { diagnostics = { globals = { "vim" } } },
			},
		})

		lspconfig.tsserver.setup({})
		lspconfig.pyright.setup({})
	end,
}
