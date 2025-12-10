return {
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {},
	},
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			vim.notify = require("notify")
		end,
	},
	{
		"echasnovski/mini.animate",
		version = false,
		event = "VeryLazy",
		config = function()
			require("mini.animate").setup({
				scroll = { enable = false }, -- keep it minimal
			})
		end,
	},
}
