return {
  "stevearc/aerial.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("aerial").setup({
      attach_mode = "global",

      layout = {
        max_width = { 40, 0.2 },
        width = 30,
        min_width = 25,
        default_direction = "right",
        placement = "edge",
      },

      -- 🔥 Show only useful symbols (clean signal)
      filter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Method",
        "Module",
        "Struct",
      },

      -- 🧠 Better context awareness
      highlight_on_hover = true,
      highlight_on_jump = 300,

      -- ⚡ Smooth navigation
      autojump = true,
      manage_folds = false, -- IMPORTANT: we are ditching folding

      -- 🧭 Keep cursor and sidebar in sync
      link_tree_to_folds = false,
      link_folds_to_tree = false,

      -- ✨ Improve visual clarity
      show_guides = true,
      guides = {
        mid_item = "├─",
        last_item = "└─",
        nested_top = "│ ",
        whitespace = "  ",
      },

      -- 🧪 Try to get richer info (depends on LSP)
      lsp = {
        diagnostics_trigger_update = true,
        update_when_errors = true,
      },
    })

    -- Toggle sidebar
    vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>", { desc = "Toggle Symbol Sidebar" })

    -- 🔥 Bonus: jump between functions quickly
    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { desc = "Prev function" })
    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { desc = "Next function" })
  end,
}
