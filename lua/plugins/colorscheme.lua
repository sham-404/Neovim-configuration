return {
  "marko-cerovac/material.nvim",
  lazy = false,
  priority = 1000,

  -- 1️⃣ Set variant FIRST (before palette creation)
  init = function()
    vim.g.material_style = "deep ocean"
  end,

  -- 2️⃣ Define your custom colors (layered on Deep Ocean)
  opts = function()
    local darker_bg = "#0b0b0c"

    return {
      custom_highlights = function(colors)
        return {
          -- Cursor pop
          Cursor = { bg = "#5F8787", fg = "#000000" },

          -- Deeper matte background, still Deep Ocean
          Normal = { bg = darker_bg },
          NormalNC = { bg = darker_bg },

          -- Floats & borders
          NormalFloat = { bg = "#0d0d0e" },
          FloatBorder = { fg = "#2c2c2f", bg = "#0d0d0e" },

          -- Completion menu
          Pmenu = { bg = "#101011" },
          PmenuSel = { bg = "#1c1c1f" },
        }
      end,
    }
  end,

  -- 3️⃣ Apply theme
  config = function(_, opts)
    require("material").setup(opts)
    vim.cmd.colorscheme("material")
  end,
}
