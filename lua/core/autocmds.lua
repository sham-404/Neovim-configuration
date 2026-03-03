local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 80 })
  end,
})

------------------------------------------------------------------
-- Lualine highlight persistence (final timing-safe version)
------------------------------------------------------------------

local group = vim.api.nvim_create_augroup("LualineHighlightFix", { clear = true })

local function apply_lualine_highlights()
  local function hl(name, fg)
    vim.api.nvim_set_hl(0, name, { fg = fg, bg = "#010101" })
  end

  hl("LualineProg", "#89b4fa")

  hl("LualineBatOk", "#a6e3a1")
  hl("LualineBatMid", "#f9e2af")
  hl("LualineBatLow", "#f38ba8")
  hl("LualineBatChg", "#89dceb")

  hl("LualineRamOk", "#cdd6f4")
  hl("LualineRamMid", "#f9e2af")
  hl("LualineRamHigh", "#f38ba8")

  hl("LualineSep", "#cdd6f4")

  local ok, lualine = pcall(require, "lualine")
  if ok then
    lualine.refresh()
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    -- run AFTER colorscheme fully finishes
    vim.defer_fn(apply_lualine_highlights, 50)
  end,
}) -- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     vim.opt.guicursor = "n-v-c:block-Cursor,i:block-iCursor,r:block-Cursor"
--   end
-- })
