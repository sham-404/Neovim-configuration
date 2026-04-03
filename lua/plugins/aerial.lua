return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("aerial").setup({
      -- Forces the sidebar to open on the right

      attach_mode = "global",
      layout = {
        max_width = { 40, 0.2 },
        width = 25,
        min_width = 20,
        default_direction = "right",
        placement = "edge",
      },

      -- This is the crucial part: Tells the sidebar exactly what to show
      -- filter_kind = {
      --   "Class",
      --   "Constructor",
      --   "Enum",
      --   "Function",
      --   "Interface",
      --   "Method",
      --   "Module",
      --   "Struct",
      -- },
      -- Highlights the function you are currently inside in the sidebar!
      highlight_on_hover = true,
      autojump = true,
    })

    -- Press <leader>a to pop the right sidebar open or closed
    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle Symbol Sidebar" })
  end,
}
