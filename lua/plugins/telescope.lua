return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  -- keys = {
  -- 	{ "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find Files" } },
  -- 	{ "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live Grep" } },
  -- 	{ "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "List Buffers" } },
  -- 	{ "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help Tags" } },
  -- },
  config = function()
    require("telescope").setup({})
  end,
}
