return {
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
}
