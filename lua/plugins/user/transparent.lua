return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("transparent").setup({
      exclude_groups = {
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
