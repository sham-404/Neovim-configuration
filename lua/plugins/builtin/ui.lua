return {
  -- Noice (commandline + messages)

  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        command_palette = true, -- enable the Lazy-like popup
      },

      views = {
        cmdline_popup = {
          position = {
            row = 5, -- move DOWN from top; adjust to taste
            col = "50%", -- center horizontally
          },
          size = {
            width = 60, -- typical LazyVim width
            height = "auto",
          },
        },

        popupmenu = {
          relative = "editor",
          position = {
            row = 8, -- popupmenu appears below the command line
            col = "50%",
          },
          size = {
            width = 60,
            height = 10,
          },
          border = {
            style = "rounded",
            padding = { 1, 2 },
          },
        },
      },
    },
  },
  -- Dressing (input/select UI)
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = { theme = "material" },
      })
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant",
        diagnostics = "nvim_lsp",
      },
    },
  },

  -- Indent Guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = {
        char = "▏",
      },
      scope = {
        enabled = false,
      },
    },
  },

  -- Icons
  {
    "echasnovski/mini.icons",
    version = false,
    lazy = true,
  },
}
