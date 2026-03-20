return {

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

      icon = icon .. " "

      local hl_group = "LualineBatOk"

      if percent <= 15 then
        hl_group = "LualineBatLow"
      elseif percent <= 35 then
        hl_group = "LualineBatMid"
      end

      if stat == "Charging" then
        icon = "" .. icon
        hl_group = "LualineBatChg"
      end

      return string.format("%%#%s#%s %d%%%%", hl_group, icon, percent)
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
      vim.api.nvim_set_hl(0, name, { fg = fg, bg = "#010101" })
    end

    -- Progress
    hl("LualineProg", "#89b4fa")

    -- Battery states
    hl("LualineBatOk", "#a6e3a1")
    hl("LualineBatMid", "#f9e2af")
    hl("LualineBatLow", "#f38ba8")
    hl("LualineBatChg", "#89dceb")

    -- RAM states
    hl("LualineRamOk", "#cdd6f4")
    hl("LualineRamMid", "#f9e2af")
    hl("LualineRamHigh", "#f38ba8")

    -- Separator
    hl("LualineSep", "#cdd6f4")

    local custom_theme = {
      normal = {
        a = { fg = "#010101", bg = "#89b4fa", gui = "bold" },
        b = { fg = "#cdd6f4", bg = "#010101" },
        c = { fg = "#cdd6f4", bg = "#1f2233" },
      },
      insert = {
        a = { fg = "#010101", bg = "#a6e3a1", gui = "bold" },
      },
      visual = {
        a = { fg = "#010101", bg = "#f9e2af", gui = "bold" },
      },
      replace = {
        a = { fg = "#010101", bg = "#f38ba8", gui = "bold" },
      },
      command = {
        a = { fg = "#010101", bg = "#89dceb", gui = "bold" },
      },
      inactive = {
        a = { fg = "#6c7086", bg = "#010101" },
        b = { fg = "#6c7086", bg = "#010101" },
        c = { fg = "#6c7086", bg = "#010101" },
      },
    }

    require("lualine").setup({

      options = {
        theme = custom_theme,
        globalstatus = true,
      },

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

        lualine_z = {
          { clock, padding = { left = 1, right = 1 } },
        },
      },

      inactive_sections = {
        lualine_c = {},
        lualine_y = {},
        lualine_z = {},
      },
    })
  end,
}
