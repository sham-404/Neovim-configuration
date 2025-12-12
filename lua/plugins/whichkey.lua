return {
  "folke/which-key.nvim",
  event = "VeryLazy",

  opts = function(_, opts)
    local wk = require("which-key")

    -- keep your existing preset and spec
    opts.preset = "helix"
    opts.spec = {
      {
        mode = { "n", "v" },
        { "<leader>b", group = "Buffers", icon = "󰈯" },
        { "<leader>c", group = "Code", icon = "" },
        { "<leader>f", group = "Find", icon = "" },
        { "<leader>s", group = "Split/Window", icon = "" },
        { "<leader>u", group = "UI", icon = "" },
        { "<leader>q", group = "Quit/Session", icon = "󰗼" },
        { "<leader>g", group = "Git", icon = "" },
        { "<leader>l", group = "Lazy", icon = "󰒲" },
        { "<leader>R", group = "Rename" },
      },
    }
    return opts
  end,
}
