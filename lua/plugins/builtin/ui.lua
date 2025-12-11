return {

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")

      notify.setup({
        stages = "fade_in_slide_out",
        timeout = 3000,
        top_down = true, -- stack downward
        max_width = 80,
        max_height = 30,
        render = "minimal",
        background_colour = "#000000",

        -- ⭐ THE IMPORTANT PART
        position = "top_right",
      })

      vim.notify = notify
    end,
  },

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
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "SmiteshP/nvim-navic",
    },
    event = "VeryLazy",

    config = function()
      local navic = require("nvim-navic")

      require("lualine").setup({
        options = {
          theme = "material",
          globalstatus = true,
        },

        sections = {
          lualine_c = {
            { "filename" },
            {
              function()
                return navic.get_location()
              end,
              cond = function()
                return navic.is_available()
              end,
            },
          },
        },
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
