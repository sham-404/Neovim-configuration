return {
  {
    "marko-cerovac/material.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.material_style = "deep ocean"

      require("material").setup({
        custom_highlights = {
          Cursor = { bg = "#5F8787", fg = "#000000" },

          ["@keyword"] = { fg = "#FF9E64", italic = true },
          ["@keyword.function"] = { fg = "#FF9E64", bold = true, italic = true },
          ["@keyword.return"] = { fg = "#FF9E64", italic = true },
          ["@function"] = { fg = "#82AAFF" },
          ["@conditional"] = { fg = "#FF9E64", bold = true },
          ["@repeat"] = { fg = "#FF9E64", bold = true },
        },
      })

      vim.cmd.colorscheme("material")
    end,
  },
}
