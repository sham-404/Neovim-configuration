return {
  "marko-cerovac/material.nvim",
  lazy = false,
  priority = 1000,

  opts = function()
    -- Pull Deep Ocean palette (for lualine only)
    local deep = require("material.colors").main

    -- A darker matte shade for Material Darker variant
    -- Default Darker bg is around #121212, this is deeper without going full black
    local darker_bg = "#0b0b0c"

    return {
      custom_highlights = function(colors)
        return {
          Cursor = { bg = "#5F8787", fg = "#000000" },

          -- Global background slightly deeper/softer
          Normal = { bg = darker_bg },
          NormalNC = { bg = darker_bg },

          -- Floating windows matching the darker tone
          NormalFloat = { bg = "#0d0d0e" },
          FloatBorder = { fg = "#2c2c2f", bg = "#0d0d0e" },

          -- Popupmenu (completion) background
          Pmenu = { bg = "#101011" },
          PmenuSel = { bg = "#1c1c1f" },
        }
      end,
    }
  end,

  config = function(_, opts)
    vim.g.material_style = "deep ocean"

    require("material").setup(opts)
    vim.cmd("colorscheme material")
  end,
}
