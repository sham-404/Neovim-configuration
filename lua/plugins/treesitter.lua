return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },

  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },

  config = function()
    require("nvim-treesitter.configs").setup({
      highlight = { enable = true },
      indent = { enable = true },

      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "javascript",
        "typescript",
        "python",
        "json",
        "html",
        "css",
        "c",
      },

      -- ⭐ Textobjects configuration
      textobjects = {
        select = {
          enable = true,
          lookahead = true,

          keymaps = {
            -- Inside / around functions
            ["if"] = "@function.inner",
            ["af"] = "@function.outer",

            -- Inside / around classes, structs
            ["ic"] = "@class.inner",
            ["ac"] = "@class.outer",

            -- Parameters
            ["ia"] = "@parameter.inner",
            ["aa"] = "@parameter.outer",
          },
        },

        move = {
          enable = true,
          set_jumps = true,

          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]c"] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[c"] = "@class.outer",
          },
        },
      },
    })
  end,
}
