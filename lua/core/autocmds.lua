local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 80 })
  end,
})

-- vim.api.nvim_create_autocmd("VimEnter", {
--   callback = function()
--     vim.opt.guicursor = "n-v-c:block-Cursor,i:block-iCursor,r:block-Cursor"
--   end
-- })
