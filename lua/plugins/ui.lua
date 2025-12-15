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
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    config = function()
      local function ram_usage()
        local mem = {}
        for line in io.lines("/proc/meminfo") do
          local k, v = line:match("(%w+):%s+(%d+)")
          if k and v then
            mem[k] = tonumber(v)
          end
        end
        if not mem.MemTotal or not mem.MemAvailable then
          return "󰍛 ?"
        end
        local used = mem.MemTotal - mem.MemAvailable
        local percent = math.floor((used / mem.MemTotal) * 100)
        return "󰍛 " .. percent .. "%%"
      end

      local function clock()
        return " " .. os.date("%H:%M")
      end

      local function smart_filename()
        local name = vim.fn.expand("%:t")
        if name == "" then
          return ""
        end
        return name
      end

      local function smart_progress()
        local current = vim.fn.line(".")
        local total = vim.fn.line("$")

        if total == 0 then
          return ""
        end

        local percent = math.floor((current / total) * 100)

        if percent <= 5 then
          return "TOP"
        elseif percent >= 95 then
          return "BOT"
        else
          return percent .. "%%"
        end
      end

      vim.api.nvim_set_hl(0, "LualinePill", { bg = "#0f1419", fg = "#c0caf5" })
      require("lualine").setup({
        options = { theme = "auto", globalstatus = true },
        sections = {
          lualine_c = {
            {
              smart_filename,
              cond = function()
                return vim.fn.expand("%:t") ~= ""
              end,
            },
          },

          lualine_x = {
            "filetype",
          },

          lualine_y = {
            {
              smart_progress,
              padding = { left = 1, right = 1 },
            },
            { ram_usage, separator = { left = "" } },
          },

          lualine_z = { { clock, padding = { left = 1, right = 1 } } },
        },
        inactive_sections = { lualine_c = {}, lualine_y = {}, lualine_z = {} },
      })
    end,
  }, -- Bufferline
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
