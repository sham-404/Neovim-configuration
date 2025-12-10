return {
	"nvim-telescope/telescope.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "Telescope",
	keys = {
		{ "<leader>ff", "<cmd>Telescope find_files<CR>" },
		{ "<leader>fg", "<cmd>Telescope live_grep<CR>" },
		{ "<leader>fb", "<cmd>Telescope buffers<CR>" },
		{ "<leader>fh", "<cmd>Telescope help_tags<CR>" },
	},
	config = function()
		require("telescope").setup({})
	end,
}
