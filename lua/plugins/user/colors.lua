return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "night", -- or "storm", "moon", "day"
    transparent = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = true },
      sidebars = "transparent",
      floats = "transparent",
      functions = {},
      variables = {},
    },
  },
  -- config = function(_, opts)
  --   require("tokyonight").setup(opts)
  --   vim.cmd.colorscheme("tokyonight")
  -- end,
}
