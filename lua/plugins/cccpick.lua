return {
  "uga-rosa/ccc.nvim",
  cmd = {
    "CccPick",
    "CccConvert",
    "CccHighlighterEnable",
    "CccHighlighterDisable",
  },
  config = function()
    require("ccc").setup({
      highlighter = {
        auto_enable = false, -- we control it manually
      },
    })
  end,
}
