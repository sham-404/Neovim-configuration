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
          return "%#LualineRamHigh#󰍛 ?%*"
        end

        local used = mem.MemTotal - mem.MemAvailable
        local percent = math.floor((used / mem.MemTotal) * 100)

        local hl_group = "LualineRamOk"
        if percent >= 85 then
          hl_group = "LualineRamHigh"
        elseif percent >= 70 then
          hl_group = "LualineRamMid"
        end

        return string.format("%%#%s#󰍛 %d%%%%", hl_group, percent)
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
        return string.format("%%#LualineProg#%d%%%%", percent)
      end

      local function battery()
        local base = "/sys/class/power_supply"
        local handle = io.popen("ls " .. base .. " | grep BAT")
        local bat = handle and handle:read("*l")
        if handle then
          handle:close()
        end

        if not bat then
          return "%#LualineBatLow# ?"
        end

        local capacity = io.open(base .. "/" .. bat .. "/capacity")
        local status = io.open(base .. "/" .. bat .. "/status")
        if not capacity or not status then
          return "%#LualineBatLow# ?"
        end

        local percent = tonumber(capacity:read("*l"))
        local stat = status:read("*l")
        capacity:close()
        status:close()

        -- Pick icon by percentage
        local icon = ""
        if percent <= 10 then
          icon = ""
        elseif percent <= 30 then
          icon = ""
        elseif percent <= 60 then
          icon = ""
        elseif percent <= 85 then
          icon = ""
        end

        local hl_group = "LualineBatOk"
        if percent <= 15 then
          hl_group = "LualineBatLow"
        elseif percent <= 35 then
          hl_group = "LualineBatMid"
        end

        if stat == "Charging" then
          icon = " " .. icon
          hl_group = "LualineBatChg"
        end

        return string.format("%%#%s#%s  %d%%%%", hl_group, icon, percent)
      end

      local function system_status()
        local sep = "%#LualineSep#  "
        local text = table.concat({
          smart_progress(),
          battery(),
          ram_usage(),
        }, sep)

        return text .. "%*"
      end

      local function hl(name, fg)
        vim.api.nvim_set_hl(0, name, { fg = fg, bg = "#000000" })
      end

      -- Progress
      hl("LualineProg", "#89b4fa") -- soft blue

      -- Battery states
      hl("LualineBatOk", "#a6e3a1") -- green
      hl("LualineBatMid", "#f9e2af") -- yellow
      hl("LualineBatLow", "#f38ba8") -- red
      hl("LualineBatChg", "#89dceb") -- cyan

      -- RAM states
      hl("LualineRamOk", "#cdd6f4") -- neutral
      hl("LualineRamMid", "#f9e2af") -- yellow
      hl("LualineRamHigh", "#f38ba8") -- red

      --      vim.api.nvim_set_hl(0, "StatusLine", { bg = "#000000" })
      --      vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#000000" })

      -- Separator color
      hl("LualineSep", "#cdd6f4")

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
              system_status,
              padding = { left = 1, right = 1 },
            },
          },

          lualine_z = { { clock, padding = { left = 1, right = 1 } } },
        },

        inactive_sections = { lualine_c = {}, lualine_y = {}, lualine_z = {} },
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "slant",
          diagnostics = "nvim_lsp",
          show_buffer_close_icons = false,
          show_close_icon = false,
          indicator = { style = "icon" },
        },
      })
    end,
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
