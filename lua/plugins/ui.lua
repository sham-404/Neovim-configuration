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
}

