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
  },

  {
    "akinsho/bufferline.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",

    config = function()
      --------------------------------------------------
      -- Color Palette (your vibe, refined)
      --------------------------------------------------

      local colors = {
        -- Backgrounds
        bar_bg = "#050505",
        inactive_bg = "#101010",
        active_bg = "#3a3a3a",

        -- Text
        active_text = "#cccccc",
        inactive_text = "#7a7a7a",

        -- Diagnostics
        error = "#ff5f5f",
        warning = "#ffaf5f",
        hint = "#8be9fd",

        -- Extras
        modified = "#a6e3a1",
      }

      --------------------------------------------------
      -- Bufferline Setup
      --------------------------------------------------

      require("bufferline").setup({

        options = {
          tab_size = 14,
          always_show_bufferline = true,
          mode = "buffers",
          separator_style = "slant",
          diagnostics = "nvim_lsp",
        },

        highlights = {

          ------------------------------------------------
          -- Base Layer
          ------------------------------------------------

          fill = { bg = colors.bar_bg },

          background = { fg = colors.inactive_text, bg = colors.inactive_bg },
          buffer = { fg = colors.inactive_text, bg = colors.inactive_bg },
          buffer_visible = { fg = colors.inactive_text, bg = colors.inactive_bg },

          numbers = { fg = colors.inactive_text, bg = colors.inactive_bg },
          numbers_visible = { fg = colors.inactive_text, bg = colors.inactive_bg },

          duplicate = { fg = colors.inactive_text, bg = colors.inactive_bg },
          duplicate_visible = { fg = colors.inactive_text, bg = colors.inactive_bg },

          close_button = { fg = colors.inactive_text, bg = colors.inactive_bg },
          close_button_visible = { fg = colors.inactive_text, bg = colors.inactive_bg },

          modified = { fg = colors.modified, bg = colors.inactive_bg },

          ------------------------------------------------
          -- Separators
          ------------------------------------------------

          separator = {
            fg = colors.bar_bg,
            bg = colors.inactive_bg,
          },

          separator_visible = {
            fg = colors.bar_bg,
            bg = colors.inactive_bg,
          },

          separator_selected = {
            fg = colors.bar_bg,
            bg = colors.active_bg,
          },

          tab_separator = {
            fg = colors.inactive_bg,
            bg = colors.inactive_bg,
          },

          tab_separator_selected = {
            fg = colors.active_bg,
            bg = colors.inactive_bg,
          },

          ------------------------------------------------
          -- Inactive Buffers (Diagnostics)
          ------------------------------------------------

          diagnostic = {
            fg = colors.warning,
            bg = colors.inactive_bg,
          },

          error = {
            fg = colors.error,
            bg = colors.inactive_bg,
          },

          warning = {
            fg = colors.warning,
            bg = colors.inactive_bg,
          },

          hint = {
            fg = colors.hint,
            bg = colors.inactive_bg,
          },

          ------------------------------------------------
          -- Selected Buffer
          ------------------------------------------------

          buffer_selected = {
            fg = colors.active_text,
            bg = colors.active_bg,
            bold = true,
          },

          indicator_selected = {
            fg = colors.active_text,
            bg = colors.active_bg,
          },

          close_button_selected = {
            fg = colors.active_text,
            bg = colors.active_bg,
            bold = true,
          },

          duplicate_selected = {
            fg = colors.active_text,
            bg = colors.active_bg,
          },

          modified_selected = {
            fg = colors.modified,
            bg = colors.active_bg,
          },

          ------------------------------------------------
          -- Selected Diagnostics
          ------------------------------------------------

          diagnostic_selected = {
            fg = colors.active_text,
            bg = colors.active_bg,
            bold = true,
          },

          error_selected = {
            fg = colors.error,
            bg = colors.active_bg,
            bold = true,
          },

          warning_selected = {
            fg = colors.warning,
            bg = colors.active_bg,
            bold = true,
          },

          info_selected = {
            fg = colors.active_text,
            bg = colors.active_bg,
          },

          hint_selected = {
            fg = colors.hint,
            bg = colors.active_bg,
            bold = true,
          },

          ------------------------------------------------
          -- Visible Buffers
          ------------------------------------------------

          error_visible = {
            fg = colors.error,
            bg = colors.inactive_bg,
          },

          warning_visible = {
            fg = colors.warning,
            bg = colors.inactive_bg,
          },

          info_visible = {
            fg = colors.active_text,
            bg = colors.inactive_bg,
          },

          hint_visible = {
            fg = colors.hint,
            bg = colors.inactive_bg,
          },
        },
      })
    end,
  },

  -- {
  --   "akinsho/bufferline.nvim",
  --   dependencies = "nvim-tree/nvim-web-devicons",
  --   event = "VeryLazy",
  --
  --   config = function()
  --     --------------------------------------------------
  --     -- Color Palette
  --     --------------------------------------------------
  --
  --     local colors = {
  --       active_text = "#000000",
  --       --active_bg = "#a4f5f1",
  --       active_bg = "#676767",
  --
  --       inactive_bg = "#111111",
  --       bar_bg = "#060606",
  --
  --       error = "#a61818",
  --       warning = "#ee4500",
  --       hint = "#a4f5f1",
  --
  --       modified = "#c3e88d",
  --     }
  --
  --     --------------------------------------------------
  --     -- Bufferline Setup
  --     --------------------------------------------------
  --
  --     require("bufferline").setup({
  --
  --       ------------------------------------------------
  --       -- Options
  --       ------------------------------------------------
  --
  --       options = {
  --         tab_size = 14,
  --         always_show_bufferline = true,
  --         mode = "buffers",
  --         separator_style = "slant",
  --         diagnostics = "nvim_lsp",
  --
  --         -- indicator = { style = "icon" },
  --
  --         --   diagnostics_indicator = function(_, _, diag)
  --         --     local ret = ""
  --         --
  --         --     if diag.error then
  --         --       ret = ret .. "  " .. diag.error
  --         --     end
  --         --
  --         --     if diag.warning then
  --         --       ret = ret .. "  " .. diag.warning
  --         --     end
  --         --
  --         --     return ret
  --         --   end,
  --       },
  --
  --       ------------------------------------------------
  --       -- Highlights
  --       ------------------------------------------------
  --
  --       highlights = {
  --
  --         ------------------------------------------------
  --         -- Base Layer
  --         ------------------------------------------------
  --
  --         fill = { bg = colors.bar_bg },
  --
  --         background = { bg = colors.inactive_bg },
  --         buffer = { bg = colors.inactive_bg },
  --         buffer_visible = { bg = colors.inactive_bg },
  --
  --         numbers = { bg = colors.inactive_bg },
  --         numbers_visible = { bg = colors.inactive_bg },
  --
  --         duplicate = { bg = colors.inactive_bg },
  --         duplicate_visible = { bg = colors.inactive_bg },
  --
  --         close_button = { bg = colors.inactive_bg },
  --         close_button_visible = { bg = colors.inactive_bg },
  --
  --         modified = { bg = colors.inactive_bg },
  --
  --         ------------------------------------------------
  --         -- Separators
  --         ------------------------------------------------
  --
  --         separator = {
  --           fg = colors.bar_bg,
  --           bg = colors.inactive_bg,
  --         },
  --
  --         separator_visible = {
  --           fg = colors.bar_bg,
  --           bg = colors.inactive_bg,
  --         },
  --
  --         separator_selected = {
  --           fg = colors.bar_bg,
  --           bg = colors.active_bg,
  --         },
  --
  --         tab_separator = {
  --           fg = colors.inactive_bg,
  --           bg = colors.inactive_bg,
  --         },
  --
  --         tab_separator_selected = {
  --           fg = colors.active_bg,
  --           bg = colors.inactive_bg,
  --         },
  --
  --         ------------------------------------------------
  --         -- Inactive Buffers
  --         ------------------------------------------------
  --
  --         diagnostic = {
  --           fg = colors.warning,
  --           bg = colors.inactive_bg,
  --         },
  --
  --         error = {
  --           fg = colors.error,
  --           bg = colors.inactive_bg,
  --           bold = true,
  --         },
  --
  --         warning = {
  --           fg = colors.warning,
  --           bg = colors.inactive_bg,
  --         },
  --
  --         hint = {
  --           fg = colors.hint,
  --           bg = colors.inactive_bg,
  --         },
  --
  --         ------------------------------------------------
  --         -- Selected Buffer
  --         ------------------------------------------------
  --
  --         buffer_selected = {
  --           fg = colors.active_text,
  --           bg = colors.active_bg,
  --           bold = true,
  --         },
  --
  --         indicator_selected = {
  --           fg = colors.active_text,
  --           bg = colors.active_bg,
  --         },
  --
  --         close_button_selected = {
  --           fg = colors.active_text,
  --           bg = colors.active_bg,
  --           bold = true,
  --         },
  --
  --         duplicate_selected = {
  --           fg = colors.active_text,
  --           bg = colors.active_bg,
  --         },
  --
  --         modified_selected = {
  --           fg = colors.modified,
  --           bg = colors.active_bg,
  --         },
  --
  --         ------------------------------------------------
  --         -- Selected Diagnostics
  --         ------------------------------------------------
  --
  --         diagnostic_selected = {
  --           fg = colors.active_text,
  --           bg = colors.active_bg,
  --           bold = true,
  --         },
  --
  --         error_selected = {
  --           fg = colors.error,
  --           bg = colors.active_bg,
  --           bold = true,
  --         },
  --
  --         warning_selected = {
  --           fg = colors.warning,
  --           bg = colors.active_bg,
  --           bold = true,
  --         },
  --
  --         info_selected = {
  --           fg = colors.active_text,
  --           bg = colors.active_bg,
  --         },
  --
  --         hint_selected = {
  --           fg = colors.hint,
  --           bg = colors.active_bg,
  --           bold = true,
  --         },
  --
  --         ------------------------------------------------
  --         -- Visible Buffers
  --         ------------------------------------------------
  --
  --         error_visible = {
  --           fg = colors.error,
  --           bg = colors.inactive_bg,
  --         },
  --
  --         warning_visible = {
  --           fg = colors.warning,
  --           bg = colors.inactive_bg,
  --         },
  --
  --         info_visible = {
  --           fg = colors.active_text,
  --           bg = colors.inactive_bg,
  --         },
  --
  --         hint_visible = {
  --           fg = colors.hint,
  --           bg = colors.inactive_bg,
  --         },
  --       },
  --     })
  --   end,
  -- },

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
