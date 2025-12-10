return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{ "<leader>e", "<cmd>Oil<CR>", desc = "Open parent directory" },
	},
	opts = {
		columns = { "icon" },
		view_options = {
			show_hidden = true,
		},
	},
}
