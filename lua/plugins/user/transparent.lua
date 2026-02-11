return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("transparent").setup({
   extra_groups = {
    "NormalFloat",
    "FloatBorder",
    "WhichKey",
    "WhichKeyFloat",
    "WhichKeyBorder",
    "WhichKeyDesc",
    "WhichKeyGroup",
    "WhichKeySeparator",
    "WhichKeyValue",
  },     exclude_groups = {
        -- main bar
        "BufferLineFill",
        "BufferLineBackground",
        "BufferLineBufferVisible",
        "BufferLineBufferSelected",
        "BufferLineSeparator",
        "BufferLineSeparatorVisible",
        "BufferLineSeparatorSelected",

        -- tabs & icons
        "BufferLineTab",
        "BufferLineTabSelected",
        "BufferLineTabClose",
        "BufferLineCloseButton",
        "BufferLineCloseButtonVisible",
        "BufferLineCloseButtonSelected",
        "BufferLineDevIconDefault",
        "BufferLineDevIconSelected",
        "BufferLineDevIconVisible",

        "LualineProg",
        "LualineBatOk",
        "LualineBatMid",
        "LualineBatLow",
        "LualineBatChg",
        "LualineRamOk",
        "LualineRamMid",
        "LualineRamHigh",
        "LualineSep",
      },
    })
  end,
}
