return {

  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    config = function()
      local notify = require("notify")

      notify.setup({
        stages = "fade_in_slide_out",
        timeout = 3000,
        top_down = true,
        max_width = 80,
        max_height = 30,
        render = "minimal",
        background_colour = "#000000",
        position = "top_right",
      })

      vim.notify = notify
    end,
  },

  -- Noice
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      presets = {
        command_palette = true,
      },

      views = {
        cmdline_popup = {
          position = { row = 5, col = "50%" },
          size = { width = 60, height = "auto" },
        },

        popupmenu = {
          relative = "editor",
          position = { row = 8, col = "50%" },
          size = { width = 60, height = 10 },
          border = { style = "rounded", padding = { 1, 2 } },
        },
      },
    },
  },

  -- Dressing
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
  },

  -- Lualine (modified)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "SmiteshP/nvim-navic",
    },
    event = "VeryLazy",

    config = function()
      local navic = require("nvim-navic")

      -- Save your current material style
      local original = vim.g.material_style

      -- Load Deep Ocean palette for lualine
      vim.g.material_style = "deep ocean"

      require("lualine").setup({
        options = {
          theme = "material-nvim", -- loads the Deep Ocean palette now
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

      -- Restore your actual theme (e.g., "darker")
      vim.g.material_style = original
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

  {
    "declancm/cinnamon.nvim",
    version = "*", -- use latest release
    opts = {
      keymaps = {
        basic = true,
        extra = true,
      },
      options = {
        mode = "window",
        -- decreasing this makes the movement feel "snappier"
        -- Default is often ~1000ms, which is too slow for power users
        max_delta = {
          time = 250, -- Complete ANY scroll within 300ms
        },
      },
    },
  },
}
